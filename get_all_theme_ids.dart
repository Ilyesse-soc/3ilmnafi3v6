// get_all_theme_ids.dart
// Script pour récupérer tous les IDs de thèmes depuis l'API

import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Récupération de tous les IDs de thèmes...\n');
  
  try {
    // URL de l'API pour obtenir tous les thèmes
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/themes');
    
    print('📡 Appel API: $url');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> themes = json.decode(response.body);
      
      print('✅ ${themes.length} thèmes récupérés\n');
      print('📋 Mapping des thèmes:');
      print('=' * 50);
      
      // Générer le mapping pour theme_ids.dart
      print('// Copie ce contenu dans lib/constants/theme_ids.dart\n');
      print('final Map<String, String> themeIds = {');
      
      for (var theme in themes) {
        final String id = theme['id'] ?? '';
        final String name = theme['name'] ?? 'Nom inconnu';
        
        print("  '$name': '$id',");
      }
      
      print('};\n');
      
      // Afficher aussi le détail pour vérification
      print('📝 Détail des thèmes:');
      print('=' * 50);
      for (var theme in themes) {
        print('ID: ${theme['id']}');
        print('Nom: ${theme['name']}');
        print('Description: ${theme['description'] ?? 'N/A'}');
        print('-' * 30);
      }
      
    } else {
      print('❌ Erreur API: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    
  } catch (e) {
    print('❌ Erreur lors de la récupération: $e');
  }
  
  print('\n🏁 Script terminé');
}