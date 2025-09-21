import 'dart:convert';

import 'package:http/http.dart' as http;

class SubcategoryApiService {
  static const String baseUrl = 'https://3ilmnafi3.digilocx.fr/api';
  
  // Test de connexion à l'API
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Test API Status: ${response.statusCode}');
      print('Test API Response: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur test connexion API: $e');
      return false;
    }
  }
  
  // Récupérer toutes les sous-catégories
  static Future<List<Map<String, dynamic>>> getAllSubcategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subcategories'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Subcategories API Status: ${response.statusCode}');
      print('Subcategories API Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Erreur récupération sous-catégories: $e');
      return [];
    }
  }
  
  // Récupérer sous-catégories par thème
  static Future<List<Map<String, dynamic>>> getSubcategoriesByTheme(int themeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subcategories/theme/$themeId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Subcategories by theme API Status: ${response.statusCode}');
      print('Subcategories by theme API Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Erreur récupération sous-catégories par thème: $e');
      return [];
    }
  }
  
  // Comparer avec les sous-catégories encodées localement
  static Future<void> compareWithLocalData() async {
    print('=== COMPARAISON API vs LOCAL ===');
    
    // Test connexion
    bool connected = await testConnection();
    print('Connexion API: ${connected ? "✅ OK" : "❌ ÉCHEC"}');
    
    if (!connected) return;
    
    // Test toutes les sous-catégories
    List<Map<String, dynamic>> apiSubcategories = await getAllSubcategories();
    print('Sous-catégories depuis API: ${apiSubcategories.length}');
    
    // Test par thème
    for (int themeId = 1; themeId <= 3; themeId++) {
      List<Map<String, dynamic>> themeSubcategories = await getSubcategoriesByTheme(themeId);
      print('Thème $themeId - Sous-catégories: ${themeSubcategories.length}');
      
      // Afficher quelques exemples
      if (themeSubcategories.isNotEmpty) {
        print('  Exemples: ${themeSubcategories.take(2).map((s) => s['name']).join(', ')}');
      }
    }
    
    print('=== FIN COMPARAISON ===');
  }
}