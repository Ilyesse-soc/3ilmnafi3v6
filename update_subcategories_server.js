// Script pour mettre à jour les sous-catégories sur le serveur o2switch
// Ce script contient les données complètes à déployer

const https = require('https');
const fs = require('fs');

console.log('🔄 Mise à jour des sous-catégories sur le serveur...');

// Test d'abord l'API actuelle
console.log('\n📊 État actuel de l\'API:');

const options = {
  hostname: '3ilmnafi3.digilocx.fr',
  port: 443,
  path: '/api/subcategories',
  method: 'GET',
  headers: {
    'Content-Type': 'application/json'
  }
};

const req = https.request(options, (res) => {
  let data = '';
  
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    try {
      const response = JSON.parse(data);
      console.log(`✅ Statut: ${res.statusCode}`);
      console.log(`📈 Total sous-catégories actuelles: ${response.total || 'N/A'}`);
      
      if (response.data && response.data.length > 0) {
        console.log('\n🔍 Exemples actuels:');
        response.data.slice(0, 5).forEach(item => {
          console.log(`  - ${item.name} (ID: ${item.id}, Thème: ${item.themeId})`);
        });
      }
      
      if (response.total < 50) {
        console.log('\n❌ PROBLÈME DÉTECTÉ: Seulement ' + response.total + ' sous-catégories trouvées.');
        console.log('💡 Le serveur doit être mis à jour avec les nouvelles données complètes.');
        console.log('\n📋 ACTION REQUISE:');
        console.log('1. Copier le nouveau fichier routes/subcategoryRoute.js sur le serveur');
        console.log('2. Redémarrer le serveur Node.js');
        console.log('3. Vérifier que toutes les 256 sous-catégories sont disponibles');
      } else {
        console.log('\n✅ Les données semblent complètes!');
      }
      
    } catch (e) {
      console.error('❌ Erreur parsing:', e.message);
    }
  });
});

req.on('error', (e) => {
  console.error('❌ Erreur requête:', e.message);
});

req.end();

// Afficher un résumé des nouvelles données
setTimeout(() => {
  console.log('\n📊 RÉSUMÉ DES NOUVELLES DONNÉES:');
  console.log('• Total des thèmes: 31');
  console.log('• Total des sous-catégories: 256');
  console.log('• Thèmes ajoutés: Tawhid, Prière, Ramadan, Zakat, Hajj, etc.');
  console.log('• Chaque sous-catégorie a un ID unique et themeId associé');
  
  console.log('\n🎯 MAPPING DES THÈMES:');
  const themes = [
    '1: Tawhid (11 sous-cat)', '2: Prière (14 sous-cat)', '3: Ramadan (6 sous-cat)',
    '4: Zakat (5 sous-cat)', '5: Hajj (9 sous-cat)', '6: Le Coran (8 sous-cat)',
    '7: La Sunna (11 sous-cat)', '8: Prophètes (8 sous-cat)', '9: 73 Sectes (11 sous-cat)',
    '10: Compagnons (8 sous-cat)', '11: Les innovations (7 sous-cat)', '12: Les Savants (3 sous-cat)',
    '13: La mort (6 sous-cat)', '14: La tombe (7 sous-cat)', '15: Le jour dernier (6 sous-cat)',
    '16: Les 4 Imams (4 sous-cat)', '17: Les Anges (10 sous-cat)', '18: Les Djinns (6 sous-cat)',
    '19: Les gens du livre (8 sous-cat)', '20: 99 Noms (5 sous-cat)', '21: Femmes (10 sous-cat)',
    '22: Voyage (6 sous-cat)', '23: Signes (9 sous-cat)', '24: Adkars (18 sous-cat)',
    '25: Mariage (16 sous-cat)', '26: 2 fêtes (2 sous-cat)', '27: Jours importants (3 sous-cat)',
    '28: Hijra (3 sous-cat)', '29: Djihad (5 sous-cat)', '30: Gouverneurs musulmans (7 sous-cat)',
    '31: Transactions (24 sous-cat)'
  ];
  
  themes.forEach(theme => console.log(`  ${theme}`));
}, 2000);