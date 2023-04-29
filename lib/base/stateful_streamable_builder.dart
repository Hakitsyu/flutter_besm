import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_besm/base/stateful_stream_consumer.dart';

import 'contracts/stateful_stremable.dart';

typedef StatefulStremableWidgetBuilder<TState> = Widget Function(BuildContext context, TState? state);

class _StatefulStreamableState<TState> extends State<StatefulStreamableBuilder> {
  final StatefulStremable<TState> _streamable;
  final StatefulStremableWidgetBuilder<TState> _builder;

  _StatefulStreamableState({
    required StatefulStremable<TState> streamable,
    required StatefulStremableWidgetBuilder<TState> builder
  }) : _builder = builder, _streamable = streamable;

  @override
  Widget build(BuildContext context) {
    return StatefulStreamConsumer<TState>(defaultValue: _streamable.state, 
      stream: _streamable.stream, 
      builder: (context, value) => _builder.call(context, value));
  }
}

abstract class StatefulStreamableBuilder<TStremable extends StatefulStremable<TState>, TState> extends StatefulWidget {
  final StatefulStremable<TState> _streamable;
  final StatefulStremableWidgetBuilder<TState> _builder;

  const StatefulStreamableBuilder({
    super.key,
    required StatefulStremable<TState> streamable,
    required StatefulStremableWidgetBuilder<TState> builder
  }) : _streamable = streamable, _builder = builder;

  @override
  State<StatefulWidget> createState() => _StatefulStreamableState(streamable: _streamable, builder: _builder);
}