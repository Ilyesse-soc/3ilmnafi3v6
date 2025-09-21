


CREATE TABLE IF NOT EXISTS subcategories (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  theme_id VARCHAR(36) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS video_subcategories (
  video_id VARCHAR(36) NOT NULL,
  subcategory_id VARCHAR(36) NOT NULL,
  PRIMARY KEY (video_id, subcategory_id)
);



-- TAWHID
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'L\'intention', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Définition du tawhid', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Tawhid de l\'adoration', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Tawhid de la seigneurie', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Tawhid des noms et attributs', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Le shirk majeur', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Le shirk mineur', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Le shirk caché', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'L\'aveux et le désaveu', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Tawhid dans le coran', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1)),
(UUID(), 'Tawhid dans la Sunna', (SELECT id FROM themes WHERE name = 'Tawhid' LIMIT 1));

-- PRIÈRE
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Les ablutions', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Le ghusl (lavage)', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Le Tayammum', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Les règles', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Istikhara (demande)', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Istisqa (pluie)', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Vendredi', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Les 5 prières obligatoires', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Les 12 rawatib', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Mortuaire', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Prière de nuit', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Salat Doha (jour montant)', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Salat al koussouf (éclipse)', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1)),
(UUID(), 'Prière du voyageur', (SELECT id FROM themes WHERE name = 'Prière' LIMIT 1));

-- RAMADAN
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Les 10 dernières nuits', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1)),
(UUID(), 'Nuit du destin', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1)),
(UUID(), 'Le jeûne', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1)),
(UUID(), 'Le Sahur', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1)),
(UUID(), 'La coupure du jeûne', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1)),
(UUID(), 'Prière de nuit pendant le ramadan', (SELECT id FROM themes WHERE name = 'Ramadan' LIMIT 1));

-- ZAKAT
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Al-Fitr (nourriture)', (SELECT id FROM themes WHERE name = 'Zakat' LIMIT 1)),
(UUID(), 'Al-mal (argent)', (SELECT id FROM themes WHERE name = 'Zakat' LIMIT 1)),
(UUID(), 'Différence entre zakat et sadaqah', (SELECT id FROM themes WHERE name = 'Zakat' LIMIT 1)),
(UUID(), 'Erreurs courantes dans les zakat', (SELECT id FROM themes WHERE name = 'Zakat' LIMIT 1)),
(UUID(), 'Nissab (seuil minimum)', (SELECT id FROM themes WHERE name = 'Zakat' LIMIT 1));

-- HAJJ
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Le grand pèlerinage (Hajj)', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Le petit pèlerinage (Omra)', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Condition d\'obligation du Hajj', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Les piliers du Hajj', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Les obligations du Hajj', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Le jour de 3arafa', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Hajj de la Femme', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Récompense et mérite du hajj', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1)),
(UUID(), 'Les 10 premiers jours de Dhoul Hijja', (SELECT id FROM themes WHERE name = 'Hajj' LIMIT 1));

-- LE CORAN
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Récitation', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), 'Tafsir (Exégèse)', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), '7 ahruf (mode de récitation)', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), '10 qira\'at (lectures authentique)', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), 'Les causes de révélation', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), 'Ruqyah, le Coran et la guérison', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), 'Mérite de la lecture du Coran', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1)),
(UUID(), 'Miracle linguistiques et scientifique du Coran', (SELECT id FROM themes WHERE name = 'Le Coran' LIMIT 1));

-- LA SUNNA
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Hadith Qudsi', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Hadith Moutawatir', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Al Mouwatta (Imam Malik)', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Musnad Ahmad ibn hanbal', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sunan Darimi', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sahih Al Boukhary', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sahih Muslim', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sunan Abu Dawud', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sunan Tirmidhi', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sunan As sughra (Nasa\'i)', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1)),
(UUID(), 'Sunan Ibn Maja', (SELECT id FROM themes WHERE name = 'La Sunna' LIMIT 1));

