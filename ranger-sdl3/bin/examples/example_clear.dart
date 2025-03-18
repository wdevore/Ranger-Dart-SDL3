import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

class ExampleClear extends Example {
  @override
  run() {
    if (!sdlInit(SDL_INIT_VIDEO)) {
      print(sdlGetError());
      return;
    }

    sdlSetHint(SDL_HINT_RENDER_VSYNC, '1');

    Pointer<Pointer<SdlWindow>> pWindow = calloc();
    Pointer<Pointer<SdlRenderer>> pRenderer = calloc();

    if (!sdlCreateWindowAndRenderer(
      'clear',
      1024,
      768,
      0,
      pWindow,
      pRenderer,
    )) {
      print(sdlGetError());
      sdlQuit();
      return;
    }

    event = calloc<SdlEvent>();

    var running = true;
    while (running) {
      while (event.poll()) {
        switch (event.type) {
          case SDL_EVENT_QUIT:
            running = false;
            break;
          default:
            break;
        }
      }

      // ------------------------------------------------------------------
      // Render
      // ------------------------------------------------------------------
      double now = sdlGetTicks().toDouble() / 1000.0;
      // choose the color for the frame we will draw. The sine wave trick makes
      // it fade between colors smoothly.
      double red = (0.5 + 0.5 * sdlSin(now));
      double green = (0.5 + 0.5 * sdlSin(now + SDL_PI_D * 2 / 3));
      double blue = (0.5 + 0.5 * sdlSin(now + SDL_PI_D * 4 / 3));

      pRenderer.value
        ..setDrawColorFloat(red, green, blue, SDL_ALPHA_OPAQUE_FLOAT)
        ..clear();

      pRenderer.value.present();
    }

    if (event != nullptr) {
      event.callocFree();
    }

    // We don't need to destroy window and renderer because SDL will do it
    // because we called the combin window/render create method.

    pRenderer.callocFree();
    pWindow.callocFree();

    sdlQuit();
  }
}
