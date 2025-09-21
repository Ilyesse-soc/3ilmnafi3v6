const express = require('express');
const router = express.Router();

// Données complètes des sous-catégories par thème (basé sur lib/constants/theme_subcategories.dart)
const subcategoriesData = {
  1: [ // Tawhid
    { id: 1, name: "L'intention", themeId: 1 },
    { id: 2, name: "Définition du tawhid", themeId: 1 },
    { id: 3, name: "Tawhid de l'adoration", themeId: 1 },
    { id: 4, name: "Tawhid de la seigneurie", themeId: 1 },
    { id: 5, name: "Tawhid des noms et attributs", themeId: 1 },
    { id: 6, name: "Le shirk majeur", themeId: 1 },
    { id: 7, name: "Le shirk mineur", themeId: 1 },
    { id: 8, name: "Le shirk caché", themeId: 1 },
    { id: 9, name: "L'aveux et le désaveu", themeId: 1 },
    { id: 10, name: "Tawhid dans le coran", themeId: 1 },
    { id: 11, name: "Tawhid dans la Sunna", themeId: 1 }
  ],
  2: [ // Prière
    { id: 12, name: "Les ablutions", themeId: 2 },
    { id: 13, name: "Le ghusl (lavage)", themeId: 2 },
    { id: 14, name: "Le Tayammum", themeId: 2 },
    { id: 15, name: "Les règles", themeId: 2 },
    { id: 16, name: "Istikhara (demande)", themeId: 2 },
    { id: 17, name: "Istisqa (pluie)", themeId: 2 },
    { id: 18, name: "Vendredi", themeId: 2 },
    { id: 19, name: "Les 5 prières obligatoires", themeId: 2 },
    { id: 20, name: "Les 12 rawatib", themeId: 2 },
    { id: 21, name: "Mortuaire", themeId: 2 },
    { id: 22, name: "Prière de nuit", themeId: 2 },
    { id: 23, name: "Salat Doha (jour montant)", themeId: 2 },
    { id: 24, name: "Salat al koussouf (éclipse)", themeId: 2 },
    { id: 25, name: "Prière du voyageur", themeId: 2 }
  ],
  3: [ // Ramadan
    { id: 26, name: "Les 10 dernières nuits", themeId: 3 },
    { id: 27, name: "Nuit du destin", themeId: 3 },
    { id: 28, name: "Le jeûne", themeId: 3 },
    { id: 29, name: "Le Sahur", themeId: 3 },
    { id: 30, name: "La coupure du jeûne", themeId: 3 },
    { id: 31, name: "Prière de nuit pendant le ramadan", themeId: 3 }
  ],
  4: [ // Zakat
    { id: 32, name: "Al-Fitr (nourriture)", themeId: 4 },
    { id: 33, name: "Al-mal (argent)", themeId: 4 },
    { id: 34, name: "Différence entre zakat et sadaqah", themeId: 4 },
    { id: 35, name: "Erreurs courantes dans les zakat", themeId: 4 },
    { id: 36, name: "Nissab (seuil minimum)", themeId: 4 }
  ],
  5: [ // Hajj
    { id: 37, name: "Le grand pèlerinage (Hajj)", themeId: 5 },
    { id: 38, name: "Le petit pèlerinage (Omra)", themeId: 5 },
    { id: 39, name: "Condition d'obligation du Hajj", themeId: 5 },
    { id: 40, name: "Les piliers du Hajj", themeId: 5 },
    { id: 41, name: "Les obligations du Hajj", themeId: 5 },
    { id: 42, name: "Le jour de 3arafa", themeId: 5 },
    { id: 43, name: "Hajj de la Femme", themeId: 5 },
    { id: 44, name: "Récompense et mérite du hajj", themeId: 5 },
    { id: 45, name: "Les 10 premiers jours de Dhoul Hijja", themeId: 5 }
  ],
  6: [ // Le Coran
    { id: 46, name: "Récitation", themeId: 6 },
    { id: 47, name: "Tafsir (Exégèse)", themeId: 6 },
    { id: 48, name: "7 ahruf (mode de récitation)", themeId: 6 },
    { id: 49, name: "10 qira'at (lectures authentique)", themeId: 6 },
    { id: 50, name: "Les causes de révélation", themeId: 6 },
    { id: 51, name: "Ruqyah, le Coran et la guérison", themeId: 6 },
    { id: 52, name: "Mérite de la lecture du Coran", themeId: 6 },
    { id: 53, name: "Miracle linguistiques et scientifique du Coran", themeId: 6 }
  ],
  7: [ // La Sunna
    { id: 54, name: "Hadith Qudsi", themeId: 7 },
    { id: 55, name: "Hadith Moutawatir", themeId: 7 },
    { id: 56, name: "Al Mouwatta (Imam Malik)", themeId: 7 },
    { id: 57, name: "Musnad Ahmad ibn hanbal", themeId: 7 },
    { id: 58, name: "Sunan Darimi", themeId: 7 },
    { id: 59, name: "Sahih Al Boukhary", themeId: 7 },
    { id: 60, name: "Sahih Muslim", themeId: 7 },
    { id: 61, name: "Sunan Abu Dawud", themeId: 7 },
    { id: 62, name: "Sunan Tirmidhi", themeId: 7 },
    { id: 63, name: "Sunan As sughra (Nasa'i)", themeId: 7 },
    { id: 64, name: "Sunan Ibn Maja", themeId: 7 }
  ],
  8: [ // Prophètes
    { id: 65, name: "Messagers", themeId: 8 },
    { id: 66, name: "Prophètes", themeId: 8 },
    { id: 67, name: "Messager Mohammed", themeId: 8 },
    { id: 68, name: "Messager Nouh", themeId: 8 },
    { id: 69, name: "Messager Ibrahim", themeId: 8 },
    { id: 70, name: "Messager Moussa", themeId: 8 },
    { id: 71, name: "Messager Issa", themeId: 8 },
    { id: 72, name: "Différence entre Prophète et Messager", themeId: 8 }
  ],
  9: [ // 73 Sectes
    { id: 73, name: "Al Ikhwan", themeId: 9 },
    { id: 74, name: "Khawarij", themeId: 9 },
    { id: 75, name: "Al rafidah/ Chiite", themeId: 9 },
    { id: 76, name: "Mu'tazila", themeId: 9 },
    { id: 77, name: "Al jahmiyya", themeId: 9 },
    { id: 78, name: "Al murjia", themeId: 9 },
    { id: 79, name: "Ash'a3ira", themeId: 9 },
    { id: 80, name: "Al Qadariyya", themeId: 9 },
    { id: 81, name: "As soufiya", themeId: 9 },
    { id: 82, name: "Al isma'ilia Batiniya", themeId: 9 },
    { id: 83, name: "Al qur'aniyyun", themeId: 9 }
  ],
  10: [ // Compagnons
    { id: 84, name: "Définition de sahabi", themeId: 10 },
    { id: 85, name: "Les 10 promis au paradis", themeId: 10 },
    { id: 86, name: "Abu Bakr", themeId: 10 },
    { id: 87, name: "Omar Ibn Al khattab", themeId: 10 },
    { id: 88, name: "Othman Ibn Affan", themeId: 10 },
    { id: 89, name: "Ali Ibn Abu Talib", themeId: 10 },
    { id: 90, name: "Vertus des compagnons", themeId: 10 },
    { id: 91, name: "Les femmes parmi les compagnons", themeId: 10 }
  ],
  11: [ // Les innovations
    { id: 92, name: "Définition de l'innovation", themeId: 11 },
    { id: 93, name: "Innovations en croyance", themeId: 11 },
    { id: 94, name: "Innovation en adoration", themeId: 11 },
    { id: 95, name: "Danger de l'innovation", themeId: 11 },
    { id: 96, name: "Bonne innovation ?", themeId: 11 },
    { id: 97, name: "Fêtes innové", themeId: 11 },
    { id: 98, name: "Réfuter les innovateurs", themeId: 11 }
  ],
  12: [ // Les Savants
    { id: 99, name: "Statut du savant en Islam", themeId: 12 },
    { id: 100, name: "Savants de la sunnah", themeId: 12 },
    { id: 101, name: "Les grands savants dans l'Islam", themeId: 12 }
  ],
  13: [ // La mort
    { id: 102, name: "Signe de la bonne/ mauvaise fin", themeId: 13 },
    { id: 103, name: "Ce qui profite au mort", themeId: 13 },
    { id: 104, name: "Lavage du mort", themeId: 13 },
    { id: 105, name: "Ce qu'on dit à une personne mourante", themeId: 13 },
    { id: 106, name: "Deuil et condoléances", themeId: 13 },
    { id: 107, name: "Rites interdits", themeId: 13 }
  ],
  14: [ // La tombe
    { id: 108, name: "Al barzakh", themeId: 14 },
    { id: 109, name: "L'enterrement", themeId: 14 },
    { id: 110, name: "Visite des tombes (homme)", themeId: 14 },
    { id: 111, name: "Invocation pour les morts", themeId: 14 },
    { id: 112, name: "Châtiment de la tombe", themeId: 14 },
    { id: 113, name: "Questions des Anges", themeId: 14 },
    { id: 114, name: "Les interdictions autour des tombes", themeId: 14 }
  ],
  15: [ // Le jour dernier
    { id: 115, name: "Le rassemblement", themeId: 15 },
    { id: 116, name: "La balance", themeId: 15 },
    { id: 117, name: "La résurrection", themeId: 15 },
    { id: 118, name: "Le paradis et l'enfer", themeId: 15 },
    { id: 119, name: "L'intercession", themeId: 15 },
    { id: 120, name: "Le sirat (pont)", themeId: 15 }
  ],
  16: [ // Les 4 Imams
    { id: 121, name: "Abou Hanifa", themeId: 16 },
    { id: 122, name: "Malik ibn Anas", themeId: 16 },
    { id: 123, name: "Ach chafi3i", themeId: 16 },
    { id: 124, name: "Ahmed ibn Hanbal", themeId: 16 }
  ],
  17: [ // Les Anges
    { id: 125, name: "Création des anges", themeId: 17 },
    { id: 126, name: "Jibril", themeId: 17 },
    { id: 127, name: "Malik", themeId: 17 },
    { id: 128, name: "Mounkar wa Nakir", themeId: 17 },
    { id: 129, name: "Ange de la mort", themeId: 17 },
    { id: 130, name: "Ange scribes", themeId: 17 },
    { id: 131, name: "Les anges dans les assemblées de dhikr", themeId: 17 },
    { id: 132, name: "Les anges le jour du jugement", themeId: 17 },
    { id: 133, name: "Les anges et le nouveau né", themeId: 17 },
    { id: 134, name: "Amour pour les anges", themeId: 17 }
  ],
  18: [ // Les Djinns
    { id: 135, name: "Création des Djinns", themeId: 18 },
    { id: 136, name: "Type de Djinns", themeId: 18 },
    { id: 137, name: "Possession", themeId: 18 },
    { id: 138, name: "Protection contre les Djinns", themeId: 18 },
    { id: 139, name: "Ruqya", themeId: 18 },
    { id: 140, name: "Sorcellerie", themeId: 18 }
  ],
  19: [ // Les gens du livre
    { id: 141, name: "Torah (Moussa)", themeId: 19 },
    { id: 142, name: "Évangile (Issa)", themeId: 19 },
    { id: 143, name: "Psaume de Dawud", themeId: 19 },
    { id: 144, name: "Feuillets d'Ibrahim", themeId: 19 },
    { id: 145, name: "Mariage avec une femme des gens du livre", themeId: 19 },
    { id: 146, name: "Nourriture des gens du livre", themeId: 19 },
    { id: 147, name: "Conversion des gens du livre à l'islam", themeId: 19 },
    { id: 148, name: "Relation et comportement avec les gens du livre", themeId: 19 }
  ],
  20: [ // 99 Noms
    { id: 149, name: "Mérite de les apprendre", themeId: 20 },
    { id: 150, name: "Noms liés à la puissance", themeId: 20 },
    { id: 151, name: "Noms liés à la miséricorde", themeId: 20 },
    { id: 152, name: "Noms liés à la connaissance", themeId: 20 },
    { id: 153, name: "Définition des noms parfaits", themeId: 20 }
  ],
  21: [ // Femmes
    { id: 154, name: "Statut de la femme en islam", themeId: 21 },
    { id: 155, name: "Droits/ devoirs de la femme", themeId: 21 },
    { id: 156, name: "Femme du Prophète", themeId: 21 },
    { id: 157, name: "Éducation des enfants", themeId: 21 },
    { id: 158, name: "Allaitement", themeId: 21 },
    { id: 159, name: "Menstrues", themeId: 21 },
    { id: 160, name: "Lochies", themeId: 21 },
    { id: 161, name: "La femme et l'héritage", themeId: 21 },
    { id: 162, name: "Comportement et pudeur", themeId: 21 },
    { id: 163, name: "L'habillement", themeId: 21 }
  ],
  22: [ // Voyage
    { id: 164, name: "Voyage licite/ illicite", themeId: 22 },
    { id: 165, name: "Voyage pour la science", themeId: 22 },
    { id: 166, name: "Voyage pour Omra/ Hajj", themeId: 22 },
    { id: 167, name: "Prière du voyageur", themeId: 22 },
    { id: 168, name: "Voyage sans mahram (femme)", themeId: 22 },
    { id: 169, name: "Comportement du voyageur", themeId: 22 }
  ],
  23: [ // Signes
    { id: 170, name: "Dajjal", themeId: 23 },
    { id: 171, name: "Yajuj et Majuj", themeId: 23 },
    { id: 172, name: "La bête", themeId: 23 },
    { id: 173, name: "Le soleil se lève de l'Ouest", themeId: 23 },
    { id: 174, name: "Les hautes constructions", themeId: 23 },
    { id: 175, name: "Le désert devient vert", themeId: 23 },
    { id: 176, name: "Retour de Issa", themeId: 23 },
    { id: 177, name: "Signes majeurs", themeId: 23 },
    { id: 178, name: "Signes mineurs", themeId: 23 }
  ],
  24: [ // Adkars
    { id: 179, name: "Invocation prophétique authentique", themeId: 24 },
    { id: 180, name: "Invocation du matin", themeId: 24 },
    { id: 181, name: "Invocation du soir", themeId: 24 },
    { id: 182, name: "En rentrant au toilette", themeId: 24 },
    { id: 183, name: "En s'habillant", themeId: 24 },
    { id: 184, name: "Invocation du voyageur", themeId: 24 },
    { id: 185, name: "Avant de manger ou boire", themeId: 24 },
    { id: 186, name: "Après avoir finis de manger ou boire", themeId: 24 },
    { id: 187, name: "En sortant de chez sois", themeId: 24 },
    { id: 188, name: "En enfourchant sa monture", themeId: 24 },
    { id: 189, name: "En rentrant à la mosquée", themeId: 24 },
    { id: 190, name: "En sortant de la mosquée", themeId: 24 },
    { id: 191, name: "Avant de s'asseoir", themeId: 24 },
    { id: 192, name: "Avant de se lever d'une assise", themeId: 24 },
    { id: 193, name: "En ce levant", themeId: 24 },
    { id: 194, name: "Avant un rapport", themeId: 24 },
    { id: 195, name: "Endettement", themeId: 24 },
    { id: 196, name: "Bon comportement dans l'invocation", themeId: 24 }
  ],
  25: [ // Mariage
    { id: 197, name: "Le tuteur", themeId: 25 },
    { id: 198, name: "Devoir du mari envers l'épouse", themeId: 25 },
    { id: 199, name: "Devoir de l'épouse envers le mari", themeId: 25 },
    { id: 200, name: "Droit conjugal", themeId: 25 },
    { id: 201, name: "Pilier du contrat de mariage", themeId: 25 },
    { id: 202, name: "Condition du mariage", themeId: 25 },
    { id: 203, name: "Choix de l'époux(se)", themeId: 25 },
    { id: 204, name: "Le mahr (dot)", themeId: 25 },
    { id: 205, name: "Mariage forcé", themeId: 25 },
    { id: 206, name: "Mariage temporaire", themeId: 25 },
    { id: 207, name: "Mariage secret", themeId: 25 },
    { id: 208, name: "Mariage à distance", themeId: 25 },
    { id: 209, name: "Polygamie", themeId: 25 },
    { id: 210, name: "Résolution des conflits conjugaux", themeId: 25 },
    { id: 211, name: "Divorce", themeId: 25 },
    { id: 212, name: "Les mariages du Prophète et ses enseignements", themeId: 25 }
  ],
  26: [ // 2 fêtes
    { id: 213, name: "Aïd Al adha", themeId: 26 },
    { id: 214, name: "Aïd Al Fitr", themeId: 26 }
  ],
  27: [ // Jours importants
    { id: 215, name: "Vendredi", themeId: 27 },
    { id: 216, name: "3arafat", themeId: 27 },
    { id: 217, name: "3achoura", themeId: 27 }
  ],
  28: [ // Hijra
    { id: 218, name: "Hijra du Prophète", themeId: 28 },
    { id: 219, name: "Hijra obligatoire", themeId: 28 },
    { id: 220, name: "Hijra recommandée", themeId: 28 }
  ],
  29: [ // Djihad
    { id: 221, name: "Jihad contre an nafs (âme)", themeId: 29 },
    { id: 222, name: "Jihad contre ash shaytan (diable)", themeId: 29 },
    { id: 223, name: "Jihad contre les mécréants et hypocrites", themeId: 29 },
    { id: 224, name: "Jihad talab (offensif)", themeId: 29 },
    { id: 225, name: "Jihad difa' (défensif)", themeId: 29 }
  ],
  30: [ // Gouverneurs musulmans
    { id: 226, name: "L'obéissance au gouverneur", themeId: 30 },
    { id: 227, name: "Les 4 califes bien guidés", themeId: 30 },
    { id: 228, name: "Attitude islamique face aux gouverneurs oppresseurs", themeId: 30 },
    { id: 229, name: "Le serment d'allégeance (al-bay'ah)", themeId: 30 },
    { id: 230, name: "L'ordre et la sécurité dans la shari'ah", themeId: 30 },
    { id: 231, name: "Jugement sur la critique publique des gouvernements", themeId: 30 },
    { id: 232, name: "Les dirigeants dans le Coran et la Sunna", themeId: 30 }
  ],
  31: [ // Transactions
    { id: 233, name: "Définition des transactions islamiques", themeId: 31 },
    { id: 234, name: "Conditions de validité d'un contrat (ʿaqd)", themeId: 31 },
    { id: 235, name: "Riba (usure)", themeId: 31 },
    { id: 236, name: "Bayʿ (vente licite)", themeId: 31 },
    { id: 237, name: "Gharar (incertitude excessive)", themeId: 31 },
    { id: 238, name: "Types de contrats commerciaux", themeId: 31 },
    { id: 239, name: "Le prêt (qarḍ)", themeId: 31 },
    { id: 240, name: "Vente à crédit", themeId: 31 },
    { id: 241, name: "Usure dans les banques", themeId: 31 },
    { id: 242, name: "Investissement licite", themeId: 31 },
    { id: 243, name: "Zakat sur biens commerciaux", themeId: 31 },
    { id: 244, name: "Commerce halal et haram", themeId: 31 },
    { id: 245, name: "Assurance (taʾmīn)", themeId: 31 },
    { id: 246, name: "Dettes et remboursement", themeId: 31 },
    { id: 247, name: "Éthique du commerçant musulman", themeId: 31 },
    { id: 248, name: "Mensonge en affaire", themeId: 31 },
    { id: 249, name: "Tromperie et tricherie (ghish)", themeId: 31 },
    { id: 250, name: "Monopole et spéculation", themeId: 31 },
    { id: 251, name: "Salaire et rémunération licites", themeId: 31 },
    { id: 252, name: "Louage et location (ijārah)", themeId: 31 },
    { id: 253, name: "Contrats modernes (leasing)", themeId: 31 },
    { id: 254, name: "Transactions avec non-musulmans", themeId: 31 },
    { id: 255, name: "Interdits du marché", themeId: 31 },
    { id: 256, name: "Droits du client et vendeur", themeId: 31 }
  ]
};

