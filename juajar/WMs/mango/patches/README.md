# mango (mangowm) 0.18.2 patches

Three patch files, applied by ../package.nix on top of the pinned upstream
mango 0.18.2 rev:

* `screen-zoom.patch` - the live screen zoom feature
* `switcher-warp.patch` - cursor warp after alt-tab focus (see bottom)
* `stream-privacy.patch` - per-window "hide from screen share" (shield),
  plus the wlroots hook patch `wlroots-capture-privacy.patch` wired into
  package.nix's wlroots override, NOT into the mango patch list.

 -------------------------------------------------------------------------------

# Screen zoom patch (screen-zoom.patch)

## What

Compositor-level live screen zoom: a Hyprland-style magnifier over the
rendered screen that follows the cursor in real time. This is the port of
the MangoWC-Zoom patch (MangoWC repo, `patches/zoom.patch`) rewritten for
mango 0.18.2 internals, with several fixes on top of upstream:

* The render viewport is cursor-anchored instead of cursor-centered +
  clamped, which removes the pointer click/aim drift the upstream patch
  shows near off-center and edge positions.
* Zoom is per monitor and follows the pointer: only the output under the
  pointer is magnified; moving to another screen hands the zoom over there
  (same target) and the previous screen eases back to 1.0.
* Easing is snappier than upstream (0.28 per frame, 0.005 settle) so wheel
  ratchets finish cleanly instead of creeping.
* Streaming friendly: while a zoomed monitor sits idle (no animation, no
  pointer movement) the normal frame skip logic applies again, so output
  captures are not handed a fresh frame every refresh. While zoomed, the
  commit reports FULL buffer damage: capture pipelines
  (ext-image-copy-capture, e.g. PipeWire/Discord shares) copy only the
  damaged region into their buffers, and a swapped zoom buffer always
  recomposes the whole frame, so stale-region splicing must be avoided.
  A capture session that explicitly requests a frame while zoomed at rest
  always gets one rendered (wlr_output needs_frame is honored in the skip
  path), instead of being left waiting.

## How

Zoom state lives on `struct Monitor` (zoom_level, zoom_target,
zoom_animating, zoom_pointer_dirty, plus the per monitor swapchain), a
shared zoom config (`zoom_max`, `zoom_speed`). Dispatchers resolve the
target to the monitor under the pointer; SUPER+SHIFT+0 clears all
monitors. On every output commit (`mango_scene_output_commit`,
src/manage/monitor.c):

* `wlr_scene_output_build_state()` renders the whole scene into a buffer.
* `screen_zoom_render()` (src/manage/zoom.c) samples that buffer through a
  viewport of `1 / zoom_level` size anchored at
  `vx = cx * (zoom - 1) / zoom` (output-scale corrected). The anchor is
  solved so the cursor's own point maps onto the cursor's screen position:
  content under the pointer icon is exactly what receives the click, at
  every zoom level and position. For `0 <= cx <= width` and `zoom >= 1` the
  viewport provably stays inside the buffer (`vx >= 0`,
  `vx + vw <= width`), so the view chases the pointer proportionally at the
  screen edges instead of pinning there; the remaining clamps are float
  rounding insurance only. The magnified view is drawn bilinear-filtered
  over an opaque black clear and swapped into the pending output state.
* While zoomed, tearing page flips are disabled in the commit path.
* `handle_output_frame()` calls `screen_zoom_update(m)` once per raw frame
  (eases the level, frees the swapchain when settled at 1.0), bypasses the
  skip-frame logic only while `screen_zoom_busy(m)` (animating or pointer
  moved since the last commit), and keeps re-scheduling vblank-paced
  frames only while animating.
* `pointer_process_motion()` marks the pointer-active zoomed monitor via
  `screen_zoom_mark_pointer_activity()`, which also pokes the output so a
  resting zoomed screen starts rendering again when the pointer moves.

Upstream IDs, struct fields and API names are untouched except the insertion
sites, so future mango rebases stay small.

## Config keys (config.conf)

```
zoom_max   = 4.0   # cap, 1.0 makes the zoom a no-op
zoom_speed = 1.0   # per notch/key step: 1.0 -> 2.0 -> 3.0 -> 4.0 (3 scrolls)
```

## New dispatchers (binds.conf / axisbind)

```
screen_zoom_in,0        # target += zoom_speed        (monitor under cursor)
screen_zoom_out,0       # target -= zoom_speed
screen_zoom_reset,0     # 1.0 on EVERY monitor (clean fallback)
screen_zoom_set,2.5     # target pinned to a value
screen_zoom_toggle,0    # 1.0 <-> zoom_max on the cursor's monitor
```

Migration semantics (zoom_follows-pointer):

* `screen_zoom_mark_pointer_activity()`, called from
  `pointer_process_motion()` on every pointer epoch, runs
  `zoom_migrate_to()`: crossing to another monitor while one is zoomed
  moves the zoom target there and eases the old monitor to 1.0.
