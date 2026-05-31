import 'package:flutter/material.dart';
import 'package:mobile/data/data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestPage());
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final provider = JsonDataProvider();
      final data = await provider.loadProducts();

      setState(() {
        _data = data;
        _loading = false;
      });

      print("Data loaded: $data");
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _loading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Display")),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products Data",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      if (_data != null && _data!.containsKey('products'))
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (_data!['products'] as List).length,
                          itemBuilder: (context, index) {
                            final product = (_data!['products'] as List)[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading:
                                    product['image'] != null
                                        ? Image.network(
                                          product['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                        : const Icon(Icons.image_not_supported),
                                title: Text(product['name'] ?? 'N/A'),
                                subtitle: Text(product['description'] ?? 'N/A'),
                                trailing: Text(
                                  '\$${product['price'] ?? 'N/A'}',
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Text("No products found"),
                    ],
                  ),
                ),
              ),
    );
  }
}
