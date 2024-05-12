# Enabling firefox hardware acceleration

## t480/Lenovo/Iris/8th gen intel
Well, here's some stuff.

### about:config
Note: These may not be necessary. Try installing the appropriate drivers/libraries and then restarting firefox. Remember to _reload_ about:support, the damn thing caches through firefox restarts.

1. Check `gfx.webrender.all` and set it to true.
1. Check `media.ffmpeg.vaapi.enabled` and set it to true.
1. Do _not_ set `layers.acceleration.force-enabled`, this was for GL stuff which is deprecated by WebRender.

### about:support
1. Under `Graphics` check the `Compositor`. if it's set to `WebRender` then hardware is in use. (If it isn't using HA, then it will show something like `WebRender (Software)`.)
1. Check `Driver Version`, `Driver Renderer`, and under `GPU` check out the `Driver Vendor`.

### Notes
https://bugzilla.mozilla.org/show_bug.cgi?id=1491303
https://www.reddit.com/r/linux4noobs/comments/xhzwy8/how_to_enable_hardware_acceleration_for_intel/
https://www.reddit.com/r/debian/comments/16bu7a7/video_acceleration_with_debian_12_and_firefox/
https://www.reddit.com/r/linux/comments/xcikym/tutorial_how_to_enable_hardware_video/


