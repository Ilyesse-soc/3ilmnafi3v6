# DEBUG PLAN - Cannot GET /api/subcategories

## ÉTAPE 1: Test de base
URL: GET https://3ilmnafi3.digilocx.fr/api/test
Attendu: {"message": "Route de test fonctionne!", "timestamp": "..."}

## RÉSULTATS POSSIBLES:

### CAS A: /api/test FONCTIONNE ✅
- Les routes sont bien enregistrées
- Problème spécifique à /subcategories
- **Action**: Vérifier les logs pour voir "GET /subcategories called"
- **Solution**: Le code dans /subcategories a peut-être une erreur

### CAS B: /api/test NE MARCHE PAS ❌
- Les routes ne sont pas enregistrées
- **Causes possibles**:
  1. Le fichier subcategoryRoute.js n'existe pas sur o2switch
  2. Le require() échoue silencieusement
  3. Le app.use() n'est pas exécuté

## SOLUTIONS PAR CAS:

### Si CAS B (routes pas enregistrées):

#### Solution 1: Vérifier le fichier
```bash
ls -la routes/subcategoryRoute.js
cat routes/subcategoryRoute.js | head -10
```

#### Solution 2: Test de require direct
Ajouter dans index-minimal.js AVANT app.use():
```javascript
console.log('Testing require...');
try {
  const testRoutes = require('./routes/subcategoryRoute');
  console.log('subcategoryRoute loaded successfully:', typeof testRoutes);
} catch(err) {
  console.error('Error loading subcategoryRoute:', err.message);
}
```

#### Solution 3: Route directe dans index.js
Si le require échoue, ajouter directement dans index-minimal.js:
```javascript
app.get('/api/test-direct', (req, res) => {
  res.json({ message: "Route directe fonctionne!" });
});

app.get('/api/subcategories-direct', (req, res) => {
  res.json({ 
    success: true, 
    data: [
      { id: 1, name: "Test subcategory", themeId: 1 }
    ]
  });
});
```

### Si CAS A (test marche mais pas subcategories):

#### Solution 1: Vérifier les logs
Chercher dans les logs: "GET /subcategories called"

#### Solution 2: Simplifier la route subcategories
Remplacer le code complexe par:
```javascript
router.get('/subcategories', (req, res) => {
  console.log('Simple subcategories route called');
  res.json({ message: "Subcategories route works!" });
});
```

## ACTIONS IMMÉDIATES:
1. Tester GET /api/test
2. Selon le résultat, appliquer CAS A ou CAS B
3. Ajouter les console.log pour debug
4. Redémarrer et re-tester