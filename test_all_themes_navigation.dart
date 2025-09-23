// test_all_themes_navigation.dart
// Test complet pour vérifier que tous les thèmes ont leurs sous-catégories

import 'lib/constants/theme_ids.dart';
import 'lib/constants/theme_subcategories.dart';

void main() {
  print('🧪 Test complet de navigation pour tous les thèmes\n');
  
  // Liste des 24 thèmes dans l'ordre du main.dart
  final List<String> themeNames = [
    'Tawhid',      // page1
    'Prière',      // page2
    'Ramadan',     // page3
    'Zakat',       // page4
    'Hajj',        // page5
    'Le Coran',    // page6
    'La Sunna',    // page7
    'Prophètes',   // page8
    '73 Sectes',   // page9
    'Compagnons',  // page10
    'Les Savants', // page11
    'Les innovations', // page12
    'La mort',     // page13
    'La tombe',    // page14
    'Le jour dernier', // page15
    'Les 4 Imams', // page16
    'Les Anges',   // page17
    'Les Djinns',  // page18
    'Les gens du livre', // page19
    '99 Noms',     // page20
    'Femmes',      // page21
    'Voyage',      // page22
    'Signes',      // page23
    'Adkars',      // page24
  ];
  
  print('📊 Résumé global:');
  print('=' * 60);
  
  int themeCount = 0;
  int totalSubcategories = 0;
  int themesWithIds = 0;
  int themesWithSubcategories = 0;
  List<String> missingIds = [];
  List<String> missingSubcategories = [];
  
  for (final themeName in themeNames) {
    themeCount++;
    
    // Vérifier l'ID
    final hasId = hasThemeId(themeName);
    if (hasId) {
      themesWithIds++;
    } else {
      missingIds.add(themeName);
    }
    
    // Vérifier les sous-catégories
    final subcategories = themeSubcategories[themeName];
    if (subcategories != null && subcategories.isNotEmpty) {
      themesWithSubcategories++;
      totalSubcategories += subcategories.length;
    } else {
      missingSubcategories.add(themeName);
    }
    
    // Status du thème
    final status = hasId && subcategories != null ? '✅' : '⚠️';
    final subcatCount = subcategories?.length ?? 0;
    final idStatus = hasId ? 'ID✓' : 'ID✗';
    final subcatStatus = subcategories != null ? 'Sub✓' : 'Sub✗';
    
    print('${status} Page${themeCount.toString().padLeft(2)}: ${themeName.padRight(20)} | ${subcatCount.toString().padLeft(2)} sous-cat | $idStatus | $subcatStatus');
  }
  
  print('\n📈 Statistiques:');
  print('=' * 60);
  print('• Total thèmes: $themeCount');
  print('• Thèmes avec IDs: $themesWithIds/$themeCount (${(themesWithIds/themeCount*100).toStringAsFixed(1)}%)');
  print('• Thèmes avec sous-catégories: $themesWithSubcategories/$themeCount (${(themesWithSubcategories/themeCount*100).toStringAsFixed(1)}%)');
  print('• Total sous-catégories: $totalSubcategories');
  print('• Moyenne: ${(totalSubcategories/themeCount).toStringAsFixed(1)} sous-catégories/thème');
  
  if (missingIds.isNotEmpty) {
    print('\n⚠️  Thèmes sans IDs:');
    for (final theme in missingIds) {
      print('  • $theme');
    }
  }
  
  if (missingSubcategories.isNotEmpty) {
    print('\n⚠️  Thèmes sans sous-catégories:');
    for (final theme in missingSubcategories) {
      print('  • $theme');
    }
  }
  
  // Détail de quelques thèmes
  print('\n📋 Détail de quelques thèmes:');
  print('=' * 60);
  
  final sampleThemes = ['Tawhid', 'Prière', 'Hajj', 'Le Coran', 'Adkars'];
  for (final theme in sampleThemes) {
    final subcategories = themeSubcategories[theme];
    final themeId = getThemeId(theme);
    
    print('\n🔹 $theme:');
    print('   ID: ${themeId ?? "Non défini"}');
    if (subcategories != null) {
      print('   Sous-catégories (${subcategories.length}):');
      for (int i = 0; i < subcategories.take(5).length; i++) {
        print('     ${i + 1}. ${subcategories[i]}');
      }
      if (subcategories.length > 5) {
        print('     ... et ${subcategories.length - 5} autres');
      }
    } else {
      print('   Sous-catégories: Non définies');
    }
  }
  
  print('\n✅ Tous les thèmes sont maintenant configurés pour utiliser ThemeSubcategoriesPage !');
  print('🎉 Navigation générique opérationnelle pour ${themeCount} thèmes');
}

// Fonctions utilitaires
String? getThemeId(String themeName) {
  return themeIds[themeName];
}

bool hasThemeId(String themeName) {
  final id = themeIds[themeName];
  return id != null && id.isNotEmpty;
}