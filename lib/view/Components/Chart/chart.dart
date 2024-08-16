import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final ChartData data;
  const Chart({super.key, required this.data});

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> {
  ChartSeriesController? _chartSeriesController;

  void updateData() {
    if (widget.data.isPaused) {
      return;
    }
    _chartSeriesController?.updateDataSource(addedDataIndex: widget.data.values.length - 1, removedDataIndex: 0);
  }

  void togglePause() {
    widget.data.isPaused = !widget.data.isPaused;

    // this imply that the chart was paused and now (after the change) is not
    // paused. So i must update all the indexes
    if (widget.data.isPaused == false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: GenericContextMenu(
        buttonConfigs: [
          ContextMenuButtonConfig(
            "Toggle pause chart",
            onPressed: togglePause,
          ),
          ContextMenuButtonConfig(
            widget.data.zoomEnabled ? "Disable zoom" : "Enable zoom",
            onPressed: () {
              widget.data.zoomEnabled = !widget.data.zoomEnabled;
              setState(() {});
            },
          )
        ],
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SfCartesianChart(
                zoomPanBehavior: ZoomPanBehavior(
                  enableMouseWheelZooming: widget.data.zoomEnabled,
                  zoomMode: ZoomMode.x,
                  enablePanning: true,
                ),
                plotAreaBorderColor: Theme.of(context).colorScheme.outline,
                plotAreaBorderWidth: 1,
                primaryXAxis: const NumericAxis(
                  decimalPlaces: 1,
                ),
                primaryYAxis: const NumericAxis(
                  enableAutoIntervalOnZooming: false,
                  majorGridLines: MajorGridLines(color: Colors.transparent),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  FastLineSeries<ChartPointData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    name: "Signal ${widget.data.id}",
                    width: 1,
                    color: widget.data.color,
                    animationDuration: 0,
                    dataSource: widget.data.values,
                    xValueMapper: (ChartPointData data, int index) => data.index,
                    yValueMapper: (ChartPointData data, int index) => data.value,
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
