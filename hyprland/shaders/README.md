# shaders

Custom GLSL screen shaders applied by Hyprland via the `decoration { screen_shader = ... }` option in [../hyprland.conf](../hyprland.conf).

## Files

| File | Effect |
| --- | --- |
| [vibrance.glsl](vibrance.glsl) | Boosts color saturation to **1.9** — a "digital vibrance" look that punches up the Yoake palette |

## How it works

`vibrance.glsl` samples each pixel, computes its perceived luma using BT.601 weights `(0.299, 0.587, 0.114)`, then mixes the original color back over that gray at a 1.9 ratio. Anything > 1.0 oversaturates; 1.3–1.6 is the typical "digital vibrance" range and 1.9 pushes it further.

Tweak the `saturation` constant in the shader to taste:

- `1.0` → no change
- `1.3 – 1.6` → subtle vibrance
- `1.9` → current, punchy look
- `< 1.0` → desaturated

After editing, reload Hyprland (`hyprctl reload`) to apply.
