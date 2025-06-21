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
      title: 'ESC/POS Print Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PrintDemoPage(),
    );
  }
}

class PrintDemoPage extends StatefulWidget {
  const PrintDemoPage({super.key});

  @override
  State<PrintDemoPage> createState() => _PrintDemoPageState();
}

class _PrintDemoPageState extends State<PrintDemoPage> {
  Future<void> _printReceipt() async {
    // Ask for Bluetooth permissions
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();

    final profile = await CapabilityProfile.load();

    // Replace this with your printer's IP
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult result = await printer.connect('192.168.1.88', port: 9100);

    if (result == PosPrintResult.success) {
      printer.setStyles(PosStyles(align: PosAlign.center, bold: true));
      printer.text('Flutter ESC/POS Printing');
      printer.feed(1);
      printer.text('✓ Printed successfully!');
      printer.cut();
      printer.disconnect();
    }

    debugPrint('Print result: ${result.msg}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Print result: ${result.msg}')),
    );
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
