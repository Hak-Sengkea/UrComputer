import 'package:flutter/material.dart';
import 'package:mobile/data/data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    try {
      final provider = JsonDataProvider();

      final data = await provider.loadProducts();

      print(data);

    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Check console"),
      ),
    );
  }
}