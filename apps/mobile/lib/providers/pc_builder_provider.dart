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
  
  Future<void> loadComponentsByType(String componentType) async {
    _isLoading = true;
    _selectedComponentType = componentType;
    notifyListeners();
    
    try {
      final categoryId = _getCategoryIdForComponent(componentType);
      _components = await _supabaseService.getProductsByCategoryId(categoryId);
      
      // Special handling for each component type
      if (componentType == 'PSU') {
        // Power Supplies - ONLY show actual power supplies
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('power supply') ||
          p.name.toLowerCase().contains('psu') ||
          (p.name.toLowerCase().contains('w') && 
           (p.name.toLowerCase().contains('corsair') || 
            p.name.toLowerCase().contains('evga') || 
            p.name.toLowerCase().contains('seasonic') ||
            p.name.toLowerCase().contains('thermaltake') ||
            p.name.toLowerCase().contains('cooler master'))) ||
          p.name.toLowerCase().contains('80+ gold') ||
          p.name.toLowerCase().contains('80+ bronze')
        ).toList();
        
        // Remove RAM and Coolers that accidentally match
        _components = _components.where((p) => 
          !p.name.toLowerCase().contains('ram') &&
          !p.name.toLowerCase().contains('memory') &&
          !p.name.toLowerCase().contains('ddr') &&
          !p.name.toLowerCase().contains('cooler') &&
          !p.name.toLowerCase().contains('fan') &&
          !p.name.toLowerCase().contains('liquid') &&
          !p.name.toLowerCase().contains('hyper')
        ).toList();
      } 
      else if (componentType == 'RAM') {
        // RAM/Memory
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('ram') ||
          p.name.toLowerCase().contains('memory') ||
          p.name.toLowerCase().contains('ddr4') ||
          p.name.toLowerCase().contains('ddr5') ||
          p.name.toLowerCase().contains('vengeance') ||
          p.name.toLowerCase().contains('trident') ||
          p.name.toLowerCase().contains('fury')
        ).toList();
      }
      else if (componentType == 'CPU') {
        // Processors
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('processor') ||
          p.name.toLowerCase().contains('cpu') ||
          p.name.toLowerCase().contains('core') ||
          p.name.toLowerCase().contains('ryzen') ||
          p.name.toLowerCase().contains('intel') ||
          p.name.toLowerCase().contains('amd') ||
          (p.name.toLowerCase().contains('i5') ||
           p.name.toLowerCase().contains('i7') ||
           p.name.toLowerCase().contains('i9'))
        ).toList();
      }
      else if (componentType == 'GPU') {
        // Graphics Cards
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('graphics') ||
          p.name.toLowerCase().contains('gpu') ||
          p.name.toLowerCase().contains('rtx') ||
          p.name.toLowerCase().contains('radeon') ||
          p.name.toLowerCase().contains('nvidia') ||
          p.name.toLowerCase().contains('amd')
        ).toList();
      }
      else if (componentType == 'Motherboard') {
        // Motherboards
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('motherboard') ||
          p.name.toLowerCase().contains('z790') ||
          p.name.toLowerCase().contains('b650') ||
          p.name.toLowerCase().contains('aorus') ||
          p.name.toLowerCase().contains('rog')
        ).toList();
      }
      else if (componentType == 'Storage') {
        // Storage devices - show all from Storage Devices category
        // No additional filtering needed
      }
      else if (componentType == 'Case') {
        // Computer cases
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('case') ||
          p.name.toLowerCase().contains('airflow') ||
          p.name.toLowerCase().contains('flow') ||
          p.name.toLowerCase().contains('dynamic') ||
          p.name.toLowerCase().contains('pop air')
        ).toList();
      }
      else if (componentType == 'Cooler') {
        // CPU Coolers
        _components = _components.where((p) => 
          p.name.toLowerCase().contains('cooler') ||
          p.name.toLowerCase().contains('fan') ||
          p.name.toLowerCase().contains('hyper') ||
          p.name.toLowerCase().contains('noctua') ||
          p.name.toLowerCase().contains('liquid') ||
          p.name.toLowerCase().contains('h100i') ||
          p.name.toLowerCase().contains('nh-d15')
        ).toList();
      }
      else {
        // Default filter by name
        _components = _components.where((p) => 
          p.name.toLowerCase().contains(componentType.toLowerCase()) ||
          (p.description?.toLowerCase() ?? '').contains(componentType.toLowerCase())
        ).toList();
      }
      
      // Debug print
      // print('✅ Loaded ${_components.length} components for $componentType');
      // for (var c in _components) {
      //   print('   - ${c.name}');
      // }
      
    } catch (e) {
      debugPrint('❌ Error loading components: $e');
      _components = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void selectComponent(String type, Product component) {
    _selectedComponents[type] = component;
    notifyListeners();
  }
  
  void removeComponent(String type) {
    _selectedComponents[type] = null;
    notifyListeners();
  }
  
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
  
  Future<void> deleteBuild(String buildId, String userId) async {
    await _supabaseService.deleteBuild(buildId);
    await loadUserBuilds(userId);
  }
  
  void clearCurrentBuild() {
    _currentBuild = null;
    _selectedComponents = {};
    notifyListeners();
  }
  
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