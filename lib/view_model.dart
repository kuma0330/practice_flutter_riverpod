import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/logic/button_animation_logic.dart';
import 'package:practice_riverpod/logic/logic.dart';
import 'package:practice_riverpod/provider.dart';

class ViewModel {
  Logic _logic = Logic();

  late ButtonAnimationLogic _buttonAnimationLogicPlus;

  late WidgetRef _ref;

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;

    _buttonAnimationLogicPlus = ButtonAnimationLogic(tickerProvider);
  }

  get count => _ref.watch(countDataProvider).count.toString();

  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();

  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlus => _buttonAnimationLogicPlus.animationScale;

  void onIncrease() {
    _logic.increase();
    _buttonAnimationLogicPlus.start();
    _ref.watch(countDataProvider.state).state = _logic.countData;
  }

  void onDecrease() {
    _logic.decrease();

    _ref.watch(countDataProvider.state).state = _logic.countData;
  }

  void onReset() {
    _logic.reset();

    _ref.watch(countDataProvider.state).state = _logic.countData;
  }
}
