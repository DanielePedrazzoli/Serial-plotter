import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:serial_comunication/view/Components/ExportComponents.dart';
import 'package:collection/collection.dart';

class ChartController extends ChangeNotifier {
  List<String> messageHistory = [];
  List<ChartData> plotData = [];
  List<ChartData?> associationMap = [];

  late Timer updateTimer;

  ChartController() {
    updateTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      updateChart();
    });
  }

  List<double> parseMessage(String message) {
    // remove all the chars that are not numbers. Since this is a value plot,
    // only number, comma and dot are accepted
    message = message.replaceAll(RegExp(r"[a-z]\s*", caseSensitive: false), "");

    // remove the "#" char and eventually all the spaces in front of it
    message = message.replaceAll(RegExp(r"#\s*", caseSensitive: false), "");

    // remove multiple spaces and replace them with single spaces
    message = message.replaceAll(RegExp(r"\s\s+", caseSensitive: false), " ");

    return message.split(" ").map((e) => double.tryParse(e) ?? 0).toList();
  }

  /// Push a new value on the charts
  ///
  /// The message should start with a # char for be considered a valid value
  ///
  /// All the value must be separated by a space and double value are expected
  /// to have a "." (dot) instead of "," comma for decimal separator
  ///
  /// All value are pushed in the corisponding chart:
  /// - If no chart are avaiable, a new chart is created
  /// - If a chart is avaiable, the value is pushed in the chart
  /// - If the number of value are less than the number of charts already
  /// existing, all the remaingin chart are pushed with a 0 value
  ///
  /// ### Example:
  ///
  /// #### Message 1
  /// #1,2.5
  ///
  /// - chart 1 (new) ---> 1
  /// - chart 2 (new) ---> 2.5
  ///
  /// #### Message 2
  /// #2,2.5,3
  ///
  /// - chart 1 ---> 2
  /// - chart 2 ---> 2.5
  /// - chart 3 (new) ---> 3
  ///
  /// #### Message 3
  /// #2
  ///
  /// - chart 1 ---> 2
  /// - chart 2 ---> 0 (value not avaiable in the message)
  /// - chart 3 ---> 0 (value not avaiable in the message)
  ///
  pushNewValue(String message) {
    messageHistory.add(message);

    if (!message.startsWith("#")) return;

    List<double> values = parseMessage(message);

    for (int i = 0; i < values.length; i++) {
      ChartData? chartData = plotData.elementAtOrNull(i);

      if (chartData == null) {
        plotData.add(ChartData(id: i));
      }
      chartData?.pushValue(values[i]);
    }

    if (values.length < plotData.length) {
      for (int i = values.length; i < plotData.length; i++) {
        plotData[i].pushValue(0);
      }
    }

    notifyListeners();
  }

  addNewChart() {
    associationMap.add(null);
    notifyListeners();
  }

  removeChart(int index) {
    associationMap.removeAt(index);
  }

  assingDataToChart(int plotID, int charDataID) {
    ChartData? data = plotData.firstWhereOrNull((var data) => data.id == charDataID);
    if (data == null) return;

    associationMap[plotID] = data;
  }

  /// Update visualization
  void updateChart() {
    notifyListeners();
  }

  /// Export related functions
  void exportData(ExportOption options) async {
    var filtredList = List.from(messageHistory);

    if (options.collapseSpaces) {
      filtredList = filtredList.map((e) => e.replaceAll(RegExp(r"\s\s+", caseSensitive: false), " ")).toList();
    }

    if (options.filterChart) {
      filtredList.removeWhere((line) => line.startsWith("#") == false);
    }

    if (options.includePlotChar) {
      filtredList = filtredList.map((e) => e.replaceFirst("#", "")).toList();
    }

    if (options.asCSV) {
      filtredList = filtredList.map((e) => e.replaceFirst(" ", ";")).toList();
    }

    if (options.justNUmber) {
      filtredList = filtredList.map((e) => e.replaceAll(RegExp(r"[a-z]", caseSensitive: false), "")).toList();
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return;
    }

    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year} ${date.hour}-${date.minute}";
    String fileExtension;
    if (options.asCSV) {
      fileExtension = ".csv";
    } else {
      fileExtension = ".txt";
    }

    File file = File("$selectedDirectory/DataExport $formattedDate$fileExtension");
    file.writeAsString(filtredList.join("\n"));
  }
}
