import 'package:flutter/material.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrintDemoPage(),
    );
  }
}

class PrintDemoPage extends StatelessWidget {
  Future<void> _printReceipt() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();

    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.0.123', port: 9100);
    if (res == PosPrintResult.success) {
      printer.text('Hello from Flutter ESC/POS!');
      printer.cut();
      printer.disconnect();
    }
    debugPrint('Print result: ${res.msg}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ESC/POS Print Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _printReceipt,
          child: const Text('Print Receipt'),
        ),
      ),
    );
  }
}
