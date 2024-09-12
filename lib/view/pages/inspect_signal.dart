import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/chart_controller.dart';
import 'package:serial_comunication/model/chart_data.dart';
import 'package:serial_comunication/view/Components/Chart/chart.dart';

class InspectSignal extends StatefulWidget {
  final ChartData? data;
  final ChartController controller;

  const InspectSignal({super.key, required this.data, required this.controller});

  @override
  State<InspectSignal> createState() => _InspectSignalState();
}

class _InspectSignalState extends State<InspectSignal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inspect Signal ${widget.data?.id}"),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Chart(
              data: widget.data?.values,
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SwitchListTile(
                        value: widget.data?.showFFT ?? false,
                        onChanged: (bool newValue) {
                          widget.data?.showFFT = newValue;
                          setState(() {});
                        },
                        title: const Text("Update FFT"),
                      ),
                      SizedBox(
                        child: Chart(
                          enableZoom: true,
                          data: widget.data?.fftResults,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Last value: ${widget.data?.values.last.value}"),
                      Text("Max value: ${widget.data?.max}"),
                      Text("Min value: ${widget.data?.min}"),
                      Text("Period: ${widget.data?.period}"),
                      Text("Frequency: ${widget.data?.frequency}"),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
