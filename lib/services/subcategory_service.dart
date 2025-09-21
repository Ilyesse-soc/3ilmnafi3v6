import 'package:flutter/material.dart';

import 'subcategory_api_service.dart';

/// Service centralisé pour la gestion des sous-catégories
/// Combine l'API et le système d'encodage pour une transition douce
class SubcategoryService {
  static const bool _useAPI = true; // Toggle pour activer/désactiver l'API
  
  /// Récupère toutes les sous-catégories disponibles
  static Future<List<Map<String, dynamic>>> getAllSubcategories() async {
    if (_useAPI) {
      try {
        debugPrint('🌐 Récupération depuis l\'API...');
        final apiSubcategories = await SubcategoryApiService.getAllSubcategories();
        if (apiSubcategories.isNotEmpty) {
          debugPrint('✅ API: ${apiSubcategories.length} sous-catégories récupérées');
          return apiSubcategories;
        }
      } catch (e) {
        debugPrint('❌ Erreur API, fallback sur données mock: $e');
      }
    }
    
    // Fallback sur les données mock
    return _getMockSubcategories();
  }

  /// Récupère les sous-catégories par thème
  static Future<List<Map<String, dynamic>>> getSubcategoriesByTheme(int themeId) async {
    if (_useAPI) {
      try {
        debugPrint('🌐 Récupération thème $themeId depuis l\'API...');
        final apiSubcategories = await SubcategoryApiService.getSubcategoriesByTheme(themeId);
        if (apiSubcategories.isNotEmpty) {
          debugPrint('✅ API: ${apiSubcategories.length} sous-catégories pour thème $themeId');
          return apiSubcategories;
        }
      } catch (e) {
        debugPrint('❌ Erreur API thème, fallback: $e');
      }
    }
    
    // Fallback sur les données mock
    final mockData = _getMockSubcategoriesMap();
    return mockData[themeId] ?? [];
  }

  /// Format pour l'affichage dans l'interface utilisateur
  static Future<Map<String, List<String>>> getSubcategoriesForUI() async {
    try {
      final allSubcategories = await getAllSubcategories();
      Map<String, List<String>> result = {};
      
      // Grouper par nom de thème
      for (var subcategory in allSubcategories) {
        final themeId = subcategory['themeId'] as int;
        final name = subcategory['name'] as String;
        final themeKey = 'theme_$themeId'; // On pourrait améliorer ça avec les vrais noms de thèmes
        
        if (!result.containsKey(themeKey)) {
          result[themeKey] = [];
        }
        result[themeKey]!.add(name);
      }
      
      return result;
    } catch (e) {
      debugPrint('❌ Erreur format UI: $e');
      return {};
    }
  }

  /// Convertit les sous-catégories en format legacy pour l'encodeur
  static Future<Map<int, List<String>>> getSubcategoriesForEncoder() async {
    try {
      final allSubcategories = await getAllSubcategories();
      Map<int, List<String>> result = {};
      
      for (var subcategory in allSubcategories) {
        final themeId = subcategory['themeId'] as int;
        final name = subcategory['name'] as String;
        
        if (!result.containsKey(themeId)) {
          result[themeId] = [];
        }
        result[themeId]!.add(name);
      }
      
      debugPrint('📊 Format encodeur: ${result.keys.length} thèmes, ${allSubcategories.length} sous-catégories');
      return result;
    } catch (e) {
      debugPrint('❌ Erreur format encodeur: $e');
      return _getMockSubcategoriesForEncoder();
    }
  }

  /// Test de connectivité de l'API
  static Future<bool> testAPIConnection() async {
    try {
      return await SubcategoryApiService.testConnection();
    } catch (e) {
      debugPrint('❌ Test connexion échoué: $e');
      return false;
    }
  }

  /// Données mock de fallback
  static List<Map<String, dynamic>> _getMockSubcategories() {
    return [
      // Thème 1 - Histoire et Biographie
      { "id": 1, "name": "Histoire des prophètes", "themeId": 1 },
      { "id": 2, "name": "Biographie du Prophète", "themeId": 1 },
      { "id": 3, "name": "Les compagnons", "themeId": 1 },
      { "id": 4, "name": "Récits coraniques", "themeId": 1 },
      { "id": 5, "name": "Leçons historiques", "themeId": 1 },
      
      // Thème 2 - Pratique religieuse
      { "id": 6, "name": "Piliers de l'Islam", "themeId": 2 },
      { "id": 7, "name": "Articles de foi", "themeId": 2 },
      { "id": 8, "name": "Purification", "themeId": 2 },
      { "id": 9, "name": "Prière", "themeId": 2 },
      { "id": 10, "name": "Zakat", "themeId": 2 },
      
      // Thème 3 - Sciences coraniques
      { "id": 11, "name": "Tafsir Coran", "themeId": 3 },
      { "id": 12, "name": "Sciences coraniques", "themeId": 3 },
      { "id": 13, "name": "Récitation", "themeId": 3 },
      { "id": 14, "name": "Mémorisation", "themeId": 3 },
      { "id": 15, "name": "Exégèse", "themeId": 3 },
    ];
  }

  /// Version map des données mock pour compatibilité
  static Map<int, List<Map<String, dynamic>>> _getMockSubcategoriesMap() {
    final mockList = _getMockSubcategories();
    Map<int, List<Map<String, dynamic>>> result = {};
    
    for (var subcategory in mockList) {
      final themeId = subcategory['themeId'] as int;
      if (!result.containsKey(themeId)) {
        result[themeId] = [];
      }
      result[themeId]!.add(subcategory);
    }
    
    return result;
  }

  /// Version simple pour l'encodeur legacy
  static Map<int, List<String>> _getMockSubcategoriesForEncoder() {
    return {
      1: ["Histoire des prophètes", "Biographie du Prophète", "Les compagnons", "Récits coraniques", "Leçons historiques"],
      2: ["Piliers de l'Islam", "Articles de foi", "Purification", "Prière", "Zakat"],
      3: ["Tafsir Coran", "Sciences coraniques", "Récitation", "Mémorisation", "Exégèse"],
    };
  }
}