import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/serial_controller.dart';

class SerialComunication extends StatefulWidget {
  final SerialController controller;
  const SerialComunication({super.key, required this.controller});

  @override
  State<SerialComunication> createState() => _SerialComunicationState();
}

class _SerialComunicationState extends State<SerialComunication> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Message history", style: Theme.of(context).textTheme.headlineSmall),
              OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear history?"),
                      content: const Text("Are you sure you want to clear the history?"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            // widget.controller.clearHistory();
                            Navigator.pop(context);
                          },
                          child: const Text("Conferma"),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Annulla"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Clear history"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) => Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Theme.of(context).colorScheme.outline),
                          left: BorderSide(color: Theme.of(context).colorScheme.outline),
                          right: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      // child: ListView.separated(
                      //   padding: const EdgeInsets.all(8),
                      //   separatorBuilder: (context, index) => const SizedBox(height: 8),
                      //   itemCount: widget.controller.messages.length,
                      //   itemBuilder: (context, index) => Text(
                      //     widget.controller.messages[index],
                      //     style: Theme.of(context).textTheme.bodySmall,
                      //   ),
                      //   shrinkWrap: true,
                      // ),
                    ),
                  ),
                  TextField(
                    controller: inputController,
                    onSubmitted: (String message) {
                      widget.controller.sendMessage(message);
                      inputController.clear();
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: "Message to send",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
