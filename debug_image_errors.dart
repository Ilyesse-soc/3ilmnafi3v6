import 'dart:convert';

import 'package:http/http.dart' as http;

// Script pour diagnostiquer les problèmes d'images
void main() async {
  print('🔍 Diagnostic des erreurs d\'images\n');
  
  // URLs typiques qui causent des problèmes
  final List<String> problematicUrls = [
    'http://3ilmnafi3.digilocx.fr/uploads/1748642002190-image_picker_2E844581-83DF-4151-93FE-790D04198607-53568-0000089019F5E2ED.jpg',
    'http://3ilmnafi3.fony5290.odns.fr/uploads/1748006914540-image_picker_7E1D26C8-237A-4F49-A5E3-7E169C2D0A78-28902-0000045A7B85A07E.jpg',
    'http://3ilmnafi3.digilocx.fr/uploads/1749656581069-image_picker_7A40FA35-CF16-4819-9F67-AA373CEC8C02-5365-0000013BF56F7EB8.jpg'
  ];
  
  print('📡 Test des serveurs d\'images:');
  
  for (int i = 0; i < problematicUrls.length; i++) {
    final url = problematicUrls[i];
    final uri = Uri.parse(url);
    final baseUrl = '${uri.scheme}://${uri.host}';
    
    print('\n${i + 1}. Test du serveur: $baseUrl');
    print('   URL complète: $url');
    
    try {
      // Test de connectivité du serveur
      final response = await http.head(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
      print('   ✅ Serveur accessible (${response.statusCode})');
      
      // Test de l'image spécifique
      final imageResponse = await http.head(Uri.parse(url)).timeout(Duration(seconds: 5));
      print('   📷 Image: ${imageResponse.statusCode} ${_getStatusMessage(imageResponse.statusCode)}');
      
      if (imageResponse.statusCode != 200) {
        print('   ⚠️  Image non disponible');
      }
      
    } catch (e) {
      print('   ❌ Erreur: $e');
    }
  }
  
  // Test de l'API principale
  print('\n🔄 Test de l\'API principale:');
  try {
    final response = await http.get(Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid')).timeout(Duration(seconds: 10));
    print('✅ API principale: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = data['videos'] ?? [];
      print('📊 ${videos.length} vidéos trouvées');
      
      // Analyser les URLs d'images dans les données
      int imagesWithProblems = 0;
      int totalImages = 0;
      
      for (var video in videos.take(10)) { // Analyser les 10 premières
        final imageUrl = video['imageUrl'];
        if (imageUrl != null) {
          totalImages++;
          try {
            final imgResponse = await http.head(Uri.parse(imageUrl)).timeout(Duration(seconds: 3));
            if (imgResponse.statusCode != 200) {
              imagesWithProblems++;
            }
          } catch (e) {
            imagesWithProblems++;
          }
        }
      }
      
      print('🖼️  Images analysées: $totalImages');
      print('❌ Images avec problèmes: $imagesWithProblems');
      print('📈 Pourcentage de problèmes: ${(imagesWithProblems / totalImages * 100).toStringAsFixed(1)}%');
    }
    
  } catch (e) {
    print('❌ Erreur API: $e');
  }
  
  print('\n💡 RECOMMANDATIONS:');
  print('1. 🔄 Implémenter un système de retry pour les images');
  print('2. 🖼️  Ajouter des placeholders pour les images manquantes');
  print('3. 🗄️  Migrer les images vers un serveur CDN fiable');
  print('4. ⚡ Mettre en cache les images localement');
  print('5. 📱 Optimiser la gestion d\'erreurs dans l\'UI Flutter');
}

String _getStatusMessage(int statusCode) {
  switch (statusCode) {
    case 200:
      return 'OK';
    case 403:
      return 'Accès interdit';
    case 404:
      return 'Fichier non trouvé';
    case 500:
      return 'Erreur serveur';
    default:
      return 'Erreur $statusCode';
  }
}