import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/serial_controller.dart';

class InfoConnection extends StatelessWidget {
  final SerialController controller;
  const InfoConnection({super.key, required this.controller});

  Widget _connectButton(BuildContext context) {
    if (!controller.isConnected) {
      return IconButton(
        onPressed: () {
          // var result = controller.connect();
          // if (result == true) {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connected to ${controller.port!.name}")));
          //   return;
          // }

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connection failed")));
        },
        tooltip: "connect",
        icon: const Icon(
          Icons.power_off,
          color: Colors.red,
        ),
      );
    }
    return IconButton(
      onPressed: controller.disconnect,
      tooltip: "disconnect",
      icon: const Icon(
        Icons.power,
        color: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Row(
          children: [
            Row(
              children: [
                Text("Connected port", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(width: 8),
                // DropdownMenu(
                //   onSelected: (value) => controller.selectedPort = value ?? "",
                //   dropdownMenuEntries: controller.portsAvaiable.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
                // )

                _connectButton(context),
              ],
            ),
            const SizedBox(width: 48),
            // Row(
            //   children: [
            //     Text("Baud rate", style: Theme.of(context).textTheme.bodyLarge),
            //     const SizedBox(width: 8),
            //     DropdownMenu(
            //       onSelected: (value) => controller.selectedBaudRate = value ?? 9600,
            //       initialSelection: 115200,
            //       dropdownMenuEntries: controller.avaiableBoutRate.map((e) => DropdownMenuEntry<int>(value: e, label: e.toString())).toList(),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
