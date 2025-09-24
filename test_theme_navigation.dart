// test_theme_navigation.dart
// Script pour tester la navigation générique des thèmes

import 'dart:convert';

import 'package:http/http.dart' as http;


import 'lib/constants/theme_ids.dart';
import 'lib/constants/theme_subcategories.dart';

void main() async {
  print('🧪 Test de la navigation générique des thèmes\n');
  
  // 1. Vérifier la cohérence entre themeIds et themeSubcategories
  await testThemeConsistency();
  
  // 2. Tester quelques thèmes avec l'API
  await testThemeApiCalls();
  
  // 3. Vérifier les sous-catégories
  await testSubcategoryMapping();
  
  print('\n✅ Tests terminés');
}

Future<void> testThemeConsistency() async {
  print('🔍 Test 1: Cohérence des données de thèmes');
  print('=' * 50);
  
  final themesWithIds = themeIds.keys.toSet();
  final themesWithSubcategories = themeSubcategories.keys.toSet();
  
  print('📊 Thèmes avec IDs: ${themesWithIds.length}');
  print('📊 Thèmes avec sous-catégories: ${themesWithSubcategories.length}');
  
  // Thèmes qui ont des IDs mais pas de sous-catégories
  final missingSubcategories = themesWithIds.difference(themesWithSubcategories);
  if (missingSubcategories.isNotEmpty) {
    print('⚠️  Thèmes sans sous-catégories: $missingSubcategories');
  }
  
  // Thèmes qui ont des sous-catégories mais pas d'IDs
  final missingIds = themesWithSubcategories.difference(themesWithIds);
  if (missingIds.isNotEmpty) {
    print('⚠️  Thèmes sans IDs: $missingIds');
  }
  
  // Thèmes complets (ID + sous-catégories)
  final completeThemes = themesWithIds.intersection(themesWithSubcategories);
  print('✅ Thèmes complets: ${completeThemes.length}');
  
  for (final theme in completeThemes.take(5)) {
    final subcategoryCount = themeSubcategories[theme]?.length ?? 0;
    print('  • $theme: $subcategoryCount sous-catégories');
  }
  
  print('');
}

Future<void> testThemeApiCalls() async {
  print('🌐 Test 2: Appels API des thèmes');
  print('=' * 50);
  
  // Tester quelques thèmes
  final testThemes = ['Prière', 'Tawhid', 'Ramadan'];
  
  for (final themeName in testThemes) {
    final themeId = getThemeId(themeName);
    if (themeId == null) {
      print('❌ $themeName: ID non trouvé');
      continue;
    }
    
    try {
      final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$themeId');
      print('📡 Test API pour $themeName (ID: ${themeId.substring(0, 8)}...)');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoCount = (data['data'] as List?)?.length ?? 0;
        print('✅ $themeName: $videoCount vidéos trouvées');
      } else {
        print('❌ $themeName: Erreur ${response.statusCode}');
      }
    } catch (e) {
      print('❌ $themeName: Erreur réseau - $e');
    }
  }
  
  print('');
}

Future<void> testSubcategoryMapping() async {
  print('📋 Test 3: Mapping des sous-catégories');
  print('=' * 50);
  
  var totalSubcategories = 0;
  var themeCount = 0;
  
  for (final entry in themeSubcategories.entries) {
    final themeName = entry.key;
    final subcategories = entry.value;
    
    totalSubcategories += subcategories.length;
    themeCount++;
    
    // Vérifier si le thème a un ID
    final hasId = hasThemeId(themeName);
    final status = hasId ? '✅' : '⚠️';
    
    if (themeCount <= 10) { // Afficher seulement les 10 premiers pour ne pas surcharger
      print('$status $themeName: ${subcategories.length} sous-catégories${hasId ? '' : ' (pas d\'ID)'}');
    }
  }
  
  print('\n📊 Résumé:');
  print('  • Total thèmes: $themeCount');
  print('  • Total sous-catégories: $totalSubcategories');
  print('  • Moyenne: ${(totalSubcategories / themeCount).toStringAsFixed(1)} sous-catégories/thème');
  
  print('');
}

// Import simulé des fonctions (normalement depuis le vrai fichier)
String? getThemeId(String themeName) {
  return themeIds[themeName];
}

bool hasThemeId(String themeName) {
  final id = themeIds[themeName];
  return id != null && id.isNotEmpty;
}
