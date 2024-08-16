import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:serial_comunication/controller/chart_controller.dart';

class SerialController with ChangeNotifier {
  SerialController();
  SerialPort? _port;
  SerialPortReader? _reader;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SerialPort? get port => _port;

  ChartController? _chartController;

  set chartController(ChartController? value) {
    _chartController = value;
  }

  bool connect(String portName, int baudRate) {
    _port = SerialPort(portName);
    _port!.config.baudRate = baudRate;
    var openResult = _port!.openReadWrite();

    if (openResult == false) {
      return false;
    }

    _reader = SerialPortReader(_port!);
    _reader!.stream.listen(onRecivedData);

    _isConnected = true;
    return true;
  }

  void onRecivedData(Uint8List? data) {
    if (data == null || data.isEmpty) return;

    if (_chartController != null) {
      _chartController!.pushNewValue(String.fromCharCodes(data));
    }

    notifyListeners();
  }

  void disconnect() {
    if (_port == null) {
      return;
    }

    _port!.dispose();
    _isConnected = false;
    _chartController = null;
    notifyListeners();
  }

  void sendMessage(String message) {
    if (_port == null) return;

    _port!.write(Uint8List.fromList(message.codeUnits));

    notifyListeners();
  }

  // void _decodeConfig(String configMessge) {
  //   if (!configMessge.startsWith("--config-plot:")) return;

  //   var configValue = configMessge.replaceFirst("--config-plot:", "").replaceAll(RegExp(r"\r|\n"), "");

  //   var names = configValue.split(",");

  //   for (String name in names) {
  //     CircularBuffer<double> buffer = CircularBuffer(chartConfiguration.maxValueCount);
  //     buffer.addAll(List.filled(chartConfiguration.maxValueCount, 0));
  //     chartsValues.add(buffer);
  //     chartConfiguration.names.add(name);
  //   }

  //   chartConfiguration.showLeged = true;
  // }

  // void __decodePlotValues(String message) {
  //   List<String> values = message.replaceAll("--plot:", "").split(chartConfiguration.valueSeparator);

  //   List<double> parsedValues = values.map((e) => double.parse(e)).toList();

  //   // if value are missing then are considered 0
  //   if (parsedValues.length < chartConfiguration.names.length) {
  //     parsedValues.addAll(List.filled(chartConfiguration.names.length - parsedValues.length, 0));
  //   }

  //   for (int i = 0; i < chartConfiguration.names.length; i++) {
  //     chartsValues[i].add(parsedValues[i]);
  //   }
  // }
}
