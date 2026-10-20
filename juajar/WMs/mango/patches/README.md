# Screen zoom patch for mango (mangowm) 0.18.2

## What

Compositor-level live screen zoom: a Hyprland-style magnifier over the entire
rendered screen that follows the cursor in real time, on every output at
once. This is the port of the MangoWC-Zoom patch (MangoWC repo,
`patches/zoom.patch`) rewritten for mango 0.18.2 internals, with one fix on
top of upstream: the render viewport is cursor-anchored instead of
cursor-centered + clamped (see below), which removes the pointer click/aim
drift the upstream patch shows near off-center and edge positions.

## How

One shared zoom level (1.0 .. config.zoom_max) is animated toward a target
with an ease-out each rendered frame. On every output commit
(`mango_scene_output_commit`, src/manage/monitor.c):

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
* `handle_output_frame()` calls `screen_zoom_update()` once per raw frame
  (eases the level, frees the swapchain when settled at 1.0), keeps the
  skip-frame bypass off while the zoom active, and keeps re-scheduling
  vblank-paced frames so the viewport chases the cursor without a busy loop.

Upstream IDs, struct fields and API names are untouched except the insertion
sites, so future mango rebases stay small.

## Config keys (config.conf)

```
zoom_max   = 4.0   # cap, 1.0 makes the zoom a no-op
zoom_speed = 0.2   # step per zoom_in / zoom_out press
```

## New dispatchers (binds.conf / axisbind)

```
screen_zoom_in,0        # target += zoom_speed
screen_zoom_out,0       # target -= zoom_speed
screen_zoom_reset,0     # target = 1.0
screen_zoom_set,2.5     # target pinned to a value
screen_zoom_toggle,0    # 1.0 <-> zoom_max
```

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
| toggle between off and zoom_max               | SUPER+Z                  |
| fine scroll zoom                             | SUPER+SHIFT + mouse wheel |
| step in / out while zoomed                   | SUPER+SHIFT+X / SUPER+SHIFT+C |
| reset to 1.0                                 | SUPER+SHIFT+0            |

Note: plain SUPER wheel intentionally stays on tag view switching; zoom never
took the wheel without Shift.

## Files

```
include/mango/manage/zoom.h    new: public zoom API
src/manage/zoom.c              new: animation, swapchain, render hook, dispatchers
src/manage/monitor.c           hooks in mango_scene_output_commit + handle_output_frame
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
