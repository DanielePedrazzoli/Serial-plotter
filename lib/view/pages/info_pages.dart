import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:serial_comunication/view/Components/info/text_section.dart';

class Info extends StatelessWidget {
  final SerialController controller;
  const Info({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 40, left: 40, right: 40),
      width: 1000,
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Help",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const TextSection(
            name: "Configurazione",
            content: "Inviare tramite seriale il comando `--config-plot:\$nome_grafico per inizializzare il plotter.\n"
                "Inserire quanti nomi di grafici si vuole e divderli tra loro con il carattere `,`"
                "\nSono ammessi spazi nei nomi dei grafici"
                "\n\nEsempio:\n`--config-plot:Sensore 1,Sensore 2`",
          ),
          TextSection(
            name: "Invio valori",
            content: "Inviare tramite seriale il comando `--plot:\$valore per inviare i dati al plotter.\n"
                "Inserire tutti i valori, sono accettati:"
                "\n - valori `float` (con caratterese decimale il `.`)"
                "\n - Valore `int`"
                "I caratteri di `\\n` e `\\r` vengono automaticamente eliminati dal messaggio se presenti"
                "\nSeparare i valori usando il carattere `${controller.chartConfiguration.valueSeparator}`"
                "\n\nEsempio:\n`--plot:1.672,2,3.0`",
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Chiudi"),
              )
            ],
          )
        ],
      ),
    );
  }
}