-- PROPHÈTES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Messagers', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Prophètes', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Messager Mohammed', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Messager Nouh', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Messager Ibrahim', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Messager Moussa', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Messager Issa', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1)),
(UUID(), 'Différence entre Prophète et Messager', (SELECT id FROM themes WHERE name = 'Prophètes' LIMIT 1));

-- 73 SECTES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Al Ikhwan', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Khawarij', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al rafidah/ Chiite', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Mu\'tazila', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al jahmiyya', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al murjia', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Ash\'a3ira', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al Qadariyya', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'As soufiya', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al isma\'ilia Batiniya', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1)),
(UUID(), 'Al qur\'aniyyun', (SELECT id FROM themes WHERE name = '73 Sectes' LIMIT 1));

-- COMPAGNONS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Définition de sahabi', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Les 10 promis au paradis', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Abu Bakr', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Omar Ibn Al khattab', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Othman Ibn Affan', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Ali Ibn Abu Talib', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Vertus des compagnons', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1)),
(UUID(), 'Les femmes parmi les compagnons', (SELECT id FROM themes WHERE name = 'Compagnons' LIMIT 1));

-- LES INNOVATIONS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Définition de l\'innovation', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Innovations en croyance', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Innovation en adoration', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Danger de l\'innovation', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Bonne innovation ?', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Fêtes innové', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1)),
(UUID(), 'Réfuter les innovateurs', (SELECT id FROM themes WHERE name = 'Les innovations' LIMIT 1));

-- LES SAVANTS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Statut du savant en Islam', (SELECT id FROM themes WHERE name = 'Les Savants' LIMIT 1)),
(UUID(), 'Savants de la sunnah', (SELECT id FROM themes WHERE name = 'Les Savants' LIMIT 1)),
(UUID(), 'Les grands savants dans l\'Islam', (SELECT id FROM themes WHERE name = 'Les Savants' LIMIT 1));

-- LA MORT
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Signe de la bonne/ mauvaise fin', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1)),
(UUID(), 'Ce qui profite au mort', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1)),
(UUID(), 'Lavage du mort', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1)),
(UUID(), 'Ce qu\'on dit à une personne mourante', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1)),
(UUID(), 'Deuil et condoléances', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1)),
(UUID(), 'Rites interdits', (SELECT id FROM themes WHERE name = 'La mort' LIMIT 1));

-- LA TOMBE
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Al barzakh', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'L\'enterrement', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'Visite des tombes (homme)', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'Invocation pour les morts', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'Châtiment de la tombe', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'Questions des Anges', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1)),
(UUID(), 'Les interdictions autour des tombes', (SELECT id FROM themes WHERE name = 'La tombe' LIMIT 1));

-- LE JOUR DERNIER
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Le rassemblement', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1)),
(UUID(), 'La balance', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1)),
(UUID(), 'La résurrection', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1)),
(UUID(), 'Le paradis et l\'enfer', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1)),
(UUID(), 'L\'intercession', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1)),
(UUID(), 'Le sirat (pont)', (SELECT id FROM themes WHERE name = 'Le jour dernier' LIMIT 1));

-- LES 4 IMAMS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Abou Hanifa', (SELECT id FROM themes WHERE name = 'Les 4 Imams' LIMIT 1)),
(UUID(), 'Malik ibn Anas', (SELECT id FROM themes WHERE name = 'Les 4 Imams' LIMIT 1)),
(UUID(), 'Ach chafi3i', (SELECT id FROM themes WHERE name = 'Les 4 Imams' LIMIT 1)),
(UUID(), 'Ahmed ibn Hanbal', (SELECT id FROM themes WHERE name = 'Les 4 Imams' LIMIT 1));

-- LES ANGES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Création des anges', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Jibril', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Malik', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Mounkar wa Nakir', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Ange de la mort', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Ange scribes', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Les anges dans les assemblées de dhikr', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Les anges le jour du jugement', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Les anges et le nouveau né', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1)),
(UUID(), 'Amour pour les anges', (SELECT id FROM themes WHERE name = 'Les Anges' LIMIT 1));

