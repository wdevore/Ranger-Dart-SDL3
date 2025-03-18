# Tasks
- Maths
  - Vectors ✓
  - Matrixs ✓
  - Velocity ✓
  - AffineTransform ✓
  - Velocity ✓
    - Move ship around
  - Zoom ✓
    - Zoom at cursor ✓
  - Interpolation
  - Transforms ✓
- Nodes ✓
  - Node dragging ✓ *with zoom*
- Geometry
  - Point ✓
  - Intersecting
    - Cursor enter ✓
- IO
  - Gestures ✓
    - Cursor icon
  - Keyboard **<--Working**
- Fonts ✓
  - Vector **Finish alphas**
    - Static text ✓
    - Dynamic text ✓
- Audio
- GUI framework
- *Textures* (optional)

# Configurations

## Upgrading
If you get the following exception:
```
The current Dart SDK version is 3.7.0.

Because ranger_sdl3 depends on sdl3 >=1.4.1 which requires SDK version >=3.7.1 <4.0.0, version solving failed.
```

You need to run 
```sh
Flutter upgrade
```

## Exceptions
You must have LD_LIBRARY_PATH configured in your .bashrc. This is the location of all the SDL libraries.

```sh
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
```
