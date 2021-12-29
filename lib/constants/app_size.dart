// import 'dart:developer';
import 'dart:ui';

dynamic width = window.physicalSize.width / window.devicePixelRatio;
dynamic height = window.physicalSize.height / window.devicePixelRatio;

dynamic getFontSize(double size) {
  var value = (window.physicalSize.width) / (window.devicePixelRatio);
  // log("$value");
  return value * (size * 0.8) / 307;
}

double getWidth(double size) {
  var value = window.physicalSize.width / window.devicePixelRatio;
  // log("width $value");
  return value * (size) / 384;
}

dynamic getHeight(double size) {
  var value = (window.physicalSize.height) / (window.devicePixelRatio);
  // log("height $value");
  return value * (size * 0.65) / 762;
}
