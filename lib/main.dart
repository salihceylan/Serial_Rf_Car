import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromARGB(255, 9, 1, 53),
      debugShowCheckedModeBanner: false,
      title: 'Arduino Çalışması',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Arduino Çalışması'),
    );
  }
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int roll = 0;
  int pitch = 0;
  int throtle = 0;
  int yaw = 0;
  int kanal5 = 0;
  int kanal6 = 0;
  int kanal7 = 0;
  int kanal8 = 0;

  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            for (final address in availablePorts)
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => secilenPorttanVeriOku(address),
                  child: Text(address),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initPorts,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void secilenPorttanVeriOku(address) {
    final port = SerialPort(address);
    if (!port.isOpen) port.openReadWrite();
    final reader = SerialPortReader(port);

    reader.stream.listen((data) {
      roll = data[0];
      pitch = data[1];
      throtle = data[2];
      yaw = data[3];
      kanal5 = data[4];
      kanal6 = data[5];
      kanal7 = data[6];
      kanal8 = data[7];

      (roll > 180) ? roll = roll - 256 : roll = roll;
      (pitch > 180) ? pitch = pitch - 256 : pitch = pitch;
      (yaw > 180) ? yaw = yaw - 256 : yaw = yaw;

      print(address);
      print('Roll: $roll ');
      print('Pitch: $pitch ');
      print('Throtle: $throtle ');
      print('Yaw: $yaw ');

      print('Kanal 5: $kanal5 ');
      print('Kanal 6: $kanal6 ');
      print('Kanal 7:$kanal7 ');
      print('Kanal 8: $kanal8 ');
    });
  }
}
