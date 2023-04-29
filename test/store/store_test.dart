import 'package:flutter_test/flutter_test.dart';

import 'shared/count_store.dart';

void main() {
  group('CountStore', () {
    test('increase test', () {
      final countStore = CountStore(0);
      const expected = 10;
      for (int i = 0; i < expected; i++) {
        countStore.increase();
      }

      expect(countStore.state, expected);    
    }); 

    test('stream on increase test', () {
      final countStore = CountStore(0);
      expectLater(countStore.stream, emitsInOrder([1, 2]));
      countStore.increase();
      countStore.increase();
    });

    test('stream test', () {
      final countStore = CountStore(0);
      expectLater(countStore.stream, emitsInOrder([1, 0, 1, 2]));
      countStore.increase();
      countStore.decrease();
      countStore.increase();
      countStore.increase(); 
    });
  });
}