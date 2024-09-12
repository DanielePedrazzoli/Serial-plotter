import 'package:fftea/fftea.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/view/Components/Chart/chart.dart';

class ChartData {
  List<ChartPointData> values = [];
  late Color color;
  int id;

  final int maxCapacity = 2048;

  /// Chart related variables
  bool isPaused = false;
  bool zoomEnabled = false;
  bool autoscale = false;

  /// FFT related variables
  bool showFFT = false;
  List<ChartPointData> fftResults = [];
  late FFT fftStructure;

  /// Visualization related variables
  late GlobalKey<ChartState> chartKey;

  /// more information
  double max = 0;
  double min = 0;
  double period = 0;
  double get frequency {
    if (period == 0) return 0;
    return 1000 / period;
  }

  DateTime? _lastSampleTime;

  ChartData({required this.id}) {
    values.addAll(List.generate(maxCapacity, (index) => ChartPointData(value: 0, index: index)));
    fftResults.addAll(List.generate(maxCapacity, (index) => ChartPointData(value: 0, index: index)));

    color = Colors.primaries[(id + 4 + id) % Colors.primaries.length];
    chartKey = GlobalKey<ChartState>();
    fftStructure = FFT(maxCapacity);
  }

  void pushValue(double newValue) {
    var newIndex = values.last.index + 1;
    var newPoint = ChartPointData(value: newValue, index: newIndex);

    _lastSampleTime ??= DateTime.now();

    period = DateTime.now().difference(_lastSampleTime!).inMilliseconds.toDouble();
    _lastSampleTime = DateTime.now();

    values.add(newPoint);

    if (values.length >= maxCapacity) {
      values.removeAt(0);
    }

    if (showFFT) {
      runFFT();
    }
  }

  void runFFT() {
    var temp = fftStructure.realFft(values.map((e) => e.value).toList()).discardConjugates().magnitudes().toList();

    fftResults = List.generate(temp.length, (int index) => ChartPointData(value: temp[index] / temp.length, index: index));
  }
}

class ChartPointData {
  double value;
  int index;
  ChartPointData({required this.value, required this.index});

  ChartPointData.zero() : this(value: 0, index: 0);
}