// Route de test simple FIRST
router.get('/test', (req, res) => {
  console.log('GET /test called - Route working!');
  res.json({ message: "Route de test fonctionne!", timestamp: new Date() });
});

// GET all subcategories
router.get('/subcategories', async (req, res) => {
  try {
    console.log('GET /subcategories called');
    
    // Flatten all subcategories
    const allSubcategories = Object.values(subcategoriesData).flat();
    
    res.json({
      success: true,
      data: allSubcategories,
      total: allSubcategories.length
    });
  } catch (error) {
    console.error('Error fetching subcategories:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des sous-catégories',
      error: error.message
    });
  }
});

// GET subcategories by theme ID
router.get('/subcategories/theme/:themeId', async (req, res) => {
  try {
    const themeId = parseInt(req.params.themeId);
    console.log(`GET /subcategories/theme/${themeId} called`);
    
    const subcategories = subcategoriesData[themeId] || [];
    
    res.json({
      success: true,
      data: subcategories,
      themeId: themeId,
      total: subcategories.length
    });
  } catch (error) {
    console.error('Error fetching subcategories by theme:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des sous-catégories par thème',
      error: error.message
    });
  }
});

// POST create new subcategory (pour admin plus tard)
router.post('/subcategories', async (req, res) => {
  try {
    const { name, themeId } = req.body;
    
    if (!name || !themeId) {
      return res.status(400).json({
        success: false,
        message: 'Le nom et le themeId sont requis'
      });
    }
    
    // Pour l'instant, juste retourner un succès
    res.json({
      success: true,
      message: 'Sous-catégorie créée (fonctionnalité en développement)',
      data: { name, themeId }
    });
  } catch (error) {
    console.error('Error creating subcategory:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de la sous-catégorie',
      error: error.message
    });
  }
});

module.exports = router;