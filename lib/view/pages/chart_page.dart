import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/chart_controller.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:serial_comunication/view/Components/Chart/chart.dart';
import 'package:serial_comunication/view/Components/ExportComponents.dart';
import 'package:serial_comunication/view/Components/baudrate/baudrate_selector.dart';
import 'package:serial_comunication/view/pages/inspect_signal.dart';

class ChartPage extends StatefulWidget {
  final SerialController controller;
  const ChartPage({super.key, required this.controller});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  ChartController chartController = ChartController();

  int i = 0;
  Timer? debugTimer;

  bool disablePageScroll = false;

  @override
  void initState() {
    super.initState();

    widget.controller.chartController = chartController;
    chartController.addNewChart();

    debugTimer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      widget.controller.onRecivedData(Uint8List.fromList([
        ..."#FF".codeUnits,
        ...(sin(i) + 0.5 * sin(i / 2) + 0.25 * sin(i / 4)).toString().codeUnits,
        ..."      ".codeUnits,
        ...(i % 100).toString().codeUnits,
        ..." ".codeUnits,
        ...(i * 10 % 64700).toString().codeUnits,
      ]));

      i++;
    });

    2 == 2;
  }

  void exportData() async {
    ExportOption? option = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Exportcomponents(controller: chartController),
        );
      },
    );

    if (option == null) return;

    chartController.exportData(option);
  }

  @override
  void dispose() {
    super.dispose();

    if (debugTimer != null) {
      debugTimer!.cancel();
    }
  }

  List<ContextMenuButtonConfig> buildContextMenu(ChartData? data, int plotIndex) {
    if (data == null) return [];

    List<ContextMenuButtonConfig> buttons = [];

    buttons.addAll(
      List.generate(
        chartController.plotData.length,
        (dataIndex) => ContextMenuButtonConfig(
          "Channel $dataIndex",
          onPressed: () {
            chartController.assingDataToChart(plotIndex, chartController.plotData[dataIndex].id);
          },
        ),
      ),
    );

    if (chartController.associationMap[plotIndex] != null) {
      buttons.add(ContextMenuButtonConfig("Toggle pause chart", onPressed: () {}));
      buttons.add(ContextMenuButtonConfig(
        data.zoomEnabled ? "Disable zoom" : "Enable zoom",
        onPressed: () {
          data.zoomEnabled = !data.zoomEnabled;
          setState(() {});
        },
      ));
      buttons.add(ContextMenuButtonConfig("More information", onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InspectSignal(data: chartController.associationMap[plotIndex], controller: chartController);
        }));
      }));
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 8),
                  Text(widget.controller.port!.name ?? "", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 32),
                  const Text("Baudrate"),
                  const SizedBox(width: 8),
                  BaudrateSelector(selectedBaudRate: widget.controller.port!.config.baudRate, onSelected: (int? value) {}),
                  const Spacer(),
                  OutlinedButton.icon(
                      onPressed: () {
                        chartController.addNewChart();
                        // setState(() {});
                      },
                      label: const Text("add chart"),
                      icon: const Icon(Icons.add)),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(onPressed: exportData, label: const Text("Export data"), icon: const Icon(Icons.import_export)),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: chartController,
                builder: (context, child) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: List.generate(
                        chartController.plotData.length,
                        (index) {
                          return Row(
                            children: [
                              const SizedBox(width: 8),
                              Container(width: 10, height: 10, color: chartController.plotData[index].color),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  chartController.plotData[index].values.last.value.toStringAsPrecision(5),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chartController.associationMap.length,
                        physics: disablePageScroll ? const NeverScrollableScrollPhysics() : null,
                        itemBuilder: (context, plotIndex) => MouseRegion(
                          onEnter: (_) {
                            if (chartController.associationMap[plotIndex]?.zoomEnabled == true) disablePageScroll = true;
                            // setState(() {});
                          },
                          onExit: (event) {
                            disablePageScroll = false;
                            // setState(() {});
                          },
                          // child: Chart(key: chartController.plotData[index].chartKey, data: chartController.plotData[index]),
                          child: ContextMenuRegion(
                            contextMenu: GenericContextMenu(
                              buttonConfigs: buildContextMenu(chartController.plotData.elementAtOrNull(plotIndex), plotIndex),
                            ),
                            child: Chart(
                              data: chartController.associationMap[plotIndex]?.values,
                              enableZoom: chartController.associationMap[plotIndex]?.zoomEnabled ?? false,
                              key: chartController.plotData.elementAtOrNull(plotIndex)?.chartKey,
                              plotColor: chartController.associationMap[plotIndex]?.color,
                              plotName: chartController.associationMap[plotIndex]?.id.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
