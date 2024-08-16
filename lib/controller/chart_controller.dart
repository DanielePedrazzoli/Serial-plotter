import 'package:flutter/material.dart';
import 'package:serial_comunication/model/chart_data.dart';

class ChartController extends ChangeNotifier {
  List<String> messageHistory = [];
  List<ChartData> chartList = [];

  ChartController();

  /// Push new value on every chart avaiable
  ///
  /// The message must start with the corrisponding char, otherwise is not
  /// considered a value of chart but a simple message
  ///
  /// The values are divided by the separator setted in the settings
  ///
  /// All the chart must add the value, if are avaiable less values then a
  /// 0 will be pushed instead
  ///
  /// If there are more value than chart, the remaining values will be ignored
  pushNewValue(String message) {
    messageHistory.add(message);

    if (!message.startsWith("#")) return;

    List<double> values = message.substring(1).split(" ").map((e) => double.tryParse(e) ?? 0).toList();

    for (int i = 0; i < chartList.length; i++) {
      double value = values.elementAtOrNull(i) ?? 0;
      chartList[i].pushValue(value);
      chartList[i].chartKey.currentState?.updateData();
    }

    notifyListeners();
  }

  addNewChart() {
    chartList.add(ChartData(id: chartList.length + 1));
  }

  removeChart(int index) {
    chartList.removeAt(index);
  }
}
