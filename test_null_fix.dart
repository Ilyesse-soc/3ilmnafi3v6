// Test pour vérifier que le problème des noms null est résolu
void main() {
  print('🧪 Test de gestion des noms null dans MyVideosPage\n');
  
  // Simuler différentes réponses API avec des données manquantes
  final List<Map<String, dynamic>> testCases = [
    {
      'name': 'Cas normal',
      'data': {
        'id': '1',
        'title': 'Test Video 1',
        'imageUrl': 'http://example.com/image.jpg',
        'uploader': {
          'name': 'John Doe',
          'genre': 'homme'
        },
        'isValid': true
      }
    },
    {
      'name': 'Uploader avec name null',
      'data': {
        'id': '2',
        'title': 'Test Video 2',
        'imageUrl': 'http://example.com/image.jpg',
        'uploader': {
          'name': null,
          'genre': 'femme'
        },
        'isValid': false
      }
    },
    {
      'name': 'Uploader vide',
      'data': {
        'id': '3',
        'title': 'Test Video 3',
        'imageUrl': 'http://example.com/image.jpg',
        'uploader': {},
        'isValid': true
      }
    },
    {
      'name': 'Uploader null',
      'data': {
        'id': '4',
        'title': 'Test Video 4',
        'imageUrl': 'http://example.com/image.jpg',
        'uploader': null,
        'isValid': false
      }
    }
  ];
  
  // Fonction de test pour afficherNomRespectueux
  String afficherNomRespectueux(String nom, String genre) {
    final nomMin = nom.trim().toLowerCase();
    if (nomMin.contains('samy') || nomMin.contains('سامي')) {
      return nom;
    }
    if (genre.toLowerCase() == 'femme') {
      return 'Mme $nom';
    }
    return 'Mr. $nom';
  }
  
  print('📋 Test des différents cas:');
  
  for (var testCase in testCases) {
    final name = testCase['name'];
    final data = testCase['data'];
    
    print('\n🔍 Test: $name');
    print('   Data: ${data['uploader']}');
    
    try {
      // Simuler la logique corrigée de MyVideosPage
      final uploader = (data['uploader'] as Map<String, dynamic>?) ?? {};
      final uploaderName = uploader['name'] ?? 'Utilisateur inconnu';
      final uploaderGenre = uploader['genre'] ?? 'homme';
      
      final result = afficherNomRespectueux(uploaderName, uploaderGenre);
      
      print('   ✅ Résultat: "$result"');
      
    } catch (e) {
      print('   ❌ Erreur: $e');
    }
  }
  
  print('\n💡 RÉSUMÉ:');
  print('• Le fix avec "?? \'Utilisateur inconnu\'" gère tous les cas null');
  print('• Plus d\'erreur "type \'Null\' is not a subtype of type \'String\'"');
  print('• L\'interface affiche un nom de fallback pour les données manquantes');
}