// test_tawhid_theme.dart
// Script pour vérifier les sous-catégories du thème Tawhid

import 'lib/constants/theme_ids.dart';
import 'lib/constants/theme_subcategories.dart';

void main() {
  print('🔍 Test spécifique du thème Tawhid\n');
  
  final themeName = 'Tawhid';
  
  // 1. Vérifier les sous-catégories
  print('📋 Sous-catégories pour $themeName:');
  print('=' * 50);
  
  final subcategories = themeSubcategories[themeName];
  if (subcategories != null) {
    print('✅ ${subcategories.length} sous-catégories trouvées:');
    for (int i = 0; i < subcategories.length; i++) {
      print('  ${i + 1}. ${subcategories[i]}');
    }
  } else {
    print('❌ Aucune sous-catégorie trouvée pour $themeName');
  }
  
  print('');
  
  // 2. Vérifier l'ID du thème
  print('🆔 ID du thème:');
  print('=' * 50);
  
  final themeId = getThemeId(themeName);
  if (themeId != null) {
    print('✅ ID trouvé: $themeId');
  } else {
    print('❌ Aucun ID trouvé pour $themeName');
  }
  
  print('');
  
  // 3. Vérifier que les sous-catégories attendues sont présentes
  print('✅ Vérification des sous-catégories attendues:');
  print('=' * 50);
  
  final expectedSubcategories = [
    "L'intention",
    "Définition du tawhid",
    "Tawhid de l'adoration",
    "Tawhid de la seigneurie",
    "Tawhid des noms et attributs",
    "Le shirk majeur",
    "Le shirk mineur",
    "Le shirk caché",
    "L'aveux et le désaveu",
    "Tawhid dans le coran",
    "Tawhid dans la Sunna",
  ];
  
  if (subcategories != null) {
    bool allPresent = true;
    for (final expected in expectedSubcategories) {
      if (subcategories.contains(expected)) {
        print('✅ $expected');
      } else {
        print('❌ MANQUANT: $expected');
        allPresent = false;
      }
    }
    
    print('');
    if (allPresent) {
      print('🎉 Toutes les sous-catégories attendues sont présentes !');
    } else {
      print('⚠️ Certaines sous-catégories attendues sont manquantes');
    }
    
    // Vérifier s'il y a des sous-catégories supplémentaires
    final extra = subcategories.where((sc) => !expectedSubcategories.contains(sc)).toList();
    if (extra.isNotEmpty) {
      print('');
      print('📌 Sous-catégories supplémentaires:');
      for (final sc in extra) {
        print('  • $sc');
      }
    }
  }
  
  print('\n🏁 Test terminé');
}

// Import simulé des fonctions (normalement depuis le vrai fichier)
String? getThemeId(String themeName) {
  return themeIds[themeName];
}

bool hasThemeId(String themeName) {
  final id = themeIds[themeName];
  return id != null && id.isNotEmpty;
}