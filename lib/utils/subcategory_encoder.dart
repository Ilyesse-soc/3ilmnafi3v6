// lib/utils/subcategory_encoder.dart

import '../services/video_service.dart';

/// Utility class to encode/decode subcategories in existing API fields
/// Since the backend doesn't support subcategories, we'll encode them in the reference field
class SubcategoryEncoder {
  static const String _separator = ' | ';
  static const String _subcatPrefix = '[SUBCAT]';
  
  /// Encode subcategories with reference in a single field
  /// Format: "Reference | [SUBCAT] subcat1, subcat2, subcat3"
  static String encodeWithReference(String reference, List<String> subcategories) {
    if (subcategories.isEmpty) {
      return reference;
    }
    
    final subcatString = subcategories.join(', ');
    return '$reference$_separator$_subcatPrefix $subcatString';
  }
  
  /// Decode reference and subcategories from encoded field
  /// Returns: {reference: "actual reference", subcategories: ["subcat1", "subcat2"]}
  static Map<String, dynamic> decodeFromReference(String encodedReference) {
    if (!encodedReference.contains(_subcatPrefix)) {
      return {
        'reference': encodedReference,
        'subcategories': <String>[],
      };
    }
    
    final parts = encodedReference.split(_separator);
    if (parts.length >= 2) {
      final reference = parts[0];
      final subcatPart = parts[1];
      
      if (subcatPart.startsWith(_subcatPrefix)) {
        final subcatString = subcatPart.substring(_subcatPrefix.length).trim();
        final subcategories = subcatString.split(', ')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        
        return {
          'reference': reference,
          'subcategories': subcategories,
        };
      }
    }
    
    // Fallback
    return {
      'reference': encodedReference,
      'subcategories': <String>[],
    };
  }
  
  /// Extract just the reference from encoded field
  static String extractReference(String encodedReference) {
    final decoded = decodeFromReference(encodedReference);
    return decoded['reference'] as String;
  }
  
  /// Extract just the subcategories from encoded field
  static List<String> extractSubcategories(String encodedReference) {
    final decoded = decodeFromReference(encodedReference);
    return decoded['subcategories'] as List<String>;
  }

  /// Récupère les sous-catégories depuis l'API (remplace les données mock)
  static Future<Map<int, List<String>>> getSubcategoriesFromAPI() async {
    try {
      return await VideoService.getSubcategoriesForEncoder();
    } catch (e) {
      print('❌ Erreur récupération sous-catégories API: $e');
      // Fallback sur les données mock si l'API échoue
      return _getMockSubcategories();
    }
  }

  /// Données mock de fallback
  static Map<int, List<String>> _getMockSubcategories() {
    return {
      1: ["Histoire des prophètes", "Biographie du Prophète", "Les compagnons", "Récits coraniques", "Leçons historiques"],
      2: ["Piliers de l'Islam", "Articles de foi", "Purification", "Prière", "Zakat"],
      3: ["Tafsir Coran", "Sciences coraniques", "Récitation", "Mémorisation", "Exégèse"],
    };
  }
}