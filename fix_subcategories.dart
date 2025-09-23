import 'dart:convert';

import 'package:http/http.dart' as http;

// Script pour corriger la vidéo existante en ajoutant les sous-catégories
void main() async {
  print('🔧 Correction de la vidéo avec sous-catégories manquantes\n');
  
  final String videoId = "8d82ffb0-de84-4a70-8680-699831075b76";
  final String prayerThemeId = "33b5b607-10f7-4b40-a1ad-8becbcfa7983";
  final String originalReference = "Talib Mehdi Abou Abdilleh / الطالب مهدي بن ناصر";
  final List<String> subcategories = ["Les ablutions"];
  
  try {
    print('📝 Données de correction:');
    print('   - Video ID: $videoId');
    print('   - Intervenant: $originalReference');
    print('   - Sous-catégories à ajouter: $subcategories');
    
    // Créer la nouvelle référence encodée
    final newReference = '$originalReference|SUBCATS|${subcategories.join(',')}';
    print('   - Nouvelle référence: $newReference');
    print('');
    
    // Appel API PUT pour mettre à jour la vidéo
    print('🔄 Mise à jour de la vidéo...');
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/$videoId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'reference': newReference,
      }),
    );
    
    print('📡 Status code: ${response.statusCode}');
    print('📥 Response: ${response.body}');
    
    if (response.statusCode == 200) {
      print('\n✅ SUCCÈS ! La vidéo a été mise à jour avec les sous-catégories.');
      print('🎯 Elle devrait maintenant apparaître dans la sous-catégorie "Les ablutions".');
      
      // Vérification immédiate
      print('\n🔍 Vérification de la mise à jour...');
      final checkUrl = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$prayerThemeId');
      final checkResponse = await http.get(checkUrl);
      
      if (checkResponse.statusCode == 200) {
        final data = json.decode(checkResponse.body);
        final videos = data['videos'] ?? [];
        final updatedVideo = videos.firstWhere((v) => v['id'] == videoId, orElse: () => null);
        
        if (updatedVideo != null) {
          print('📹 Vidéo trouvée après mise à jour:');
          print('   - Référence: "${updatedVideo['reference']}"');
          
          // Test de décodage
          final ref = updatedVideo['reference'] ?? '';
          if (ref.contains('|SUBCATS|')) {
            final parts = ref.split('|SUBCATS|');
            final decodedSubcats = parts.length >= 2 ? parts[1].split(',') : [];
            print('   - Sous-catégories décodées: $decodedSubcats');
            print('   ✅ Encodage correct détecté !');
          } else {
            print('   ❌ Erreur: Pas d\'encodage sous-catégories détecté');
          }
        }
      }
      
    } else {
      print('\n❌ ÉCHEC de la mise à jour');
      print('Vérifiez que l\'ID de la vidéo est correct et que l\'API fonctionne.');
    }
    
  } catch (e) {
    print('❌ Erreur: $e');
  }
  
  print('\n💡 REMARQUES:');
  print('• Maintenant l\'app utilise UploadPageV2 qui encode automatiquement les sous-catégories');
  print('• Les futures vidéos seront uploadées avec le bon format');
  print('• Testez la navigation: Prière → Les ablutions pour vérifier');
}