import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../providers/pc_builder_provider.dart';
import '../../providers/theme_provider.dart';  // ✅ ADD THIS
import '../../theme/app_theme.dart';

class ComponentSelectionScreen extends StatefulWidget {
  final String componentType;
  
  const ComponentSelectionScreen({
    super.key,
    required this.componentType,
  });

  @override
  State<ComponentSelectionScreen> createState() => _ComponentSelectionScreenState();
}

class _ComponentSelectionScreenState extends State<ComponentSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComponents();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadComponents() async {
    final provider = context.read<PCBuilderProvider>();
    await provider.loadComponentsByType(widget.componentType);
  }
  
  List<Product> _getFilteredComponents(List<Product> components) {
    if (_searchQuery.isEmpty) return components;
    return components.where((c) =>
      c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (c.description?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase())
    ).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    // ✅ ADD THEME PROVIDER
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],  // ✅ Dynamic
      appBar: AppBar(
        title: Text(
          'Select ${context.read<PCBuilderProvider>().getTypeLabel(widget.componentType)}',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),  // ✅ Dynamic
        ),
        backgroundColor: isDark ? Colors.black : Colors.grey[100],  // ✅ Dynamic
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,  // ✅ Dynamic
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),  // ✅ Dynamic
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey[600],  // ✅ Dynamic
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey : Colors.grey[600],  // ✅ Dynamic
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[200],  // ✅ Dynamic
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<PCBuilderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.neonCyan,
              ),
            );
          }
          
          final filteredComponents = _getFilteredComponents(provider.components);
          
          if (filteredComponents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],  // ✅ Dynamic
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No components found',
                    style: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[500],  // ✅ Dynamic
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredComponents.length,
            itemBuilder: (context, index) {
              final component = filteredComponents[index];
              return _buildComponentCard(component, isDark);
            },
          );
        },
      ),
    );
  }
  
  Widget _buildComponentCard(Product component, bool isDark) {
    // ✅ KEEP ORIGINAL IMAGE LOGIC - NOT CHANGED
    final hasValidImage = component.image != null && 
                          component.image!.isNotEmpty && 
                          !component.image!.contains('placehold.co');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey[900] : Colors.grey[200],  // ✅ Dynamic
      child: InkWell(
        onTap: () => Navigator.pop(context, component),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image with fallback icon (ORIGINAL LOGIC KEPT)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[300],  // ✅ Dynamic
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.neonCyan.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: hasValidImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: component.image!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.neonCyan,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            _getIconForComponent(component.name),
                            size: 35,
                            color: AppTheme.neonCyan,
                          ),
                        ),
                      )
                    : Icon(
                        _getIconForComponent(component.name),
                        size: 35,
                        color: AppTheme.neonCyan,
                      ),
              ),
              const SizedBox(width: 16),
              
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      component.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,  // ✅ Dynamic
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (component.brandName != null)
                      Text(
                        component.brandName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],  // ✅ Dynamic
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 4),
                        Text(
                          (component.rating ?? 0.0).toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white : Colors.black,  // ✅ Dynamic
                          ),
                        ),
                        const SizedBox(width: 12),
                        if ((component.stock ?? 0) > 0)
                          Text(
                            'In Stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[400],
                            ),
                          )
                        else
                          Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[400],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${component.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.grey : Colors.grey[600],  // ✅ Dynamic
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getIconForComponent(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('cpu') || lowerName.contains('processor')) {
      return Icons.memory;
    }
    if (lowerName.contains('gpu') || lowerName.contains('graphics') || lowerName.contains('rtx') || lowerName.contains('radeon')) {
      return Icons.videogame_asset;
    }
    if (lowerName.contains('ram') || lowerName.contains('memory') || lowerName.contains('ddr')) {
      return Icons.speed;
    }
    if (lowerName.contains('motherboard')) {
      return Icons.computer;
    }
    if (lowerName.contains('ssd') || lowerName.contains('storage') || lowerName.contains('nvme')) {
      return Icons.storage;
    }
    if (lowerName.contains('power') || lowerName.contains('psu')) {
      return Icons.electrical_services;
    }
    if (lowerName.contains('case')) {
      return Icons.laptop_chromebook;
    }
    if (lowerName.contains('cooler') || lowerName.contains('fan')) {
      return Icons.ac_unit;
    }
    return Icons.device_hub;
  }
}