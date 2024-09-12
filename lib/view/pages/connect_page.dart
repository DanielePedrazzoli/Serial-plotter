import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:serial_comunication/controller/serial_controller.dart';
import 'package:serial_comunication/view/Components/baudrate/baudrate_selector.dart';
import 'package:serial_comunication/view/pages/chart_page.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  int baudRate = 115200;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  void onPortSelected(String portName) async {
    SerialController controller = SerialController();

    // var isConnected = controller.connect(portName, baudRate);
    controller.connect(portName, baudRate);

    // if (isConnected == false) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to connect to $portName")));
    //   return;
    // }

    await Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPage(controller: controller)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Serial plotter", style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text("Version ${_packageInfo.version}", style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Avaiable ports", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => setState(() {}),
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Text("Baudrate", style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(width: 8),
                      BaudrateSelector(
                        selectedBaudRate: baudRate,
                        onSelected: (int? value) {
                          if (value == null) return;
                          baudRate = value;
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.primary),
                      ),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: SerialPort.availablePorts.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(SerialPort.availablePorts[index]),
                          trailing: OutlinedButton(
                            child: const Text("Connect"),
                            onPressed: () {
                              onPortSelected(SerialPort.availablePorts[index]);
                            },
                          ),
                        ),
                      ),
                    ),
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
