import 'dart:convert';

import 'package:http/http.dart' as http;

// Script pour débugger le problème des sous-catégories manquantes
void main() async {
  print('� Debug: Analyse des vidéos du thème Prière\n');
  
  final String prayerThemeId = "33b5b607-10f7-4b40-a1ad-8becbcfa7983";
  
  try {
    print('\n1️⃣ Test endpoint getUserVideos...');
    final response1 = await http.get(
      Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos?uploaderId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response1.statusCode == 200) {
      final List userVideos = json.decode(response1.body);
      print('✅ Vidéos utilisateur trouvées: ${userVideos.length}');
      
      for (int i = 0; i < userVideos.length; i++) {
        final video = userVideos[i];
        print('  ${i + 1}. ${video['title']}');
        print('     - ID: ${video['id']}');
        print('     - ImageURL: ${video['imageUrl'] ?? "null"}');
        print('     - VideoURL: ${video['videoUrl'] ?? "null"}');
        print('     - Valid: ${video['isValid']}');
        print('     - Uploader: ${video['uploader']?['name']}');
      }
    } else {
      print('❌ Erreur getUserVideos: ${response1.statusCode}');
    }
    
    print('\n2️⃣ Test endpoint toutes les vidéos validées...');
    final response2 = await http.get(
      Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid'),
    );
    
    if (response2.statusCode == 200) {
      final data = json.decode(response2.body);
      final List validVideos = data['videos'] ?? [];
      print('✅ Vidéos validées trouvées: ${validVideos.length}');
      
      // Filtrer par utilisateur
      final userValidVideos = validVideos.where((v) => v['uploader']?['id'] == userId).toList();
      print('✅ Mes vidéos validées: ${userValidVideos.length}');
      
      for (int i = 0; i < userValidVideos.length; i++) {
        final video = userValidVideos[i];
        print('  ${i + 1}. ${video['title']}');
        print('     - ImageURL: ${video['imageUrl'] ?? "null"}');
        print('     - VideoURL: ${video['videoUrl'] ?? "null"}');
      }
    } else {
      print('❌ Erreur vidéos validées: ${response2.statusCode}');
    }
    
    print('\n3️⃣ Test endpoint toutes les vidéos...');
    final response3 = await http.get(
      Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos'),
    );
    
    if (response3.statusCode == 200) {
      final List allVideos = json.decode(response3.body);
      print('✅ Toutes les vidéos trouvées: ${allVideos.length}');
      
      // Filtrer par utilisateur
      final userAllVideos = allVideos.where((v) => v['uploader']?['id'] == userId).toList();
      print('✅ Toutes mes vidéos: ${userAllVideos.length}');
    } else {
      print('❌ Erreur toutes vidéos: ${response3.statusCode}');
    }
    
    print('\n📋 RÉSUMÉ:');
    print('• Modifiez le fichier debug_myvideos.dart');
    print('• Remplacez VOTRE_ID_UTILISATEUR par votre vrai ID');
    print('• Exécutez: dart debug_myvideos.dart');
    print('• Vérifiez si imageUrl est null dans les réponses API');
    
  } catch (e) {
    print('❌ Erreur: $e');
  }
}