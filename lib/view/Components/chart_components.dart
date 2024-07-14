import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartComponents extends StatelessWidget {
  final SerialController controller;
  const ChartComponents({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Value plot", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderColor: Theme.of(context).colorScheme.outline,
            plotAreaBorderWidth: 1,
            primaryXAxis: const NumericAxis(isVisible: false),
            primaryYAxis: const NumericAxis(
              enableAutoIntervalOnZooming: false,
              majorGridLines: MajorGridLines(color: Colors.transparent),
            ),
            legend: Legend(
              isVisible: controller.chartConfiguration.showLeged,
              position: LegendPosition.top,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: List.generate(
              controller.chartsValues.length,
              (int index) => LineSeries<double, int>(
                animationDuration: 0,
                name: controller.chartConfiguration.names[index],
                dataSource: controller.chartsValues[index].toList(),
                xValueMapper: (double data, int index) => index,
                yValueMapper: (double data, int index) => data,
              ),
            ),
            // series: [
            //   LineSeries<double, int>(
            //     animationDuration: 0,
            //     dataSource: controller.chartsValues[0].toList(),
            //     xValueMapper: (double data, int index) => index,
            //     yValueMapper: (double data, int index) => data,
            //   ),
            // ],
          ),
        ),
      ],
    );
  }
}
