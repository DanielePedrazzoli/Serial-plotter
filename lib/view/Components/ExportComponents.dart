import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/chart_controller.dart';

class Exportcomponents extends StatefulWidget {
  final ChartController controller;
  const Exportcomponents({super.key, required this.controller});

  @override
  State<Exportcomponents> createState() => _ExportcomponentsState();
}

class _ExportcomponentsState extends State<Exportcomponents> {
  ExportOption exportOption = ExportOption();

  List<Widget> applyTranformation() {
    List<Widget> rows = [];
    int limit = widget.controller.messageHistory.length > 40 ? 40 : widget.controller.messageHistory.length;
    rows = widget.controller.messageHistory.sublist(0, limit).map((e) {
      String textvalue = e;
      if (exportOption.filterChart) {
        if (!e.startsWith("#")) {
          return const SizedBox();
        }
      }

      if (exportOption.collapseSpaces) {
        textvalue = textvalue.replaceAll(RegExp(r"\s\s+", caseSensitive: false), " ");
      }

      if (exportOption.asCSV == true) {
        var arr = textvalue.split(" ");

        textvalue = arr.join(";");
      }

      if (exportOption.includePlotChar) {
        if (e.startsWith("#")) {
          textvalue = textvalue.replaceFirst("#", "");
        }
      }

      if (exportOption.justNUmber) {
        textvalue = textvalue.replaceAll(RegExp(r"[a-z]", caseSensitive: false), "");
      }

      return Text(textvalue);
    }).toList();
    rows.add(const Text("..."));
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Export preview",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text("${widget.controller.messageHistory.length} rows")
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: applyTranformation(),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                SwitchListTile(
                  value: exportOption.asCSV,
                  onChanged: (bool value) {
                    setState(() {
                      exportOption.asCSV = value;
                    });
                  },
                  title: const Text("Export as CSV"),
                  subtitle: const Text("Export the data as a CSV file"),
                ),
                SwitchListTile(
                  value: exportOption.includePlotChar,
                  onChanged: (bool value) {
                    setState(() {
                      exportOption.includePlotChar = value;
                    });
                  },
                  title: const Text("Export plot char"),
                  subtitle: const Text("Include in the export the char that allow ther application the recongnition of the plot value"),
                ),
                SwitchListTile(
                  value: exportOption.filterChart,
                  onChanged: (bool value) {
                    setState(() {
                      exportOption.filterChart = value;
                    });
                  },
                  title: const Text("Exlude non-plot messages"),
                  subtitle: const Text("Export only the plot value. Only the messages that wtart with the corrisponding char are exported"),
                ),
                SwitchListTile(
                  value: exportOption.justNUmber,
                  onChanged: (bool value) {
                    setState(() {
                      exportOption.justNUmber = value;
                    });
                  },
                  title: const Text("Export only numbers"),
                  subtitle: const Text("Export only numeric part of the value. All value in Hex are excluded"),
                ),
                SwitchListTile(
                  value: exportOption.collapseSpaces,
                  onChanged: (bool value) {
                    setState(() {
                      exportOption.collapseSpaces = value;
                    });
                  },
                  title: const Text("Collapse spaces"),
                  subtitle: const Text("All multiple istance of spaces are collapsed into one"),
                ),
                // SwitchListTile(
                //   value: exportOption.allValues,
                //   onChanged: (bool value) {
                //     setState(() {
                //       exportOption.allValues = value;
                //     });
                //   },
                //   title: const Text("Export all values"),
                //   subtitle: const Text("All the messages recived from the device are exported"),
                // ),
                // ListTile(
                //   enabled: exportOption.allValues == false,
                //   onTap: () {
                //     print("object");
                //   },
                //   title: const Text("Start from"),
                //   subtitle: const Text("0"),
                //   contentPadding: const EdgeInsets.symmetric(horizontal: 48),
                // ),
                // ListTile(
                //   enabled: exportOption.allValues == false,
                //   onTap: () {
                //     print("object");
                //   },
                //   title: const Text("End at"),
                //   subtitle: const Text("0"),
                //   contentPadding: const EdgeInsets.symmetric(horizontal: 48),
                // ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context, exportOption);
                        },
                        child: const Text("Export"),
                      ),
                      const SizedBox(width: 32),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        child: const Text("Undo"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExportOption {
  bool asCSV = true;
  bool filterChart = true;
  bool includePlotChar = true;
  bool justNUmber = true;
  bool collapseSpaces = true;
  bool allValues = true;
}
