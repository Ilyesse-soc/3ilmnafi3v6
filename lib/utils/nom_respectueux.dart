/// Retourne le nom précédé de "Mr." ou "Mme." selon le genre.
/// [nom] : le nom de la personne.
/// [genre] : "homme" ou "femme".
String afficherNomRespectueux(String nom, String genre) {
  final nomMin = nom.trim().toLowerCase();
  // Liste des variantes possibles pour Samy (français/arabe)
  if (nomMin.contains('samy') || nomMin.contains('سامي')) {
    return nom; // Pas de titre pour Samy
  }
  if (genre.toLowerCase() == 'femme') {
    return 'Mme $nom';
  }
  return 'Mr. $nom';
}
