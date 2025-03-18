import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

class ExamplePrimitives extends Example {
  @override
  run() {
    if (!sdlInit(SDL_INIT_VIDEO)) {
      print(sdlGetError());
      return;
    }

    sdlSetHint(SDL_HINT_RENDER_VSYNC, '1');

    if (!sdlCreateWindowAndRenderer(
      'primitives',
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
        ..setDrawColor(33, 33, 33, SDL_ALPHA_OPAQUE)
        ..clear();

      // draw a filled rectangle in the middle of the canvas.
      pRenderer.value.setDrawColor(
        0,
        0,
        255,
        SDL_ALPHA_OPAQUE,
      ); // blue, full alpha
      rect.ref
        ..x = 100
        ..y = 100
        ..w = 440
        ..h = 280;

      // draw a filled rectangle in the middle of the canvas.
      sdlRenderFillRect(pRenderer.value, rect);

      pRenderer.value.setDrawColor(
        255,
        0,
        0,
        SDL_ALPHA_OPAQUE,
      ); // blue, full alpha
      pRenderer.value.points(points);

      // draw a unfilled rectangle in-set a little bit.
      pRenderer.value.setDrawColor(
        0,
        255,
        0,
        SDL_ALPHA_OPAQUE,
      ); // green, full alpha
      rect.ref.x += 30;
      rect.ref.y += 30;
      rect.ref.w -= 60;
      rect.ref.h -= 60;
      sdlRenderRect(pRenderer.value, rect);

      // draw two lines in an X across the whole canvas.
      pRenderer.value.setDrawColor(
        255,
        255,
        0,
        SDL_ALPHA_OPAQUE,
      ); // yellow, full alpha
      sdlRenderLine(pRenderer.value, 0, 0, 640, 480);
      sdlRenderLine(pRenderer.value, 0, 480, 640, 0);

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
