import 'dart:typed_data';

import 'package:circular_buffer/circular_buffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:serial_comunication/model/chart_configuration.dart';

class SerialController with ChangeNotifier {
  SerialController();
  SerialPort? _port;
  SerialPortReader? _reader;
  bool _isConnected = false;
  List<String> _ports = [];
  bool get isConnected => _isConnected;
  List<String> get portsAvaiable => _ports;
  List<int> get avaiableBoutRate => [4800, 9600, 19200, 38400, 57600, 115200];

  int _selectedBaudRate = 115200;
  String selectedortName = '';

  SerialPort? get port => _port;

  List<String> messages = [];
  List<CircularBuffer<double>> chartsValues = [];
  ChartConfiguration chartConfiguration = ChartConfiguration();

  void clearHistory() {
    messages.clear();
    notifyListeners();
  }

  void scanPorts() {
    _ports = SerialPort.availablePorts;
    notifyListeners();
  }

  set selectedBaudRate(int newValue) {
    _selectedBaudRate = newValue;
    notifyListeners();
  }

  set selectedPort(String newValue) {
    selectedortName = newValue;
    notifyListeners();
  }

  bool connect() {
    _port = SerialPort(selectedortName);
    _port!.config.baudRate = _selectedBaudRate;
    var openResult = _port!.openReadWrite();

    if (openResult == false) {
      return false;
    }

    _reader = SerialPortReader(_port!);
    _reader!.stream.listen(onRecivedData);

    _isConnected = true;
    notifyListeners();
    return true;
  }

  void onRecivedData(Uint8List? data) {
    if (data == null || data.isEmpty) return;

    var message = String.fromCharCodes(data);

    if (_isConfigMessage(message)) {
      _decodeConfig(message);
      messages.add(message);
      notifyListeners();
      return;
    }

    if (_isPlotMessage(message)) {
      __decodePlotValues(message);
      notifyListeners();
      return;
    }
    messages.add(message);
    notifyListeners();
  }

  void disconnect() {
    if (_port == null) {
      return;
    }

    _port!.dispose();
    _isConnected = false;
    notifyListeners();
  }

  void sendMessage(String message) {
    if (_port == null) return;

    _port!.write(Uint8List.fromList(message.codeUnits));

    messages.add(message);
    notifyListeners();
  }

  bool _isConfigMessage(String message) {
    if (message.startsWith("--config-plot:")) {
      return true;
    }

    return false;
  }

  bool _isPlotMessage(String message) {
    if (message.startsWith("--plot:")) {
      return true;
    }

    return false;
  }

  void _decodeConfig(String configMessge) {
    if (!configMessge.startsWith("--config-plot:")) return;

    var configValue = configMessge.replaceFirst("--config-plot:", "").replaceAll(RegExp(r"\r|\n"), "");

    var names = configValue.split(",");

    for (String name in names) {
      CircularBuffer<double> buffer = CircularBuffer(chartConfiguration.maxValueCount);
      buffer.addAll(List.filled(chartConfiguration.maxValueCount, 0));
      chartsValues.add(buffer);
      chartConfiguration.names.add(name);
    }

    chartConfiguration.showLeged = true;
  }

  void __decodePlotValues(String message) {
    List<String> values = message.replaceAll("--plot:", "").split(chartConfiguration.valueSeparator);

    List<double> parsedValues = values.map((e) => double.parse(e)).toList();

    // if value are missing then are considered 0
    if (parsedValues.length < chartConfiguration.names.length) {
      parsedValues.addAll(List.filled(chartConfiguration.names.length - parsedValues.length, 0));
    }

    for (int i = 0; i < chartConfiguration.names.length; i++) {
      chartsValues[i].add(parsedValues[i]);
    }
  }
}
