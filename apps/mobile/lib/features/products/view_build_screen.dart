import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/pc_build.dart';
import '../../models/product.dart';

class ViewBuildScreen extends StatelessWidget {
  final PCBuild pcBuild; 
  
  const ViewBuildScreen({super.key, required this.pcBuild, required PCBuild build});

  @override
  Widget build(BuildContext context) {
    final componentsList = pcBuild.components.entries
        .where((entry) => entry.value != null)
        .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(pcBuild.buildName), 
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Build header
          Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pcBuild.description != null)  
                    Text(
                      pcBuild.description!,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Created: ${_formatDate(pcBuild.createdAt)}', 
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: pcBuild.isComplete ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pcBuild.isComplete ? 'Complete' : 'In Progress',
                          style: TextStyle(
                            color: pcBuild.isComplete ? Colors.green : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Components list
          const Text(
            'Components',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...componentsList.map((entry) {
            return _buildComponentTile(entry.key, entry.value!);
          }),
          
          const SizedBox(height: 24),
          
          // Total price
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${pcBuild.totalPrice.toStringAsFixed(2)}',  
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComponentTile(String type, Product component) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Component image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: component.image ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[800],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Component info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    component.brandName ?? 'Unknown Brand',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            
            // Price and type
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${component.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}