-- LES DJINNS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Création des Djinns', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1)),
(UUID(), 'Type de Djinns', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1)),
(UUID(), 'Possession', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1)),
(UUID(), 'Protection contre les Djinns', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1)),
(UUID(), 'Ruqya', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1)),
(UUID(), 'Sorcellerie', (SELECT id FROM themes WHERE name = 'Les Djinns' LIMIT 1));

-- LES GENS DU LIVRE
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Torah (Moussa)', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Évangile (Issa)', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Psaume de Dawud', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Feuillets d\'Ibrahim', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Mariage avec une femme des gens du livre', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Nourriture des gens du livre', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Conversion des gens du livre à l\'islam', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1)),
(UUID(), 'Relation et comportement avec les gens du livre', (SELECT id FROM themes WHERE name = 'Les gens du livre' LIMIT 1));

-- 99 NOMS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Mérite de les apprendre', (SELECT id FROM themes WHERE name = '99 Noms' LIMIT 1)),
(UUID(), 'Noms liés à la puissance', (SELECT id FROM themes WHERE name = '99 Noms' LIMIT 1)),
(UUID(), 'Noms liés à la miséricorde', (SELECT id FROM themes WHERE name = '99 Noms' LIMIT 1)),
(UUID(), 'Noms liés à la connaissance', (SELECT id FROM themes WHERE name = '99 Noms' LIMIT 1)),
(UUID(), 'Définition des noms parfaits', (SELECT id FROM themes WHERE name = '99 Noms' LIMIT 1));

-- FEMMES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Statut de la femme en islam', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Droits/ devoirs de la femme', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Femme du Prophète', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Éducation des enfants', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Allaitement', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Menstrues', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Lochies', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'La femme et l\'héritage', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'Comportement et pudeur', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1)),
(UUID(), 'L\'habillement', (SELECT id FROM themes WHERE name = 'Femmes' LIMIT 1));

-- VOYAGE
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Voyage licite/ illicite', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1)),
(UUID(), 'Voyage pour la science', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1)),
(UUID(), 'Voyage pour Omra/ Hajj', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1)),
(UUID(), 'Prière du voyageur', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1)),
(UUID(), 'Voyage sans mahram (femme)', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1)),
(UUID(), 'Comportement du voyageur', (SELECT id FROM themes WHERE name = 'Voyage' LIMIT 1));

-- SIGNES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Dajjal', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Yajuj et Majuj', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'La bête', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Le soleil se lève de l\'Ouest', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Les hautes constructions', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Le désert devient vert', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Retour de Issa', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Signes majeurs', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1)),
(UUID(), 'Signes mineurs', (SELECT id FROM themes WHERE name = 'Signes' LIMIT 1));

-- ADKARS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Invocation prophétique authentique', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Invocation du matin', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Invocation du soir', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En rentrant au toilette', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En s\'habillant', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Invocation du voyageur', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Avant de manger ou boire', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Après avoir finis de manger ou boire', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En sortant de chez sois', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En enfourchant sa monture', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En rentrant à la mosquée', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En sortant de la mosquée', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Avant de s\'asseoir', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Avant de se lever d\'une assise', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'En ce levant', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Avant un rapport', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Endettement', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1)),
(UUID(), 'Bon comportement dans l\'invocation', (SELECT id FROM themes WHERE name = 'Adkars' LIMIT 1));

-- MARIAGE
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Le tuteur', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Devoir du mari envers l\'épouse', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Devoir de l\'épouse envers le mari', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Droit conjugal', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Pilier du contrat de mariage', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Condition du mariage', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Choix de l\'époux(se)', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Le mahr (dot)', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Mariage forcé', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Mariage temporaire', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Mariage secret', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Mariage à distance', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Polygamie', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Résolution des conflits conjugaux', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Divorce', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1)),
(UUID(), 'Les mariages du Prophète et ses enseignements', (SELECT id FROM themes WHERE name = 'Mariage' LIMIT 1));