* `in / out / set / toggle` resolve the pointer's monitor and call
  `zoom_drop_others()`: any other screen that still holds zoom is eased to
  1.0, then the pressed action applies to the pointer's monitor. This keeps
  the "one zoomed screen" invariant when bindings are used without a real
  pointer epoch.
* `screen_zoom_destroy()` clears the owner pointer (output hotplug).

In-tree bindings (binds.conf):

```
bind=SUPER,Z,screen_zoom_toggle,0                 # on: cap, off: reset
bind=SUPER+SHIFT,X,screen_zoom_in,0               # step in by zoom_speed
bind=SUPER+SHIFT,C,screen_zoom_out,0              # step out by zoom_speed
bind=SUPER+SHIFT,0,screen_zoom_reset,0            # back to 1.0
axisbind=SUPER+SHIFT,UP,screen_zoom_in            # wheel: step in
axisbind=SUPER+SHIFT,DOWN,screen_zoom_out         # wheel: step out
```

Usage matrix:

| Action                                        | Binding                  |
|-----------------------------------------------|--------------------------|
| toggle between off and zoom_max (cursor screen)| SUPER+Z                 |
| fine scroll zoom                              | SUPER+SHIFT + mouse wheel |
| step in / out while zoomed                    | SUPER+SHIFT+X / SUPER+SHIFT+C |
| clear all screens back to 1.0                 | SUPER+SHIFT+0            |

Note: plain SUPER wheel intentionally stays on tag view switching; zoom never
took the wheel without Shift. One screen zooms at a time (the one under the
pointer) and keeps its level while you work on another; SUPER+SHIFT+0 clears
everything. For sharing: zoom is capture-friendly when idle, so a Discord
screen share of a resting zoomed monitor stays smooth.

## Files

```
include/mango/manage/zoom.h    new: public zoom API
src/manage/zoom.c              new: per-monitor animation, swapchain, render, dispatchers
include/mango/manage/monitor.h Monitor struct fields (zoom state + swapchain)
src/manage/monitor.c           hooks: new_output init, commit, frame loop, destroy
src/input/pointer.c            pointer-activity marker for the idle skip
src/config/option_defs.c       zoom_max / zoom_speed parse, defaults, clamping
src/config/binding_parse.c     dispatcher registration
include/mango/config/parse.h   Config struct fields
```

meson globs `src/**/*.c`, so the new zoom.c needs no build file changes.

## Rebase notes

* Regenerate with: `cd /tmp/opencode/mango018 && git add -A && git diff --cached`
  against a clean checkout pinned to the current mango rev.
* wlroots 0.20 API specifics: `wlr_swapchain_acquire(chain)` (one arg),
  `wlr_renderer_get_texture_formats(renderer, alloc->buffer_caps)`,
  filter enum `WLR_SCALE_FILTER_BILINEAR`, render pass clip fields take a
  `pixman_region32_t *` directly.

 -------------------------------------------------------------------------------

# Switcher warp patch (switcher-warp.patch)

## What

Alt-tab (`bind=Alt,Tab,switcher,...`) focuses the picked window but leaves
the cursor where it was, so with `sloppy_focus=1` the next mouse movement
steals focus back to whatever window sat under the stale cursor position
instead of the alt-tabbed one. The patch makes `switcher_commit_client()`
honor `warp_cursor` like every other focus path (focusdir, focusstack,
focusmon, tagmon, exchange in src/dispatch/bind.c and src/manage/client.c):
after `client_focus()` it calls `pointer_warp_to_client(tc)`, which warps
to the target window's center and re-runs `pointer_process_motion()` so
sloppy focus re-evaluates at the NEW position and stays on the picked
window.

## How

Two additions in src/switcher/switcher.c:

* `#include "mango/input/pointer.h"`
* in `switcher_commit_client()`:
  ```
  if (config.warpcursor)
      pointer_warp_to_client(tc);
  ```

`pointer_warp_to_client` guards on `INSIDEMON(c)` (window inside its
monitor), true for normal tiled/floating windows. Wheel focus cycling binds
(`axisbind=SUPER+CTRL,UP/DOWN,focusstack,prev,next` in binds.conf) were
already consistent: `focus_stack()` in src/dispatch/bind.c warps under
`warp_cursor` and `get_next_stack_client()` only walks clients with
`VISIBLEON(next, c->mon)` (same monitor, visible tags, wraps around), so
SUPER+CTRL wheel cycles inside the current workspace without crossing
screens or workspaces.

## Rebase notes

Generated separately from the zoom patch: in /tmp/opencode/mango018 commit
the zoom state first (`git add -A && git commit`), edit switcher.c, then
`git diff > patches/switcher-warp.patch`.

 -------------------------------------------------------------------------------

# Stream privacy patch (stream-privacy.patch + wlroots-capture-privacy.patch)

## What

Per-window "hide from screen share" (the shield feature mango 0.18.2
ships renamed and extended): windows flagged `shield_when_capture` - via
the `shield` window rule, or toggled live on the focused window with
`toggleshield` (SUPER+CTRL+SHIFT+G in binds.conf) - stay fully visible
and clickable for the user but read as opaque black rectangles inside
screen shares. Borders/extframes stay, so the viewer sees framed black
boxes exactly like Hyprland-style "hide from capture".

