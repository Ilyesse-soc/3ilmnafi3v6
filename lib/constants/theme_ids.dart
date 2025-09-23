// lib/constants/theme_ids.dart

/// Mapping des noms de thèmes vers leurs IDs API correspondants
/// IDs récupérés depuis l'API le 27/01/2025
final Map<String, String> themeIds = {
  // Thèmes avec IDs vérifiés depuis l'API
  'Tawhid': '92a89d9e-ebf2-4ed3-9ce4-03d06f7a6690',
  'Prière': '33b5b607-10f7-4b40-a1ad-8becbcfa7983',
  'Ramadan': '3ae58ae9-1178-48eb-b243-0a6a80b152fc',
  'Zakat': '6265bc0c-da24-485a-ba44-624e993fe142',
  'Hajj': 'f63b2ecf-e196-4057-b357-45f33461a838',
  'Le Coran': '8a50dbd8-8923-4e34-ac02-e7d720dad88d',
  'La Sunna': '352f15b9-c261-4a3c-99ce-e1c5cbfa0124',
  'Prophètes': '46c17b28-18fa-4e4b-9ff1-0ce9dbdfab8a',
  '73 Sectes': '2e2c05ea-78bd-408d-a4b7-4211706c2a7b',
  'Compagnons': '59bd80d8-6062-4b9a-87d8-aa5b3c35c132',
  'Les Savants': 'f112e63a-6a48-4c5f-ad65-c7104173323c',
  'Les innovations': 'bb190f80-c716-4d5e-8536-ab47cf4c1631',
  'La mort': 'cf875d8b-6f5e-4997-bcf2-fc607c093016',
  'La tombe': '5ca65b2a-eef1-44f5-a5a0-80a27ec9f1e9',
  'Le jour dernier': 'bce54aa7-6d2e-42f3-8060-4981361ae608',
  'Les 4 Imams': 'd66f7970-5705-4d24-bd9a-416b8bb87da2',
  'Les Anges': '335366ac-0609-437b-8406-4c7a23fdd5b6',
  'Les Djinns': 'b1e66682-3d08-4f97-91a2-93653d6cd30f',
  'Les gens du livre': '155a63ac-fc32-42f8-8279-de65c64aede0',
  '99 Noms': '9cb2ef65-2872-4a6f-9ca6-216b4b353066',
  'Femmes': '470d3f3d-648f-4e1d-975a-3c95a05324bd',
  'Voyage': 'f0ae858f-0957-4795-939b-138503bb2d64',
  'Signes': '932e21e2-19ee-47b8-98c2-4b0f65723dfd',
  'Adkars': '54187de6-a52c-4209-843a-efcdca5ee780',

  // Note: Ces thèmes étaient dans theme_subcategories.dart mais pas dans l'API
  // Ils peuvent être ajoutés plus tard si nécessaire
  // 'Mariage': 'À définir',
  // '2 fêtes': 'À définir',
  // 'Jours importants': 'À définir',
  // 'Hijra': 'À définir',
  // 'Djihad': 'À définir',
  // 'Gouverneurs musulmans': 'À définir',
  // 'Transactions': 'À définir',
};

/// Fonction utilitaire pour récupérer l'ID d'un thème
String? getThemeId(String themeName) {
  return themeIds[themeName];
}

/// Vérifie si un thème a un ID défini
bool hasThemeId(String themeName) {
  final id = themeIds[themeName];
  return id != null && !id.contains('_THEME_ID_HERE');
}