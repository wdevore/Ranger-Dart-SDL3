import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

import 'example.dart';

// track everything as parallel arrays instead of a array of structs,
// so we can pass the coordinates to the renderer in a single function call.

class ExamplePoints extends Example {
  // move at least this many pixels per second.
  final int minPixelsPerSecond = 30;
  // move this many pixels per second at most.
  final int maxPixelsPerSecond = 60;
  final int numPoints = 500;
  final int width = 640;
  final int height = 480;

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
      'points',
      width,
      height,
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
    List<double> pointSpeeds = [];

    // set up some random points
    for (var i = 0; i < numPoints; i++) {
      Point<double> p = Point(sdlRandf() * width, sdlRandf() * height);
      points.add(p);
      pointSpeeds.add(
        minPixelsPerSecond +
            (sdlRandf() * (maxPixelsPerSecond - minPixelsPerSecond)),
      );
    }

    int lastTime = sdlGetTicks();

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
      int now = sdlGetTicks();
      // seconds since last iteration
      double elapsed = ((now - lastTime).toDouble()) / 1000.0;

      // Let's move all our points a little for a new frame.
      List<Point<double>> nPoints = [];
      double nx = 0.0;
      double ny = 0.0;
      for (var i = 0; i < numPoints; i++) {
        final double distance = elapsed * pointSpeeds[i];

        nx = points[i].x + distance;
        ny = points[i].y + distance;

        if ((nx >= width) || (ny >= height)) {
          // off the screen; restart it elsewhere!
          if (sdlRandf() > 0.5) {
            nx = sdlRandf() * width;
            ny = 0.0;
          } else {
            nx = 0.0;
            ny = sdlRandf() * height;
          }
          pointSpeeds[i] =
              minPixelsPerSecond +
              (sdlRandf() * (maxPixelsPerSecond - minPixelsPerSecond));
        }

        nPoints.add(Point(nx, ny));
      }

      lastTime = now;

      // start with a blank canvas.
      pRenderer.value
        ..setDrawColor(0, 0, 0, SDL_ALPHA_OPAQUE)
        ..clear();

      // Method #1 to set draw color
      sdlSetRenderDrawColor(
        pRenderer.value,
        255,
        255,
        255,
        SDL_ALPHA_OPAQUE,
      ); // white, full alpha
      // Or Method #2
      // pRenderer.value.setDrawColor(
      //   255,
      //   255,
      //   255,
      //   SDL_ALPHA_OPAQUE,
      // ); // blue, full alpha

      pRenderer.value.points(nPoints);

      // move new points into previous points
      points = [];
      for (var i = 0; i < numPoints; i++) {
        points.add(nPoints[i]);
      }

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
