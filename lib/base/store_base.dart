

import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'contracts/contracts.dart';

abstract class StoreBase<TState> 
  implements Disposable, StatefulStremable<TState>, Stateful<TState> {
  late TState _state;
  late StreamController<TState> _controller;
  late StreamController<Exception> _exceptionController;

  bool _disposed = false;
  // indicates whether a value has already been set
  bool _setted = false;

  StoreBase(TState defaultState) {
    _controller = StreamController<TState>.broadcast();
    _exceptionController = StreamController<Exception>.broadcast();
    // setting default value
    _state = defaultState;
    set(defaultState);
  }


  @protected
  void set(TState state) {
    try {
      if (_setted) {
        if (_state == state) return;
        _state = state;
      } else {
        _setted = true;
      }

      _controller.add(state);
    } on Exception catch (error) {
      _exceptionController.add(error);
      rethrow;
    }
  }

  @override
  TState get state => _state;

  @override
  Stream<TState> get stream => _controller.stream;

  Stream<Exception> get exceptions => _exceptionController.stream;

  @mustCallSuper
  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    try {
      await _controller.close();
      await _exceptionController.close();
    } catch (ex) {
      rethrow;
    } finally {
      _disposed = true;
    }
  }
}