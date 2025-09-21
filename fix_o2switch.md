# Instructions de correction pour o2switch

## PROBLÈME IDENTIFIÉ
Error: Cannot find module './routes/subcategoryRoute'
= Le fichier routes/subcategoryRoute.js manque sur o2switch

## SOLUTION A (Recommandée) - Upload du fichier
1. Créer le dossier routes/ sur o2switch :
```bash
cd /home/fony5290/3ilmnafi3.fony5290.odns.fr/
mkdir -p routes
```

2. Uploader le fichier subcategoryRoute.js dans routes/

3. Redémarrer :
```bash
npm start
```

## SOLUTION B (Temporaire) - Désactiver le module
Si l'upload ne marche pas, modifier index.js temporairement :

Ligne 10, remplacer :
```javascript
const subcategoryRoutes = require('./routes/subcategoryRoute');
```

Par :
```javascript
// const subcategoryRoutes = require('./routes/subcategoryRoute');
```

Et commenter aussi la ligne qui utilise subcategoryRoutes plus bas.

## VÉRIFICATION
Une fois corrigé, tester :
```
GET https://3ilmnafi3.digilocx.fr/api/subcategories
```

Le fichier subcategoryRoute.js est prêt dans le projet local !