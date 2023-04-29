import 'package:flutter_besm/event-driven-store/event_driven_store.dart';

class CountStore extends EventDrivenStore<EventCountStore, int> {
  CountStore(super.defaultState) {
    listen<IncreaseCountEvent>((event) => set(state + 1));
    listen<DecreaseCountEvent>((event) => set(state - 1));
    listen<UpdateCountEvent>((event) => set(event.value));
  }
}

abstract class EventCountStore extends Event { }

class IncreaseCountEvent extends EventCountStore { }

class DecreaseCountEvent extends EventCountStore { }

class UpdateCountEvent extends EventCountStore {
  final int value;

  UpdateCountEvent(this.value);
}