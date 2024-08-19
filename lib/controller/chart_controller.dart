import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:serial_comunication/view/Components/ExportComponents.dart';

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

    // remove all the chars that are not numbers. Since this is a value plot,
    // only number, comma and dot are accepted
    message = message.replaceAll(RegExp(r"[a-z]\s*", caseSensitive: false), "");

    // remove the "#" char and eventually all the spaces in front of it
    message = message.replaceAll(RegExp(r"#\s*", caseSensitive: false), "");

    // remove multiple spaces and replace them with single spaces
    message = message.replaceAll(RegExp(r"\s\s+", caseSensitive: false), " ");

    List<double> values = message.split(" ").map((e) => double.tryParse(e) ?? 0).toList();

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
