import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/logic/button_animation_logic.dart';
import 'package:practice_riverpod/logic/count_data_changed_notifier.dart';
import 'package:practice_riverpod/logic/logic.dart';
import 'package:practice_riverpod/provider.dart';

import 'data/count_data.dart';

class ViewModel {
  Logic _logic = Logic();

  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;

    var conditionPlus = (CountData oldValue, CountData newValue) {
      return oldValue.countUp + 1 != newValue.countUp;
    };

    _buttonAnimationLogicPlus =
        ButtonAnimationLogic(tickerProvider, conditionPlus);
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider,
        (CountData oldValue, CountData newValue) {
      return oldValue.countDown - 1 != newValue.countDown;
    });
    _buttonAnimationLogicReset = ButtonAnimationLogic(
      tickerProvider,
      (oldValue, newValue) => newValue.countUp == 0 && newValue.countDown == 0,
    );

    notifiers = [
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset,
    ];
  }

  get count => _ref.watch(countDataProvider).count.toString();

  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();

  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlusScale => _buttonAnimationLogicPlus.animationScale;
  get animationPlusRotation => _buttonAnimationLogicPlus.animationRotation;
  get animationPlusCombination =>
      _buttonAnimationLogicPlus.animationCombination;

  get animationMinus => _buttonAnimationLogicMinus.animationScale;
  get animationMinusCombination =>
      _buttonAnimationLogicMinus.animationCombination;

  get animationReset => _buttonAnimationLogicReset.animationScale;
  get animationResetCombination =>
      _buttonAnimationLogicReset.animationCombination;

  void onIncrease() {
    _logic.increase();
    // _buttonAnimationLogicPlus.start();
    _ref.watch(countDataProvider.state).state = _logic.countData;
    update();
  }

  void onDecrease() {
    _logic.decrease();

    _ref.watch(countDataProvider.state).state = _logic.countData;
    update();
  }

  void onReset() {
    _logic.reset();

    _ref.watch(countDataProvider.state).state = _logic.countData;
    update();
  }

  void update() {
    CountData oldValue = _ref.watch(countDataProvider.state).state;
    _ref.watch(countDataProvider.state).state = _logic.countData;
    CountData newValue = _ref.watch(countDataProvider.state).state;

    notifiers.forEach((element) => element.valueChanged(oldValue, newValue));
  }
}
