import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

class ExampleDebugText extends Example {
  final int width = 640;
  final int height = 480;
  final int charsize = SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE;

  @override
  run() {
    if (!sdlInit(SDL_INIT_VIDEO)) {
      print(sdlGetError());
      return;
    }

    sdlSetHint(SDL_HINT_RENDER_VSYNC, '1');

    if (!sdlCreateWindowAndRenderer(
      'debug text',
      640,
      480,
      0,
      pWindow,
      pRenderer,
    )) {
      print(sdlGetError());
      sdlQuit();
      return;
    }

    event = calloc<SdlEvent>();

    List<Point<double>> points = [];

    // set up some random points
    for (var i = 0; i < 500; i++) {
      Point<double> p = Point(
        (sdlRandf() * 440.0) + 100.0,
        (sdlRandf() * 280.0) + 100.0,
      );
      points.add(p);
    }

    Pointer<SdlFRect> rect = calloc<SdlFRect>();

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
      pRenderer.value
        ..setDrawColor(0, 0, 0, SDL_ALPHA_OPAQUE)
        ..clear();

      sdlSetRenderDrawColor(pRenderer.value, 255, 255, 255, SDL_ALPHA_OPAQUE);
      sdlRenderDebugText(pRenderer.value, 272, 100, "Hello world!");
      sdlRenderDebugText(pRenderer.value, 224, 150, "This is some debug text.");

      sdlSetRenderDrawColor(pRenderer.value, 51, 102, 255, SDL_ALPHA_OPAQUE);
      sdlRenderDebugText(
        pRenderer.value,
        184,
        200,
        "You can do it in different colors.",
      );
      sdlSetRenderDrawColor(pRenderer.value, 255, 255, 255, SDL_ALPHA_OPAQUE);

      sdlSetRenderScale(pRenderer.value, 4.0, 4.0);
      sdlRenderDebugText(pRenderer.value, 14, 65, "It can be scaled.");
      sdlSetRenderScale(pRenderer.value, 1.0, 1.0);

      sdlRenderDebugText(
        pRenderer.value,
        64,
        350,
        "This only does ASCII chars. So this laughing emoji won't draw: 🤣",
      );

      String msg =
          '(This program has been running for ${(sdlGetTicks() / 1000).toStringAsPrecision(2)} seconds.)';

      sdlRenderDebugText(
        pRenderer.value,
        ((width - (charsize * 46)) / 2),
        400,
        msg,
      );

      // ----- Not properly supported by the bindings :-(
      // sdlRenderDebugTextFormat(
      //   pRenderer.value,
      //   ((width - (charsize * 46)) / 2),
      //   400,
      //   '(This program has been running for $SDL_PRIu64 seconds.)', sdlGetTicks() / 1000,
      // );

      pRenderer.value.present();
    }

    rect.callocFree();

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
