import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_besm/store/store_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shared/count_store.dart';

class CountTextWidget extends StatelessWidget {
  static Key textKey = const Key('text');

  final CountStore store;
  final Function? _onBuild;

  const CountTextWidget({
    super.key, 
    required this.store,
    Function? onBuild
  }) : _onBuild = onBuild;

  @override
  Widget build(BuildContext context) {
    _onBuild?.call();
    return StoreBuilder(
      store: store, builder: (context, state) => Text(key: textKey, (state ?? '').toString())
    );
  }
}

class CountTextWithIncreaseButton extends StatelessWidget {
  static Key textKey = const Key('text');
  static Key increaseButttonKey = const Key('increaseButton');

  final CountStore _store;
  final Function? _onBuild;

  const CountTextWithIncreaseButton({
    super.key, 
    required CountStore store,
    Function? onBuild
  }) : _store = store, _onBuild = onBuild;

  @override
  Widget build(BuildContext context) {
    _onBuild?.call();
    return Row(children: [
      StoreBuilder(
        store: _store, builder: (context, state) => Text(key: textKey, (state ?? '').toString())),
      TextButton(onPressed: () => {
        _store.increase()
      }, child: Text('Increase', key: increaseButttonKey))
    ]);
  }
}

void main() {
  group('CountStore', () {
    createCountStore([int value = 0]) => CountStore(value);

    testWidgets('increase, re build test', (tester) async {
      final countStore = createCountStore();
      await tester.pumpWidget(MaterialApp(home: CountTextWidget(store: countStore)));

      final textFinder = find.byKey(CountTextWidget.textKey);
      expect(tester.widget<Text>(textFinder).data, '0');

      countStore.increase();
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(textFinder).data, '1');

      countStore.increase();
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(textFinder).data, '2');
    });

    testWidgets('build count test', (tester) async {
      const int expected = 3;
      int count = 0; 

      final countStore = createCountStore();
      await tester.pumpWidget(MaterialApp(home: CountTextWidget(store: countStore, onBuild: () => count++)));

      for (int i = 0; i < expected - 1; i++) {
        countStore.increase();
        await tester.pumpAndSettle();
        count++;
      }

      expect(expected, count);
    });

    testWidgets('increase with button click, re build test', (tester) async {
      final countStore = createCountStore();
      await tester.pumpWidget(MaterialApp(home: CountTextWithIncreaseButton(store: countStore)));

      final textFinder = find.byKey(CountTextWithIncreaseButton.textKey);
      expect(tester.widget<Text>(textFinder).data, '0');

      final buttonFinder = find.byKey(CountTextWithIncreaseButton.increaseButttonKey);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(textFinder).data, '1');
    });

    testWidgets('build count test with increase button', (tester) async {
      const int expected = 3;
      int count = 0; 

      final countStore = createCountStore();
      await tester.pumpWidget(MaterialApp(home: CountTextWithIncreaseButton(store: countStore, onBuild: () => count++)));
      final buttonFinder = find.byKey(CountTextWithIncreaseButton.increaseButttonKey);

      for (int i = 0; i < expected - 1; i++) {
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();
        count++;
      }

      expect(expected, count);
    });
  });
}