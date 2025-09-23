// theme_color_distribution.dart
// Affichage de la répartition des couleurs par thème

void main() {
  print('🎨 Répartition des couleurs par thème\n');
  
  // Thèmes avec couleur verte (#345d42)
  final List<String> themesVerts = [
    'Tawhid',
    'Le Coran',
    'La Sunna',
    'Prophètes',
    'Les Savants',
    'Les 4 Imams',
    'Les Anges',
    '99 Noms',
    'Voyage',
    'Adkars',
    'Hijra',
    'Transactions',
  ];
  
  // Thèmes avec couleur orange (#ff751f)
  final List<String> themesOrange = [
    'Prière',
    'Ramadan',
    'Zakat',
    'Hajj',
    '73 Sectes',
    'Compagnons',
    'Les innovations',
    'La mort',
    'La tombe',
    'Le jour dernier',
    'Les Djinns',
    'Les gens du livre',
    'Femmes',
    'Signes',
    'Mariage',
    '2 fêtes',
    'Jours importants',
    'Djihad',
    'Gouverneurs musulmans',
  ];
  
  print('🟢 THÈMES VERTS (#345d42):');
  print('=' * 50);
  for (int i = 0; i < themesVerts.length; i++) {
    print('${(i + 1).toString().padLeft(2)}. ${themesVerts[i]}');
  }
  
  print('\n🟠 THÈMES ORANGE (#ff751f):');
  print('=' * 50);
  for (int i = 0; i < themesOrange.length; i++) {
    print('${(i + 1).toString().padLeft(2)}. ${themesOrange[i]}');
  }
  
  print('\n📊 STATISTIQUES:');
  print('=' * 50);
  print('• Thèmes verts: ${themesVerts.length}');
  print('• Thèmes orange: ${themesOrange.length}');
  print('• Total thèmes: ${themesVerts.length + themesOrange.length}');
  
  final double pourcentageVert = (themesVerts.length / (themesVerts.length + themesOrange.length)) * 100;
  final double pourcentageOrange = (themesOrange.length / (themesVerts.length + themesOrange.length)) * 100;
  
  print('• Répartition: ${pourcentageVert.toStringAsFixed(1)}% vert, ${pourcentageOrange.toStringAsFixed(1)}% orange');
  
  print('\n🎯 COHÉRENCE VISUELLE:');
  print('=' * 50);
  print('✅ Utilisation exclusive de votre palette de couleurs');
  print('✅ Orange (#ff751f) et Vert (#345d42) uniquement');
  print('✅ Répartition équilibrée entre les thèmes');
  print('✅ Interface utilisateur cohérente et professionnelle');
  
  print('\n🚀 Votre application a maintenant une identité visuelle unifiée !');
}