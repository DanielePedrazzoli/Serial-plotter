import 'package:flutter/material.dart';
import 'package:serial_comunication/view/Components/Chart/chart.dart';

class ChartData {
  List<ChartPointData> values = [];
  late Color color;
  int id;
  bool isPaused = false;
  bool zoomEnabled = false;

  late GlobalKey<ChartState> chartKey;

  int maxCapacity = 5000;

  ChartData({required this.id}) {
    values.addAll(List.generate(maxCapacity, (index) => ChartPointData(value: 0, index: index)));

    color = Colors.primaries[(id + 4 + id) % Colors.primaries.length];
    chartKey = GlobalKey<ChartState>();
  }

  void pushValue(double newValue) {
    var newIndex = values.last.index + 1;
    var newPoint = ChartPointData(value: newValue, index: newIndex);
    values.add(newPoint);

    if (values.length >= maxCapacity) {
      values.removeAt(0);
    }
  }

  bool autoscale = false;
}

class ChartPointData {
  double value;
  int index;
  ChartPointData({required this.value, required this.index});

  ChartPointData.zero() : this(value: 0, index: 0);
}
