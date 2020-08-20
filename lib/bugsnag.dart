import 'dart:async';

import 'package:flutter/services.dart';

class Bugsnag {
  static const MethodChannel _channel =
      const MethodChannel('bugsnag');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
