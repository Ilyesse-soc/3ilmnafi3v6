import 'dart:convert';

import 'package:http/http.dart' as http;

// Script pour débugger le problème des sous-catégories manquantes
void main() async {
  print('🔍 Debug: Analyse des vidéos du thème Prière\n');
  
  final String prayerThemeId = "33b5b607-10f7-4b40-a1ad-8becbcfa7983";
  
  try {
    print('📡 Appel API pour le thème Prière...');
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$prayerThemeId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List videosJson = data['videos'] ?? [];
      
      print('✅ ${videosJson.length} vidéo(s) trouvée(s) dans le thème Prière\n');
      
      for (int i = 0; i < videosJson.length; i++) {
        final video = videosJson[i];
        print('📹 VIDÉO ${i + 1}:');
        print('   ID: ${video['id']}');
        print('   Titre: ${video['title']}');
        print('   Uploader: ${video['uploader']?['name'] ?? 'N/A'}');
        print('   Reference (brut): "${video['reference'] ?? ''}"');
        
        // Analyser le champ reference pour voir les sous-catégories
        final rawReference = video['reference'] ?? '';
        print('   Longueur reference: ${rawReference.length}');
        
        // Vérifier si c'est encodé
        if (rawReference.contains('|SUBCATS|')) {
          print('   ✅ Format avec sous-catégories détecté');
          final parts = rawReference.split('|SUBCATS|');
          if (parts.length >= 2) {
            print('   Reference propre: "${parts[0]}"');
            print('   Sous-catégories encodées: "${parts[1]}"');
            
            try {
              final subcatsList = parts[1].split(',').map((s) => s.trim()).toList();
              print('   Sous-catégories décodées: $subcatsList');
            } catch (e) {
              print('   ❌ Erreur décodage sous-catégories: $e');
            }
          }
        } else {
          print('   ⚠️  Pas de sous-catégories encodées (format simple)');
        }
        
        // Afficher les thèmes
        final themes = video['themes'] as List? ?? [];
        print('   Thèmes: ${themes.length}');
        for (var theme in themes) {
          print('     - ${theme['name'] ?? 'N/A'} (ID: ${theme['id'] ?? 'N/A'})');
        }
        
        print('   IsValid: ${video['isValid'] ?? false}');
        print('   Created: ${video['createdAt'] ?? 'N/A'}');
        print('');
      }
      
      // Recommandations
      print('💡 RECOMMANDATIONS:');
      if (videosJson.isNotEmpty) {
        final firstVideo = videosJson[0];
        final rawRef = firstVideo['reference'] ?? '';
        
        if (!rawRef.contains('|SUBCATS|')) {
          print('❌ PROBLÈME: Les sous-catégories ne sont pas encodées dans le champ reference');
          print('');
          print('🛠️  SOLUTIONS POSSIBLES:');
          print('1. Vérifier que l\'upload encode correctement les sous-catégories');
          print('2. Vérifier le service VideoService.submitVideo()');
          print('3. Vérifier que l\'API backend sauvegarde les sous-catégories');
          print('4. Re-uploader la vidéo avec les sous-catégories correctes');
          print('');
          print('📝 Format attendu dans reference:');
          print('   "NomIntervenant|SUBCATS|SousCategorie1,SousCategorie2"');
          print('   Exemple: "Cheikh Al-Albani|SUBCATS|Les ablutions,Les règles"');
        } else {
          print('✅ Format correct détecté');
        }
      }
      
    } else {
      print('❌ Erreur API: ${response.statusCode}');
      print('Response: ${response.body}');
    }
    
  } catch (e) {
    print('❌ Erreur réseau: $e');
  }
}