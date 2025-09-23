import 'dart:convert';

import 'package:http/http.dart' as http;

// Script pour tester les sous-catégories et les vidéos associées
void main() async {
  print('🧪 Test des sous-catégories du thème Prière');
  
  const String prayerThemeId = "33b5b607-10f7-4b40-a1ad-8becbcfa7983";
  
  // Sous-catégories prédéfinies du thème Prière
  final List<String> prayerSubcategories = [
    'Les ablutions',
    'Le ghusl (lavage)',
    'Le Tayammum',
    'Les règles',
    'Istikhara (demande)',
    'Istisqa (pluie)',
    'Vendredi',
    'Les 5 prières obligatoires',
    'Les 12 rawatib',
    'Mortuaire',
    'Prière de nuit',
    'Salat Doha (jour montant)',
    'Salat al koussouf (éclipse)',
    'Prière du voyageur',
  ];
  
  try {
    print('\n1️⃣ Récupération des vidéos du thème Prière...');
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$prayerThemeId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List videosJson = data['videos'] ?? [];
      
      print('✅ ${videosJson.length} vidéos trouvées pour le thème Prière');
      
      // Compter les vidéos par sous-catégorie
      Map<String, int> counts = {};
      Map<String, List<String>> videosBySubcategory = {};
      
      for (final videoJson in videosJson) {
        final videoTitle = videoJson['title'] ?? 'Sans titre';
        final subcategories = List<String>.from(videoJson['subcategories'] ?? []);
        
        print('📹 $videoTitle');
        print('   Sous-catégories: $subcategories');
        
        for (final subcategory in subcategories) {
          counts[subcategory] = (counts[subcategory] ?? 0) + 1;
          videosBySubcategory[subcategory] ??= [];
          videosBySubcategory[subcategory]!.add(videoTitle);
        }
      }
      
      print('\n2️⃣ Statistiques par sous-catégorie:');
      for (final subcategory in prayerSubcategories) {
        final count = counts[subcategory] ?? 0;
        print('📂 $subcategory: $count vidéos');
        
        if (count > 0) {
          final videos = videosBySubcategory[subcategory] ?? [];
          for (int i = 0; i < videos.length; i++) {
            print('   ${i + 1}. ${videos[i]}');
          }
        }
        print('');
      }
      
      print('3️⃣ Sous-catégories non définies trouvées dans les vidéos:');
      for (final entry in counts.entries) {
        if (!prayerSubcategories.contains(entry.key)) {
          print('❓ "${entry.key}": ${entry.value} vidéos');
        }
      }
      
    } else {
      print('❌ Erreur HTTP: ${response.statusCode}');
    }
    
  } catch (e) {
    print('❌ Erreur: $e');
  }
  
  print('\n📝 Instructions:');
  print('1. Les sous-catégories avec 0 vidéos apparaîtront dans l\'interface');
  print('2. Cliquer sur une sous-catégorie navigue vers ses vidéos');  
  print('3. Les sous-catégories vides afficheront "Aucune vidéo trouvée"');
  print('4. Utilisez ce test pour vérifier la cohérence des données');
}