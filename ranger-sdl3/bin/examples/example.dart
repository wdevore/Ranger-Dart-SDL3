import 'dart:ffi';
import 'package:sdl3/sdl3.dart';

abstract class Example {
  Pointer<SdlWindow> window = nullptr;
  Pointer<SdlRenderer> renderer = nullptr;
  Pointer<SdlEvent> event = nullptr;

  run();
}
