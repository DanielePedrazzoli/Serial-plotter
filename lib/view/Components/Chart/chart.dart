import 'package:flutter/material.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  // final ChartData? data;
  final List<ChartPointData>? data;
  final bool enableZoom;
  final String? plotName;
  final Color? plotColor;
  const Chart({super.key, required this.data, this.plotName = "Signal", this.enableZoom = false, this.plotColor = Colors.blue});

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> {
  // ChartSeriesController? _chartSeriesController;

  // void updateData() {
  //   if (widget.data.isPaused) {
  //     return;
  //   }

  //   _chartSeriesController?.updateDataSource(addedDataIndex: widget.data.values.length - 1, removedDataIndex: 0);
  // }

  // void togglePause() {
  //   widget.data.isPaused = !widget.data.isPaused;

  //   // this imply that the chart was paused and now (after the change) is not
  //   // paused. So i must update all the indexes
  //   if (widget.data.isPaused == false) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    NumericAxis yAxix = const NumericAxis(enableAutoIntervalOnZooming: false, majorGridLines: MajorGridLines(color: Colors.transparent));
    NumericAxis xAxix = const NumericAxis(decimalPlaces: 1);
    ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: widget.enableZoom,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );

    // List<ChartPointData> values = widget.data?.values ?? [];

    return SizedBox(
      height: 400,
      child: SfCartesianChart(
        zoomPanBehavior: zoomPanBehavior,
        plotAreaBorderColor: Theme.of(context).colorScheme.outline,
        plotAreaBorderWidth: 1,
        primaryXAxis: xAxix,
        primaryYAxis: yAxix,
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          FastLineSeries<ChartPointData, int>(
            // onRendererCreated: (ChartSeriesController controller) {
            //   _chartSeriesController = controller;
            // },
            name: widget.plotName,
            width: 1,
            color: widget.plotColor,
            animationDuration: 0,
            dataSource: widget.data,
            xValueMapper: (ChartPointData data, int index) => data.index,
            yValueMapper: (ChartPointData data, int index) => data.value,
          ),
        ],
      ),
    );
  }
}
