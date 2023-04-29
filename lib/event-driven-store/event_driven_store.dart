import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../base/contracts/disposable.dart';
import '../base/store_base.dart';
import 'event.dart';
import 'event_snapshot.dart';

export './event.dart';

typedef EventDrivenStoreListenFunction<TEvent extends Event> = FutureOr<void> Function(TEvent event);

abstract class EventDrivenStore<TEvent extends Event, TState> extends StoreBase<TState> implements Disposable {
  late final StreamController<EventSnapshot<TEvent, TState>> _snapshotsController;

  late final List<StreamSubscription<TEvent>> _subscriptions;

  bool _disposed = false;

  EventDrivenStore(super.defaultState) {
    _snapshotsController = StreamController<EventSnapshot<TEvent, TState>>.broadcast();
    _subscriptions = [];
  }

  @protected
  StreamSubscription<TEvent> listen<T extends TEvent>(EventDrivenStoreListenFunction<T> on) {
    StreamSubscription<TEvent> subscription = eventsStream
      .where((event) => event is T)
      .map((event) => event as T)
      .listen(on);

    _subscriptions.add(subscription);
    return subscription;
  }

  @protected
  unlisten(StreamSubscription<TEvent> subscription) {
    _subscriptions.remove(subscription);
  }

  emit<T extends TEvent>(T event) {
    final snapshot = EventSnapshot(event, state);
    _snapshotsController.add(snapshot);
  }

  _disposeSubscriptions() async {
    for (var s in _subscriptions) {
      await s.cancel();
    }

    _subscriptions.clear();
  }

  Stream<TEvent> get eventsStream => snapshotsStream.map((snapshopt) => snapshopt.event);

  Stream<EventSnapshot<TEvent, TState>> get snapshotsStream => _snapshotsController.stream;

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    try {
      await super.dispose();
      await _snapshotsController.close();
      await _disposeSubscriptions();
    } catch (ex) {
      rethrow;
    } finally {
      _disposed = true;
    }
  }
}