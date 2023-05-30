import 'package:flutter/material.dart';

import 'scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan Text App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanPage(),
    );
  }
}
