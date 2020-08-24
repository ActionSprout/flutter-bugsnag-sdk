import 'package:stack_trace/stack_trace.dart';

Map encodeEvent(Object error, StackTrace stackTrace) {
  return <String, dynamic>{
    'type': error.runtimeType.toString(),
    'message': error.toString(),
    'stack': _encodeStack(Trace.from(stackTrace)),
  };
}

List<Map<String, String>> _encodeStack(Trace trace) => trace.frames
    .map((frame) => <String, String>{
          'file': frame.library,
          'member': frame.member,
        })
    .toList();
