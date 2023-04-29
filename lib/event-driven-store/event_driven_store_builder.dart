import 'package:flutter/cupertino.dart';
import 'package:flutter_besm/base/store_base.dart';
import 'package:flutter_besm/base/store_base_builder.dart';
import 'package:flutter_besm/event-driven-store/event_driven_store.dart';

typedef EventDrivenStoreWidgetBuilder<TState> = Widget Function(BuildContext context, TState? state);

class EventDrivenStoreBuilder<TStore extends EventDrivenStore<TEvent, TState>, TState, TEvent extends Event> 
  extends StoreBaseBuilder<TStore, TState> {
  EventDrivenStoreBuilder({
    super.key,
    required TStore store,
    required EventDrivenStoreWidgetBuilder<TState> builder
  }) : super(store: store, builder: (context, state) {
    return builder.call(context, state);
  });
}