Difference vs stock mango, which paints the same black rect into the
scene: the scene rect is part of the one committed output buffer, so the
USER also sees the blackout whenever any capture session is live. Stock
plots black at swap time; this patch splits the two views instead.

How it works, since Wayland captures fundamentally read the committed
output buffer (`ext/image_capture_source_v1/output.c` listens to commit
and forwards `state->buffer`; `wlr-screencopy` does the same at 0.20):

* `wlroots-capture-privacy.patch` adds one hook to wlroots:
  `wlr_output_set_ext_capture_privacy(output, render_fn, data)` (public
  header decl + struct fields + setter + reset in wlr_output_finish);
  the ext output capture source's frame emission consults the hook and,
  when the compositor returns a buffer, hands THAT buffer (with full
  damage) to capture sessions instead of the committed one. Sessions
  consume frame-event buffers synchronously (verified against
  `wlr_ext_image_copy_capture_v1.c`), so a compositor-owned rotating
  swapchain buffer is handed out locked and unlocked inside the patch
  (unlock after the frame event fan-out). Frame events without an
  attached session carry no consumer; the hook still fires but does
  nothing.
* `stream-privacy.patch` (mango side) registers that hook per monitor:
  `stream_privacy_render()` collects the shield boxes of flagged clients
  visible on that monitor, maps them from layout coords into committed
  buffer pixels (output scale; zoom-aware via a new
  `screen_zoom_map_box()` export that folds in the viewport
  `screen_zoom_render` cached for the very commit being captured), blits
  the committed buffer into a per-monitor privacy swapchain and fills
  each box opaque black. No shielded window or no active session on that
  output = hook returns NULL, upstream passthrough, zero rendering.
* Session bookkeeping reuses mango's capture session tracker
  (`handle_ext_image_copy_capture_new_session`/`handle_session_destroy`
  in src/manage/misc.c): each tracker now remembers its output, so the
  per-monitor session counts start/stop privacy rendering and the last
  session's end frees its swapchain. Sessions also poke
  `wlr_output_update_needs_frame` so toggling shield mid-share is
  visible on the next frame.
* The on-screen shield scene rect (`client_draw_shield`) is retired as
  rect rendering; its geometry math is extracted into
  `client_shield_box()` (src/animation/client.c) which privacy uses.
  The black rect node stays disabled; c->shield remains structural.

Coverage notes:

* ext-image-copy-capture (PipeWire/desktop portals - your
  xdg-desktop-portal-wlr 0.8+/Discord flow) is covered.
* Classic `wlr-screencopy` (grim, OBS screencopy backend) still copying
  the raw committed buffer is NOT privacy-filtered: `active_capture_count`
  never counted screencopy anyway, so shielded windows keep their real
  content in screenshots - matching stock mango's semantics.
* Window (toplevel) shares carry the window's own subtree only; stock
  mango already DENIES the capture request for shielded windows
  (`handle_new_foreign_toplevel_capture_request` returns early). Sharing
  OTHER windows is unaffected.
* Overview mode skips shield boxes (mini cards are a separate scene
  tree); layer surfaces keep stock behavior.
* Zoom interplay: when the captured monitor is zoomed, rects track the
  zoom viewport of the SAME commit (zoom render caches viewport state;
  mango_scene_output_commit invalidates it per frame). During ease-out
  frames the box may lead/lag slightly.

## Config

* `binds.conf`: `bind=SUPER+CTRL+SHIFT,G,toggleshield`.
* `rule.conf`: `window_rule=app_id:^org.keepassxc.KeePassXC$,shield_when_capture:1`
  (commented example), documented in the header comment there.

## Files

* `wlroots-capture-privacy.patch` (against wlroots 0.20.0 AND 0.20.1,
  tested both): include/wlr/types/wlr_output.h (typedef + 2 struct
  fields + decl), types/output/output.c (setter + reset in finish),
  types/ext_image_capture_source_v1/output.c (hook call in the commit
  listener).
* `stream-privacy.patch` (mango): include/mango/manage/stream_privacy.h
  + src/manage/stream_privacy.c (new), Monitor fields
  (include/mango/manage/monitor.h), hook registration + teardown + zoom
  viewport cache invalidation + `screen_zoom_map_box()` export
  (zoom.c/.h), `client_shield_box()` (animation/client.c/.h), session
  tracker output mapping (manage/misc.c), `toggleshield` dispatcher
  (config/binding_parse.c).

## Rebase notes

* wlroots hook: /tmp/opencode/wlroots020 (0.20.1 git tree, snapshot
  985e627 pristine) - `git diff 985e627..HEAD` regenerate against the
  nixpkgs-pinned wlroots rev when it moves; validated by building
  `wlroots_0_20.overrideAttrs { patches; }` on both 0.20.0 and 0.20.1.
* mango: /tmp/opencode/mango018; export via
  `git diff 01cda615 -- src include ':(exclude)src/switcher'` (zoom
  snapshot base minus the switcher warp hunks, which live in their own
  patch).
