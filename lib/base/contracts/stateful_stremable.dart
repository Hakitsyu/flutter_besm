import 'package:flutter_besm/base/contracts/stateful.dart';

abstract class StatefulStremable<TState> implements Stateful<TState> {
  Stream<TState> get stream;
}