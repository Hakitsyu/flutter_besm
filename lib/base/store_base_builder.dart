import 'package:flutter/cupertino.dart';
import 'package:flutter_besm/base/stateful_streamable_builder.dart';
import 'package:flutter_besm/base/store_base.dart';

typedef StoreBaseWidgetBuilder<TState> = Widget Function(BuildContext context, TState? state);

abstract class StoreBaseBuilder<TStore extends StoreBase<TState>, TState> extends StatefulStreamableBuilder<TStore, TState> {
  StoreBaseBuilder({
    super.key,
    required TStore store,
    required StoreBaseWidgetBuilder<TState> builder
  }) : super(streamable: store, builder: (context, state) {
    return builder.call(context, state);
  });
}