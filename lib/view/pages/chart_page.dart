import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/chart_controller.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:serial_comunication/view/Components/Chart/chart.dart';
import 'package:serial_comunication/view/Components/ExportComponents.dart';
import 'package:serial_comunication/view/Components/baudrate/baudrate_selector.dart';

class ChartPage extends StatefulWidget {
  final SerialController controller;
  const ChartPage({super.key, required this.controller});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  ChartController chartController = ChartController();

  int i = 0;
  // Timer? debugTimer;

  bool disablePageScroll = false;

  @override
  void initState() {
    super.initState();

    widget.controller.chartController = chartController;
    chartController.addNewChart();

    // debugTimer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
    //   widget.controller.onRecivedData(Uint8List.fromList([
    //     ..."#FF".codeUnits,
    //     ...(2 * sin(i++ / 2)).toString().codeUnits,
    //     ..."      ".codeUnits,
    //     ...(i % 100).toString().codeUnits,
    //     ..."".codeUnits,
    //     ...(i * 10 % 64700).toString().codeUnits,
    //   ]));
    // });

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

    // if (debugTimer != null) {
    //   debugTimer!.cancel();
    // }
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
                        setState(() {});
                      },
                      label: const Text("add chart"),
                      icon: const Icon(Icons.add)),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(onPressed: exportData, label: const Text("Export data"), icon: const Icon(Icons.import_export)),
                  // const SizedBox(width: 8),
                  // OutlinedButton.icon(onPressed: () {}, label: const Text("Settings"), icon: const Icon(Icons.settings)),
                  // const SizedBox(width: 8),
                  // OutlinedButton.icon(onPressed: () {}, label: const Text("View monitor"), icon: const Icon(Icons.monitor)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListenableBuilder(
                    listenable: chartController,
                    builder: (context, child) => Column(
                      children: List.generate(
                        chartController.chartList.length,
                        (index) {
                          return Row(
                            children: [
                              const SizedBox(width: 8),
                              Container(width: 10, height: 10, color: chartController.chartList[index].color),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  chartController.chartList[index].values.last.value.toStringAsPrecision(5),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView.builder(
                      physics: disablePageScroll ? const NeverScrollableScrollPhysics() : null,
                      itemBuilder: (context, index) => MouseRegion(
                        onEnter: (_) {
                          if (chartController.chartList[index].zoomEnabled) disablePageScroll = true;
                          setState(() {});
                        },
                        onExit: (event) {
                          disablePageScroll = false;
                          setState(() {});
                        },
                        child: Chart(key: chartController.chartList[index].chartKey, data: chartController.chartList[index]),
                      ),
                      itemCount: chartController.chartList.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
