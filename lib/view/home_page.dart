import 'package:flutter/material.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:serial_comunication/view/Components/info_connection.dart';
import 'package:serial_comunication/view/pages/info_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SerialController connectionController = SerialController();
  TextEditingController inputController = TextEditingController();

  int steps = 0;

  @override
  void initState() {
    super.initState();
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Info(controller: connectionController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serial plotter"),
        actions: [
          IconButton(onPressed: _showInfo, icon: const Icon(Icons.help)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: ListenableBuilder(
        listenable: connectionController,
        builder: (context, _) => Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              InfoConnection(controller: connectionController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Value plot", style: Theme.of(context).textTheme.headlineSmall),
                  FilledButton.icon(
                    onPressed: () {},
                    label: const Text("Add"),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Expanded(
              //   child: ListView.builder(
              //     itemBuilder: (context, index) => Chart(controller: connectionController, id: index),
              //     itemCount: connectionController.chartsValues.length,
              //   ),
              // ),
              // Expanded(
              //   child: Row(
              //     children: [

              //       Expanded(
              //         flex: 75,
              //         child: ChartComponents(controller: connectionController),
              //       ),
              //       const Spacer(),
              //       // Expanded(
              //       //   flex: 25,
              //       //   child: SerialComunication(controller: connectionController),
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
