import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

class ExampleTriangle extends Example {
  @override
  run() {
    if (!sdlInit(SDL_INIT_VIDEO)) {
      print(sdlGetError());
      return;
    }

    Pointer<SdlWindow> window = nullptr;
    Pointer<SdlRenderer> renderer = nullptr;

    sdlSetHint(SDL_HINT_RENDER_VSYNC, '1');
    window = SdlWindowEx.create(title: 'draw triangle', w: 1024, h: 768);
    if (window == nullptr) {
      print(sdlGetError());
      sdlQuit();
      return;
    }

    renderer = window.createRenderer();
    if (renderer == nullptr) {
      print(sdlGetError());
      window.destroy();
      sdlQuit();
      return;
    }
    var lines = <Point<double>>[
      Point(320, 200),
      Point(300, 240),
      Point(340, 240),
      Point(320, 200),
    ];

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

      renderer
        ..setDrawColor(0, 0, 0, SDL_ALPHA_OPAQUE)
        ..clear()
        ..setDrawColor(255, 255, 255, SDL_ALPHA_OPAQUE)
        ..lines(lines);

      renderer.present();
    }

    if (event != nullptr) {
      event.callocFree();
    }

    if (renderer != nullptr) {
      renderer.destroy();
    }

    if (window != nullptr) {
      window.destroy();
    }

    sdlQuit();
  }
}
