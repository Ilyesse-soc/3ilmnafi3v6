// test_theme_colors.dart
// Test pour vérifier que tous les thèmes utilisent les bonnes couleurs

import 'dart:io';

void main() {
  print('🎨 Test des couleurs des thèmes\n');
  
  // Couleurs attendues
  final String orange = '#ff751f';
  final String vert = '#345d42';
  
  print('🖌️  Couleurs définies:');
  print('   Orange: $orange');
  print('   Vert:   $vert');
  
  print('\n📋 Vérification du code ThemeSubcategoriesPage...');
  
  // Lire le fichier theme_subcategories_page.dart
  final file = File('lib/screens/theme_subcategories_page.dart');
  if (!file.existsSync()) {
    print('❌ Fichier non trouvé: ${file.path}');
    return;
  }
  
  final content = file.readAsStringSync();
  
  // Vérifier la présence des bonnes couleurs
  bool hasOrange = content.contains('0xffff751f');
  bool hasVert = content.contains('0xff345d42');
  
  print('\n🔍 Résultats de l\'analyse:');
  print('   ${hasOrange ? "✅" : "❌"} Orange (#ff751f) trouvé dans le code');
  print('   ${hasVert ? "✅" : "❌"} Vert (#345d42) trouvé dans le code');
  
  // Vérifier qu'il n'y a plus de couleurs Flutter par défaut dans _getThemeColor
  List<String> oldColors = [
    'Colors.orange',
    'Colors.green',
    'Colors.blue',
    'Colors.purple',
    'Colors.brown',
    'Colors.teal',
    'Colors.indigo',
    'Colors.amber',
    'Colors.red',
    'Colors.lightGreen',
    'Colors.deepOrange',
    'Colors.blueGrey',
    'Colors.grey',
    'Colors.black87',
    'Colors.deepPurple',
    'Colors.cyan',
    'Colors.lightBlue',
    'Colors.lime',
    'Colors.pink',
    'Colors.pinkAccent',
    'Colors.yellow'
  ];
  
  print('\n🔍 Vérification des anciennes couleurs:');
  bool hasOldColors = false;
  for (String oldColor in oldColors) {
    if (content.contains('return $oldColor')) {
      print('   ⚠️  Ancienne couleur trouvée: $oldColor');
      hasOldColors = true;
    }
  }
  
  if (!hasOldColors) {
    print('   ✅ Aucune ancienne couleur Flutter trouvée');
  }
  
  // Vérifier les définitions des variables dans _getThemeColor
  bool hasOrangeVar = content.contains('final Color orange = Color(0xffff751f)');
  bool hasVertVar = content.contains('final Color vert = Color(0xff345d42)');
  
  print('\n🔧 Vérification des variables:');
  print('   ${hasOrangeVar ? "✅" : "❌"} Variable orange définie correctement');
  print('   ${hasVertVar ? "✅" : "❌"} Variable vert définie correctement');
  
  // Résumé
  print('\n📊 Résumé:');
  bool allGood = hasOrange && hasVert && hasOrangeVar && hasVertVar && !hasOldColors;
  print('   ${allGood ? "🎉 PARFAIT" : "⚠️  À CORRIGER"} - Couleurs ${allGood ? "correctement appliquées" : "non conformes"}');
  
  if (allGood) {
    print('\n✅ Tous les thèmes utilisent maintenant uniquement:');
    print('   🟠 Orange (#ff751f) - pour certains thèmes');
    print('   🟢 Vert (#345d42) - pour les autres thèmes');
    print('\n🎨 Interface utilisateur cohérente avec votre charte graphique !');
  } else {
    print('\n❌ Des corrections sont nécessaires pour la cohérence des couleurs.');
  }
}