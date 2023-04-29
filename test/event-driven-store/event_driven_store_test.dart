import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'shared/count_store.dart';

void main() {
  group('CountStore', () {
    test('stream on increase test', () {
      final countStore = CountStore(0);
      final increaseEvent = IncreaseCountEvent();

      expectLater(countStore.stream, emitsInOrder([1]));
      expectLater(countStore.eventsStream, emitsInOrder([increaseEvent]));
      countStore.emit(increaseEvent);
    });

    test('stream on update test', () {
      final countStore = CountStore(0);
      final updateEvent1 = UpdateCountEvent(10);
      final updateEvent2 = UpdateCountEvent(20);

      expectLater(countStore.stream, emitsInOrder([10, 20]));
      expectLater(countStore.eventsStream, emitsInOrder([updateEvent1, updateEvent2]));
      countStore.emit(updateEvent1);
      countStore.emit(updateEvent2);
    });
  });
}