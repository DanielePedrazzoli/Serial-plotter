import 'package:flutter/material.dart';

class BaudrateSelector extends StatelessWidget {
  final int? selectedBaudRate;
  final Function(int?) onSelected;
  const BaudrateSelector({super.key, this.selectedBaudRate, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    List<int> avaiableBoutRate = [4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600];
    return DropdownMenu<int>(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      initialSelection: selectedBaudRate,
      onSelected: (value) => onSelected(value),
      dropdownMenuEntries: List.generate(
        avaiableBoutRate.length,
        (index) => DropdownMenuEntry<int>(
          value: avaiableBoutRate[index],
          label: avaiableBoutRate[index].toString(),
        ),
      ),
    );
  }
}