-- 2 FÊTES
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Aïd Al adha', (SELECT id FROM themes WHERE name = '2 fêtes' LIMIT 1)),
(UUID(), 'Aïd Al Fitr', (SELECT id FROM themes WHERE name = '2 fêtes' LIMIT 1));

-- JOURS IMPORTANTS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Vendredi', (SELECT id FROM themes WHERE name = 'Jours importants' LIMIT 1)),
(UUID(), '3arafat', (SELECT id FROM themes WHERE name = 'Jours importants' LIMIT 1)),
(UUID(), '3achoura', (SELECT id FROM themes WHERE name = 'Jours importants' LIMIT 1));

-- HIJRA
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Hijra du Prophète', (SELECT id FROM themes WHERE name = 'Hijra' LIMIT 1)),
(UUID(), 'Hijra obligatoire', (SELECT id FROM themes WHERE name = 'Hijra' LIMIT 1)),
(UUID(), 'Hijra recommandée', (SELECT id FROM themes WHERE name = 'Hijra' LIMIT 1));

-- DJIHAD
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Jihad contre an nafs (âme)', (SELECT id FROM themes WHERE name = 'Djihad' LIMIT 1)),
(UUID(), 'Jihad contre ash shaytan (diable)', (SELECT id FROM themes WHERE name = 'Djihad' LIMIT 1)),
(UUID(), 'Jihad contre les mécréants et hypocrites', (SELECT id FROM themes WHERE name = 'Djihad' LIMIT 1)),
(UUID(), 'Jihad talab (offensif)', (SELECT id FROM themes WHERE name = 'Djihad' LIMIT 1)),
(UUID(), 'Jihad difa\' (défensif)', (SELECT id FROM themes WHERE name = 'Djihad' LIMIT 1));

-- GOUVERNEURS MUSULMANS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'L\'obéissance au gouverneur', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'Les 4 califes bien guidés', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'Attitude islamique face aux gouverneurs oppresseurs', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'Le serment d\'allégeance (al-bay\'ah)', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'L\'ordre et la sécurité dans la shari\'ah', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'Jugement sur la critique publique des gouvernements', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1)),
(UUID(), 'Les dirigeants dans le Coran et la Sunna', (SELECT id FROM themes WHERE name = 'Gouverneurs musulmans' LIMIT 1));

-- TRANSACTIONS
INSERT INTO subcategories (id, name, theme_id) VALUES 
(UUID(), 'Définition des transactions islamiques', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Conditions de validité d\'un contrat (ʿaqd)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Riba (usure)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Bayʿ (vente licite)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Gharar (incertitude excessive)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Types de contrats commerciaux', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Le prêt (qarḍ)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Vente à crédit', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Usure dans les banques', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Investissement licite', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Zakat sur biens commerciaux', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Commerce halal et haram', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Assurance (taʾmīn)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Dettes et remboursement', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Éthique du commerçant musulman', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Mensonge en affaire', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Tromperie et tricherie (ghish)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Monopole et spéculation', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Salaire et rémunération licites', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Louage et location (ijārah)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Contrats modernes (leasing)', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Transactions avec non-musulmans', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Interdits du marché', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1)),
(UUID(), 'Droits du client et vendeur', (SELECT id FROM themes WHERE name = 'Transactions' LIMIT 1));


SELECT t.name as theme, COUNT(s.id) as nb_subcategories 
FROM themes t 
LEFT JOIN subcategories s ON t.id = s.theme_id 
GROUP BY t.name 
ORDER BY t.name;


SELECT t.name as theme, s.name as subcategory 
FROM themes t 
JOIN subcategories s ON t.id = s.theme_id 
ORDER BY t.name, s.name;