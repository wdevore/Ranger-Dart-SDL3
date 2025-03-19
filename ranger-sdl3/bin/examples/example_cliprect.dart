import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

class ExampleClipRect extends Example {
  static final double clipRectSize = 150;
  static final int clipRectSpeed = 100; // pixels per second
  final int width = 640;
  final int height = 480;
  final Pointer<SdlFPoint> clipRectPosition = calloc<SdlFPoint>();
  final Pointer<SdlFPoint> clipRectDirection = calloc<SdlFPoint>();
  final int charsize = SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE;
  Rectangle<double> clipRect = Rectangle<double>(
    0.0,
    0.0,
    clipRectSize,
    clipRectSize,
  );

  @override
  run() {
    if (!sdlInit(SDL_INIT_VIDEO)) {
      print(sdlGetError());
      return;
    }

    sdlSetHint(SDL_HINT_RENDER_VSYNC, '1');

    if (!sdlCreateWindowAndRenderer(
      'clipping rectangle',
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

    Pointer<SdlFRect> rect = calloc<SdlFRect>();
    int lastTime = sdlGetTicks();
    clipRectDirection.ref.x = 1.0;
    clipRectDirection.ref.y = 1.0;

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
      // Clip
      // ------------------------------------------------------------------
      // print('${cliprectPosition.ref.x}, ${cliprectPosition.ref.y}');
      // Rectangle<double> clipRect = Rectangle<double>(
      //   clipRectPosition.ref.x.roundToDouble(),
      //   clipRectPosition.ref.y.roundToDouble(),
      //   clipRectSize,
      //   clipRectSize,
      // );

      clipRect = clipRect.setX((clipRectPosition.ref.x));
      clipRect = clipRect.setY((clipRectPosition.ref.y));

      // print(clipRect);

      int now = sdlGetTicks();
      // seconds since last iteration
      double elapsed = ((now - lastTime).toDouble()) / 1000.0;
      double distance = elapsed * clipRectSpeed;

      // Set a new clipping rectangle position
      clipRectPosition.ref.x += distance * clipRectDirection.ref.x;
      if (clipRectPosition.ref.x < 0.0) {
        clipRectPosition.ref.x = 0.0;
        clipRectDirection.ref.x = 1.0;
      } else if (clipRectPosition.ref.x >= (width - clipRectSize)) {
        clipRectPosition.ref.x = (width - clipRectSize) - 1;
        clipRectDirection.ref.x = -1.0;
      }

      clipRectPosition.ref.y += distance * clipRectDirection.ref.y;
      if (clipRectPosition.ref.y < 0.0) {
        clipRectPosition.ref.y = 0.0;
        clipRectDirection.ref.y = 1.0;
      } else if (clipRectPosition.ref.y >= (height - clipRectSize)) {
        clipRectPosition.ref.y = (height - clipRectSize) - 1;
        clipRectDirection.ref.y = -1.0;
      }

      pRenderer.value.setClipRect(clipRect);

      lastTime = now;

      // ------------------------------------------------------------------
      // Render
      // ------------------------------------------------------------------
      pRenderer.value
        ..setDrawColor(33, 33, 33, SDL_ALPHA_OPAQUE)
        ..clear();

      pRenderer.value.setDrawColor(255, 128, 0, SDL_ALPHA_OPAQUE);
      rect.ref.x = clipRect.left + 1;
      rect.ref.y = clipRect.top + 1;
      rect.ref.w = clipRect.width - 2;
      rect.ref.h = clipRect.height - 2;
      sdlRenderRect(pRenderer.value, rect);

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

      // BUG!!! Scaling confuses the clipping rectangle.
      pRenderer.value.setDrawColor(0, 128, 255, SDL_ALPHA_OPAQUE);
      sdlSetRenderScale(pRenderer.value, 2.0, 2.0);
      sdlRenderDebugText(pRenderer.value, 30, 140, "It can be scaled.");
      sdlSetRenderScale(pRenderer.value, 1.0, 1.0);

      sdlSetRenderDrawColor(pRenderer.value, 255, 255, 255, SDL_ALPHA_OPAQUE);
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

      pRenderer.value.present();
    }

    rect.callocFree();
    clipRectPosition.callocFree();
    clipRectDirection.callocFree();

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
