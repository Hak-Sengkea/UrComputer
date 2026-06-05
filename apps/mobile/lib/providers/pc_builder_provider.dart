import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pc_build.dart';
import '../services/supabase_service.dart';

class PCBuilderProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  PCBuild? _currentBuild;
  Map<String, Product?> _selectedComponents = {};
  
  List<Product> _components = [];
  bool _isLoading = false;
  String? _selectedComponentType;
  
  List<PCBuild> _userBuilds = [];
  
  PCBuild? get currentBuild => _currentBuild;
  Map<String, Product?> get selectedComponents => _selectedComponents;
  List<Product> get components => _components;
  bool get isLoading => _isLoading;
  List<PCBuild> get userBuilds => _userBuilds;
  
  double get totalPrice {
    double total = 0;
    _selectedComponents.forEach((key, component) {
      if (component != null) {
        total += component.price;
      }
    });
    return total;
  }
  
  bool get isBuildComplete {
    final requiredTypes = ['CPU', 'GPU', 'RAM', 'Motherboard', 'Storage', 'PSU'];
    return requiredTypes.every((type) => _selectedComponents[type] != null);
  }
  
  // Get category ID for component type
  String _getCategoryIdForComponent(String componentType) {
    switch (componentType) {
      case 'CPU':
      case 'GPU':
      case 'RAM':
      case 'Motherboard':
      case 'PSU':
      case 'Case':
      case 'Cooler':
        return 'c81dfa01-9f9e-4c74-a029-79257e84f503'; // PC Components
      case 'Storage':
        return 'c81dfa01-9f9e-4c74-a029-79257e84f506'; // Storage Devices
      default:
        return 'c81dfa01-9f9e-4c74-a029-79257e84f503';
    }
  }
  
  // Load components by type
  Future<void> loadComponentsByType(String componentType) async {
    _isLoading = true;
    _selectedComponentType = componentType;
    notifyListeners();
    
    try {
      final categoryId = _getCategoryIdForComponent(componentType);
      _components = await _supabaseService.getProductsByCategoryId(categoryId);
      
      // Filter by component type name if needed
      if (componentType != 'Storage') {
        _components = _components.where((p) => 
          p.name.toLowerCase().contains(componentType.toLowerCase()) ||
          p.description!.toLowerCase().contains(componentType.toLowerCase())
        ).toList();
      }
    } catch (e) {
      debugPrint('Error loading components: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Select a component for the build
  void selectComponent(String type, Product component) {
    _selectedComponents[type] = component;
    notifyListeners();
  }
  
  // Remove component from build
  void removeComponent(String type) {
    _selectedComponents[type] = null;
    notifyListeners();
  }
  
  // Create new build
  void newBuild(String buildName, String? description) {
    _currentBuild = PCBuild(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '',
      buildName: buildName,
      description: description,
      totalPrice: 0,
      components: {},
      isPublic: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _selectedComponents = {};
    notifyListeners();
  }
  
  // Save current build
  Future<bool> saveBuild(String userId) async {
    if (_currentBuild == null) return false;
    
    final buildToSave = PCBuild(
      id: _currentBuild!.id,
      userId: userId,
      buildName: _currentBuild!.buildName,
      description: _currentBuild!.description,
      totalPrice: totalPrice,
      components: Map.from(_selectedComponents),
      isPublic: false,
      createdAt: _currentBuild!.createdAt,
      updatedAt: DateTime.now(),
    );
    
    try {
      await _supabaseService.saveBuild(buildToSave);
      await loadUserBuilds(userId);
      return true;
    } catch (e) {
      debugPrint('Error saving build: $e');
      return false;
    }
  }
  
  // Load user's saved builds
  Future<void> loadUserBuilds(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _userBuilds = await _supabaseService.getUserBuilds(userId);
    } catch (e) {
      debugPrint('Error loading builds: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Delete a build
  Future<void> deleteBuild(String buildId, String userId) async {
    await _supabaseService.deleteBuild(buildId);
    await loadUserBuilds(userId);
  }
  
  // Clear current build
  void clearCurrentBuild() {
    _currentBuild = null;
    _selectedComponents = {};
    notifyListeners();
  }
  
  // Get component type label
  String getTypeLabel(String type) {
    switch (type) {
      case 'CPU': return 'Processor';
      case 'GPU': return 'Graphics Card';
      case 'RAM': return 'Memory';
      case 'Motherboard': return 'Motherboard';
      case 'Storage': return 'Storage';
      case 'PSU': return 'Power Supply';
      case 'Case': return 'Computer Case';
      case 'Cooler': return 'CPU Cooler';
      default: return type;
    }
  }
}