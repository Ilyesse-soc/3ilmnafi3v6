// Script pour analyser la couverture des sous-catégories par thème
import 'dart:convert';

void main() {
  print('📋 ANALYSE COMPLÈTE DES SOUS-CATÉGORIES PAR THÈME\n');
  
  // Données copiées du fichier theme_subcategories.dart
  final Map<String, List<String>> themeSubcategories = {
    'Tawhid': [
      'L'intention',
      'Définition du tawhid',
      'Tawhid de l'adoration',
      'Tawhid de la seigneurie',
      'Tawhid des noms et attributs',
      'Le shirk majeur',
      'Le shirk mineur',
      'Le shirk caché',
      'L'aveux et le désaveu',
      'Tawhid dans le coran',
      'Tawhid dans la Sunna',
    ],
    'Prière': [
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
    ],
    'Ramadan': [
      'Les 10 dernières nuits',
      'Nuit du destin',
      'Le jeûne',
      'Le Sahur',
      'La coupure du jeûne',
      'Prière de nuit pendant le ramadan',
    ],
    'Zakat': [
      'Al-Fitr (nourriture)',
      'Al-mal (argent)',
      'Différence entre zakat et sadaqah',
      'Erreurs courantes dans les zakat',
      'Nissab (seuil minimum)',
    ],
    'Hajj': [
      'Le grand pèlerinage (Hajj)',
      'Le petit pèlerinage (Omra)',
      'Condition d'obligation du Hajj',
      'Les piliers du Hajj',
      'Les obligations du Hajj',
      'Le jour de 3arafa',
      'Hajj de la Femme',
      'Récompense et mérite du hajj',
      'Les 10 premiers jours de Dhoul Hijja',
    ],
    'Le Coran': [
      'Récitation',
      'Tafsir (Exégèse)',
      '7 ahruf (mode de récitation)',
      '10 qira\'at (lectures authentique)',
      'Les causes de révélation',
      'Ruqyah, le Coran et la guérison',
      'Mérite de la lecture du Coran',
      'Miracle linguistiques et scientifique du Coran',
    ],
    'La Sunna': [
      'Hadith Qudsi',
      'Hadith Moutawatir',
      'Al Mouwatta (Imam Malik)',
      'Musnad Ahmad ibn hanbal',
      'Sunan Darimi',
      'Sahih Al Boukhary',
      'Sahih Muslim',
      'Sunan Abu Dawud',
      'Sunan Tirmidhi',
      'Sunan As sughra (Nasa\'i)',
      'Sunan Ibn Maja',
    ],
    'Prophètes': [
      'Messagers',
      'Prophètes',
      'Messager Mohammed',
      'Messager Nouh',
      'Messager Ibrahim',
      'Messager Moussa',
      'Messager Issa',
      'Différence entre Prophète et Messager',
    ],
    '73 Sectes': [
      'Al Ikhwan',
      'Khawarij',
      'Al rafidah/ Chiite',
      'Mu\'tazila',
      'Al jahmiyya',
      'Al murjia',
      'Ash\'a3ira',
      'Al Qadariyya',
      'As soufiya',
      'Al isma\'ilia Batiniya',
      'Al qur\'aniyyun',
    ],
    'Compagnons': [
      'Définition de sahabi',
      'Les 10 promis au paradis',
      'Abu Bakr',
      'Omar Ibn Al khattab',
      'Othman Ibn Affan',
      'Ali Ibn Abu Talib',
      'Vertus des compagnons',
      'Les femmes parmi les compagnons',
    ],
    'Les innovations': [
      'Définition de l\'innovation',
      'Innovations en croyance',
      'Innovation en adoration',
      'Danger de l'innovation',
      'Bonne innovation ?',
      'Fêtes innové',
      'Réfuter les innovateurs',
    ],
    'Les Savants': [
      'Statut du savant en Islam',
      'Savants de la sunnah',
      'Les grands savants dans l'Islam',
    ],
    'La mort': [
      'Signe de la bonne/ mauvaise fin',
      'Ce qui profite au mort',
      'Lavage du mort',
      'Ce qu\'on dit à une personne mourante',
      'Deuil et condoléances',
      'Rites interdits',
    ],
    'La tombe': [
      'Al barzakh',
      'L\'enterrement',
      'Visite des tombes (homme)',
      'Invocation pour les morts',
      'Châtiment de la tombe',
      'Questions des Anges',
      'Les interdictions autour des tombes',
    ],
    'Le jour dernier': [
      'Le rassemblement',
      'La balance',
      'La résurrection',
      'Le paradis et l\'enfer',
      'L\'intercession',
      'Le sirat (pont)',
    ],
    'Les 4 Imams': [
      'Abou Hanifa',
      'Malik ibn Anas',
      'Ach chafi3i',
      'Ahmed ibn Hanbal',
    ],
    'Les Anges': [
      'Création des anges',
      'Jibril',
      'Malik',
      'Mounkar wa Nakir',
      'Ange de la mort',
      'Ange scribes',
      'Les anges dans les assemblées de dhikr',
      'Les anges le jour du jugement',
      'Les anges et le nouveau né',
      'Amour pour les anges',
    ],
    'Les Djinns': [
      'Création des Djinns',
      'Type de Djinns',
      'Possession',
      'Protection contre les Djinns',
      'Ruqya',
      'Sorcellerie',
    ],
    'Les gens du livre': [
      'Torah (Moussa)',
      'Évangile (Issa)',
      'Psaume de Dawud',
      'Feuillets d\'Ibrahim',
      'Mariage avec une femme des gens du livre',
      'Nourriture des gens du livre',
      'Conversion des gens du livre à l\'islam',
      'Relation et comportement avec les gens du livre',
    ],
    '99 Noms': [
      'Mérite de les apprendre',
      'Noms liés à la puissance',
      'Noms liés à la miséricorde',
      'Noms liés à la connaissance',
      'Définition des noms parfaits',
    ],
    'Femmes': [
      'Statut de la femme en islam',
      'Droits/ devoirs de la femme',
      'Femme du Prophète',
      'Éducation des enfants',
      'Allaitement',
      'Menstrues',
      'Lochies',
      'La femme et l\'héritage',
      'Comportement et pudeur',
      'L\'habillement',
    ],
    'Voyage': [
      'Voyage licite/ illicite',
      'Voyage pour la science',
      'Voyage pour Omra/ Hajj',
      'Prière du voyageur',
      'Voyage sans mahram (femme)',
      'Comportement du voyageur',
    ],
    'Signes': [
      'Dajjal',
      'Yajuj et Majuj',
      'La bête',
      'Le soleil se lève de l\'Ouest',
      'Les hautes constructions',
      'Le désert devient vert',
      'Retour de Issa',
      'Signes majeurs',
      'Signes mineurs',
    ],
    'Adkars': [
      'Invocation prophétique authentique',
      'Invocation du matin',
      'Invocation du soir',
      'En rentrant au toilette',
      'En s\'habillant',
      'Invocation du voyageur',
      'Avant de manger ou boire',
      'Après avoir finis de manger ou boire',
      'En sortant de chez sois',
      'En enfourchant sa monture',
      'En rentrant à la mosquée',
      'En sortant de la mosquée',
      'Avant de s\'asseoir',
      'Avant de se lever d\'une assise',
      'En ce levant',
      'Avant un rapport',
      'Endettement',
      'Bon comportement dans l\'invocation',
    ],
    'Mariage': [
      'Le tuteur',
      'Devoir du mari envers l\'épouse',
      'Devoir de l\'épouse envers le mari',
      'Droit conjugal',
      'Pilier du contrat de mariage',
      'Condition du mariage',
      'Choix de l\'époux(se)',
      'Le mahr (dot)',
      'Mariage forcé',
      'Mariage temporaire',
      'Mariage secret',
      'Mariage à distance',
      'Polygamie',
      'Résolution des conflits conjugaux',
      'Divorce',
      'Les mariages du Prophète et ses enseignements',
    ],
    '2 fêtes': [
      'Aïd Al adha',
      'Aïd Al Fitr',
    ],
    'Jours importants': [
      'Vendredi',
      '3arafat',
      '3achoura',
    ],
    'Hijra': [
      'Hijra du Prophète',
      'Hijra obligatoire',
      'Hijra recommandée',
    ],
    'Djihad': [
      'Jihad contre an nafs (âme)',
      'Jihad contre ash shaytan (diable)',
      'Jihad contre les mécréants et hypocrites',
      'Jihad talab (offensif)',
      'Jihad difa\' (défensif)',
    ],
    'Gouverneurs musulmans': [
      'L\'obéissance au gouverneur',
      'Les 4 califes bien guidés',
      'Attitude islamique face aux gouverneurs oppresseurs',
      'Le serment d\'allégeance (al-bay\'ah)',
      'L\'ordre et la sécurité dans la shari\'ah',
      'Jugement sur la critique publique des gouvernements',
      'Les dirigeants dans le Coran et la Sunna',
    ],
    'Transactions': [
      'Définition des transactions islamiques',
      'Conditions de validité d\'un contrat (ʿaqd)',
      'Riba (usure)',
      'Bayʿ (vente licite)',
      'Gharar (incertitude excessive)',
      'Types de contrats commerciaux',
      'Le prêt (qarḍ)',
      'Vente à crédit',
      'Usure dans les banques',
      'Investissement licite',
      'Zakat sur biens commerciaux',
      'Commerce halal et haram',
      'Assurance (taʾmīn)',
      'Dettes et remboursement',
      'Éthique du commerçant musulman',
      'Mensonge en affaire',
      'Tromperie et tricherie (ghish)',
      'Monopole et spéculation',
      'Salaire et rémunération licites',
      'Louage et location (ijārah)',
      'Contrats modernes (leasing)',
      'Transactions avec non-musulmans',
      'Interdits du marché',
      'Droits du client et vendeur',
    ],
  };

  print('🎯 STATISTIQUES GLOBALES:');
  print('   📁 Nombre total de thèmes: ${themeSubcategories.keys.length}');
  
  int totalSubcategories = 0;
  for (final subcats in themeSubcategories.values) {
    totalSubcategories += subcats.length;
  }
  print('   📂 Nombre total de sous-catégories: $totalSubcategories');
  
  print('\n' + '='*60);
  print('📋 DÉTAIL PAR THÈME:');
  print('='*60);
  
  final themes = themeSubcategories.keys.toList()..sort();
  
  for (int i = 0; i < themes.length; i++) {
    final theme = themes[i];
    final subcats = themeSubcategories[theme]!;
    
    print('\n${i + 1}. 📖 $theme (${subcats.length} sous-catégories)');
    for (int j = 0; j < subcats.length; j++) {
      print('   ${j + 1}. ${subcats[j]}');
    }
  }
  
  print('\n' + '='*60);
  print('🏆 TOP 5 DES THÈMES AVEC LE PLUS DE SOUS-CATÉGORIES:');
  print('='*60);
  
  final sortedByCount = themes.map((theme) => {
    'theme': theme,
    'count': themeSubcategories[theme]!.length
  }).toList()..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
  
  for (int i = 0; i < 5 && i < sortedByCount.length; i++) {
    final item = sortedByCount[i];
    print('${i + 1}. ${item['theme']}: ${item['count']} sous-catégories');
  }
  
  print('\n📊 DISTRIBUTION PAR TAILLE:');
  Map<String, int> distribution = {};
  for (final subcats in themeSubcategories.values) {
    String range;
    if (subcats.length <= 5) range = '1-5 sous-catégories';
    else if (subcats.length <= 10) range = '6-10 sous-catégories';
    else if (subcats.length <= 15) range = '11-15 sous-catégories';
    else range = '16+ sous-catégories';
    
    distribution[range] = (distribution[range] ?? 0) + 1;
  }
  
  distribution.forEach((range, count) {
    print('   $range: $count thèmes');
  });
  
  print('\n✅ CONCLUSION:');
  print('Tous les ${themeSubcategories.keys.length} thèmes ont bien leurs sous-catégories définies !' );
  print('Le système peut être étendu à tous les thèmes facilement.');
}