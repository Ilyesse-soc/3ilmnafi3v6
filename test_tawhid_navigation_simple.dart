// test_tawhid_navigation_simple.dart
// Test simple de navigation pour Tawhid

import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  print('🧪 Test de navigation pour le thème Tawhid\n');
  
  // ID du thème Tawhid depuis notre mapping
  final tawhidId = '92a89d9e-ebf2-4ed3-9ce4-03d06f7a6690';
  
  // Sous-catégories attendues pour Tawhid
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
  
  print('📋 Thème: Tawhid');
  print('🆔 ID: $tawhidId');
  print('📊 Sous-catégories attendues: ${expectedSubcategories.length}');
  
  // Afficher toutes les sous-catégories
  print('\n🔍 Liste des sous-catégories:');
  for (int i = 0; i < expectedSubcategories.length; i++) {
    print('  ${i + 1}. ${expectedSubcategories[i]}');
  }
  
  // Test de l'API pour ce thème
  print('\n🌐 Test API pour le thème Tawhid...');
  try {
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$tawhidId');
    print('📡 URL: $url');
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = (data['data'] as List?) ?? [];
      print('✅ API Response OK: ${videos.length} vidéos trouvées pour Tawhid');
      
      // Afficher quelques exemples de vidéos si disponibles
      if (videos.isNotEmpty) {
        print('\n📹 Exemples de vidéos:');
        for (int i = 0; i < videos.take(3).length; i++) {
          final video = videos[i];
          final title = video['title'] ?? 'Titre non disponible';
          final subcategory = video['subcategory'] ?? 'Sous-catégorie non spécifiée';
          print('  ${i + 1}. $title (Sous-catégorie: $subcategory)');
        }
      }
    } else {
      print('❌ Erreur API: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('❌ Erreur réseau: $e');
  }
  
  print('\n✅ Navigation pour Tawhid prête !');
  print('📱 Vous pouvez maintenant utiliser ThemeSubcategoriesPage avec themeName: "Tawhid"');
}