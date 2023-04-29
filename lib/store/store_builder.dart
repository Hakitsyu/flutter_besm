import 'package:flutter/cupertino.dart';
import 'package:flutter_besm/base/store_base_builder.dart';
import 'package:flutter_besm/store/store.dart';

typedef StoreWidgetBuilder<TState> = Widget Function(BuildContext context, TState? state);

class StoreBuilder<TStore extends Store<TState>, TState> extends StoreBaseBuilder<TStore, TState> {
  StoreBuilder({
    super.key,
    required TStore store,
    required StoreWidgetBuilder<TState> builder
  }) : super(store: store, builder: (context, state) {
    return builder.call(context, state);
  });
}