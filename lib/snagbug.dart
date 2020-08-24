import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stack_trace/stack_trace.dart';

enum EveryErrorSource {
  Flutter,
  Isolate,
  Unknown,
  Zone,
}

typedef EveryErrorHandler = Function(Object, StackTrace,
    {EveryErrorSource source});

class Snagbug {
  static const MethodChannel _channel =
      const MethodChannel('actionsprout.com/snagbug');

  static Future<void> handleError(Object error, StackTrace stackTrace,
      {EveryErrorSource source}) {
    Trace.from(stackTrace);

    return _channel.invokeMethod<Map>('send_error', <String, dynamic>{
      'source': (source ?? EveryErrorSource.Unknown).toString(),
      'error': error.toString(),
      'stack': stackTrace.toString(),
    });
  }

  static void handleEveryError(Function main,
      {EveryErrorHandler onError = handleError}) {
    runZonedGuarded<Future<void>>(() async {
      _wireUpFlutterErrorHandler(onError);
      _wireUpIsolateErrorHandler(onError);

      main();
    }, _generateZoneGuard(onError));
  }

  static void _wireUpFlutterErrorHandler(EveryErrorHandler handler) {
    FlutterError.onError = (details) {
      handler(
        details.exception,
        details.stack,
        source: EveryErrorSource.Flutter,
      );
    };
  }

  static void _wireUpIsolateErrorHandler(EveryErrorHandler handler) {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final errorAndStackTrace = pair as List;

      handler(
        errorAndStackTrace.first as Object,
        errorAndStackTrace.last as StackTrace,
        source: EveryErrorSource.Isolate,
      );
    }).sendPort);
  }

  static Function(Object, StackTrace) _generateZoneGuard(
    EveryErrorHandler handler,
  ) =>
      (error, stack) => handler(error, stack, source: EveryErrorSource.Zone);
}
