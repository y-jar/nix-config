# Screen zoom patch for mango (mangowm) 0.18.2

## What

Compositor-level live screen zoom: a Hyprland-style magnifier over the entire
rendered screen that follows the cursor in real time, on every output at
once. This is the port of the MangoWC-Zoom patch (MangoWC repo,
`patches/zoom.patch`) rewritten for mango 0.18.2 internals.

## How

One shared zoom level (1.0 .. config.zoom_max) is animated toward a target
with an ease-out each rendered frame. On every output commit
(`mango_scene_output_commit`, src/manage/monitor.c):

* `wlr_scene_output_build_state()` renders the whole scene into a buffer.
* `screen_zoom_render()` (src/manage/zoom.c) samples that buffer through a
  clamped viewport of `1 / zoom_level` size, centered on the pointer
  (output-scale corrected, edges pinned to the buffer bounds), draws it
  bilinear-filtered scaled up over an opaque black clear, and swaps that
  zoom buffer into the pending output state.
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

In-tree bindings:

```
axisbind=SUPER+SHIFT,up,screen_zoom_in
axisbind=SUPER+SHIFT,down,screen_zoom_out
bind=SUPER+SHIFT,0,screen_zoom_reset
bind=SUPER,Z,screen_zoom_toggle
```

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
