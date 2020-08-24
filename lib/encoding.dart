import 'package:stack_trace/stack_trace.dart';

Map encodeEvent(Object error, StackTrace stackTrace) {
  return <String, dynamic>{
    'type': error.runtimeType.toString(),
    'message': error.toString(),
    'stack': _encodeStack(Trace.from(stackTrace)),
  };
}

List<Map<String, dynamic>> _encodeStack(Trace trace) => trace.frames
    .map((frame) => <String, dynamic>{
          'file': frame.library,
          'line': frame.line,
          'member': frame.member,
          'package': frame.package,
        })
    .toList();
