import 'dart:async';

import 'package:flutter/cupertino.dart';

typedef StatefulStreamConsumerBuilder<TState> = Widget Function(BuildContext context, TState? value);

class _StatefulStreamConsumerState<TState> extends State<StatefulStreamConsumer<TState>> {
  late final Stream<TState> _stream;
  late final StatefulStreamConsumerBuilder<TState> _builder;
  StreamSubscription<TState>? _streamSubscription;

  final TState? _defaultValue;
  TState? _value;

  _StatefulStreamConsumerState({
    TState? defaultValue,
    required Stream<TState> stream,
    required StatefulStreamConsumerBuilder<TState> builder
  }) : _stream = stream, _builder = builder, _defaultValue = defaultValue;

  _set(TState? value) {
    setState(() {
      _value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_defaultValue != null) {
      _set(_defaultValue);
    }

    _streamSubscription = _stream.listen((value) {
      _set(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _builder.call(context, _value);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}

class StatefulStreamConsumer<TState> extends StatefulWidget {
  final Stream<TState> _stream;
  final StatefulStreamConsumerBuilder<TState> _builder;
  final TState? _defaultValue;

  const StatefulStreamConsumer({
    super.key, 
    TState? defaultValue,
    required Stream<TState> stream,
    required StatefulStreamConsumerBuilder<TState> builder 
  }) : _stream = stream, _defaultValue = defaultValue, _builder = builder;

  @override
  State<StatefulWidget> createState() => _StatefulStreamConsumerState(
    defaultValue: _defaultValue, 
    stream: _stream,
    builder: _builder);
}