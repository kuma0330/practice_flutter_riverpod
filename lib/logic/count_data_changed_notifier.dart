import 'package:flutter/material.dart';
import 'package:practice_riverpod/data/count_data.dart';

typedef ValueChangedCondition = bool Function(
    CountData oldValue, CountData newValue);

abstract class CountDataChangedNotifier {
  valueChanged(CountData oldValue, CountData newValue);
}
