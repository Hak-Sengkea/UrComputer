import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pc_builder_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/pc_build.dart';
import 'view_build_screen.dart';

class MyBuildsScreen extends StatefulWidget {
  const MyBuildsScreen({super.key});

  @override
  State<MyBuildsScreen> createState() => _MyBuildsScreenState();
}

class _MyBuildsScreenState extends State<MyBuildsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBuilds();
  }
  
  Future<void> _loadBuilds() async {
    final authProvider = context.read<AuthProvider>();
    final builderProvider = context.read<PCBuilderProvider>();
    await builderProvider.loadUserBuilds(authProvider.currentUser!.id.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My PC Builds'),
        backgroundColor: Colors.black,
      ),
      body: Consumer<PCBuilderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.userBuilds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.computer, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No builds yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start building your first PC!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/builder'),
                    icon: const Icon(Icons.add),
                    label: const Text('New Build'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.userBuilds.length,
            itemBuilder: (context, index) {
              final build = provider.userBuilds[index];
              return _buildCard(build, provider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/builder'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildCard(PCBuild build, PCBuilderProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewBuildScreen(build: build, pcBuild: build),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      build.buildName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    color: Colors.grey[800],
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Build'),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Build'),
                            content: const Text('Are you sure you want to delete this build?'),
                            backgroundColor: Colors.grey[900],
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirm == true) {
                          final authProvider = context.read<AuthProvider>();
                          await provider.deleteBuild(
                            build.id,
                            authProvider.currentUser!.id.toString(),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (build.description != null)
                Text(
                  build.description!,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${build.componentCount} components',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Text(
                    '\$${build.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (build.isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}