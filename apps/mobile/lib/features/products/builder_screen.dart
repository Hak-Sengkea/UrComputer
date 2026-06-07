import 'package:flutter/material.dart';
import 'package:mobile/features/products/component_selection_screen.dart';
import 'package:mobile/models/product.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pc_builder_provider.dart';
import '../../providers/auth_provider.dart';
import 'component_selection_screen.dart';
import 'my_builds_screen.dart';

class BuilderScreen extends StatefulWidget {
  const BuilderScreen({super.key});

  @override
  State<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen> {
  final _buildNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final builderProvider = context.read<PCBuilderProvider>();
      builderProvider.newBuild('My New Build', null);
    });
  }
  
  @override
  void dispose() {
    _buildNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Your Build'),
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _buildNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Build Name',
                hintText: 'e.g., Gaming PC 2024',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Describe your build...',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              final builderProvider = context.read<PCBuilderProvider>();
              
              if (_buildNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a build name')),
                );
                return;
              }
              
              builderProvider.newBuild(
                _buildNameController.text,
                _descriptionController.text.isEmpty ? null : _descriptionController.text,
              );
              
              final success = await builderProvider.saveBuild(
                authProvider.currentUser!.id.toString(),
              );
              
              Navigator.pop(context);
              
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Build saved successfully!')),
                );
                _buildNameController.clear();
                _descriptionController.clear();
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to save build')),
                );
              }
            },
            child: const Text('Save Build'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PCBuilderProvider>(
      builder: (context, builderProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('PC Builder'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: builderProvider.isBuildComplete 
                    ? _showSaveDialog 
                    : null,
                tooltip: 'Save Build',
              ),
              IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed: () {
                  context.push('/my-builds');
                },
                tooltip: 'My Builds',
              ),
            ],
          ),
          body: Column(
            children: [
              // Build summary
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[900],
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${builderProvider.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (builderProvider.isBuildComplete)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✓ Build Complete - Ready to Save',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Component selection grid
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildComponentSelector(builderProvider, 'CPU', Icons.memory),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'GPU', Icons.videogame_asset),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'RAM', Icons.storage),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'Motherboard', Icons.computer),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'Storage', Icons.sd_storage),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'PSU', Icons.electrical_services),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'Case', Icons.laptop_chromebook),
                    const SizedBox(height: 16),
                    _buildComponentSelector(builderProvider, 'Cooler', Icons.ac_unit),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildComponentSelector(
    PCBuilderProvider provider,
    String type,
    IconData icon,
  ) {
    final component = provider.selectedComponents[type];
    
    return GestureDetector(
      onTap: () async {
        final selected = await Navigator.push<Product>(
          context,
          MaterialPageRoute(
            builder: (context) => ComponentSelectionScreen(componentType: type),
          ),
        );
        
        if (selected != null) {
          provider.selectComponent(type, selected);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${selected.name} added to build'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: component != null ? Colors.green : Colors.grey[800]!,
            width: component != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF00E5FF)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.getTypeLabel(type),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (component != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          component.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$${component.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Select ${provider.getTypeLabel(type)}',  // ✅ Changed: removed "Optional" logic
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            if (component != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => provider.removeComponent(type),
              )
            else
              const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}