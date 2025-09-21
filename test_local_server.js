// Test local du nouveau fichier subcategoryRoute.js
const express = require('express');
const app = express();
const port = 3001; // Port différent pour ne pas interférer avec le serveur existant

// Importer notre nouveau router
const subcategoryRoute = require('./routes/subcategoryRoute.js');

app.use('/api', subcategoryRoute);

// Route de test simple
app.get('/', (req, res) => {
  res.json({ 
    message: 'Serveur de test local pour les nouvelles sous-catégories',
    endpoints: [
      'GET /api/subcategories - Toutes les sous-catégories',
      'GET /api/subcategories/theme/:id - Sous-catégories par thème',
      'GET /api/test - Test de base'
    ]
  });
});

app.listen(port, () => {
  console.log(`\n🧪 SERVEUR DE TEST LOCAL DÉMARRÉ`);
  console.log(`📡 Port: ${port}`);
  console.log(`🌐 URL: http://localhost:${port}`);
  
  console.log(`\n🔗 ENDPOINTS DE TEST:`);
  console.log(`• Toutes les sous-catégories: http://localhost:${port}/api/subcategories`);
  console.log(`• Thème Tawhid (ID=1): http://localhost:${port}/api/subcategories/theme/1`);
  console.log(`• Thème Prière (ID=2): http://localhost:${port}/api/subcategories/theme/2`);
  console.log(`• Test de base: http://localhost:${port}/api/test`);
  
  console.log(`\n📊 TESTS ATTENDUS:`);
  console.log(`• Total général: 256 sous-catégories`);
  console.log(`• Thème 1 (Tawhid): 11 éléments`);
  console.log(`• Thème 2 (Prière): 14 éléments`);
  console.log(`• Thème 24 (Adkars): 18 éléments`);
  console.log(`• Thème 31 (Transactions): 24 éléments`);
  
  console.log(`\n🛑 Pour arrêter: Ctrl+C`);
});