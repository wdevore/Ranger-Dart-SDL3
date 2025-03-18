import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl3/sdl3.dart';

abstract class Example {
  Pointer<Pointer<SdlWindow>> pWindow = calloc();
  Pointer<Pointer<SdlRenderer>> pRenderer = calloc();

  // Pointer<SdlWindow> window = nullptr;
  // Pointer<SdlRenderer> renderer = nullptr;
  Pointer<SdlEvent> event = nullptr;

  run();
}
