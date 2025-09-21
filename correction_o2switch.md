# Guide de correction pour o2switch

## Étapes de correction par ordre de priorité

### 1. ARRÊTER LE SERVEUR ACTUEL
```bash
# Tuer tous les processus Node.js qui plantent
pkill -f node
# ou si vous utilisez pm2
pm2 stop all
pm2 delete all
```

### 2. VÉRIFIER LA STRUCTURE DES FICHIERS
```bash
ls -la routes/
# Doit afficher : subcategoryRoute.js

ls -la *.js
# Doit afficher : index.js
```

### 3. CORRIGER LES ERREURS COMMUNES

#### A. Si erreur "Cannot find module"
```bash
# Réinstaller les dépendances
npm install
npm install express sequelize pg cors dotenv
```

#### B. Si erreur de syntaxe dans subcategoryRoute.js
Vérifiez que le fichier routes/subcategoryRoute.js contient bien :
```javascript
const express = require('express');
const router = express.Router();
// ... reste du code
module.exports = router;
```

#### C. Si erreur dans index.js
Vérifiez que ces lignes sont ajoutées dans index.js :
```javascript
// Ajouter cette ligne avec les autres requires
const subcategoryRoutes = require('./routes/subcategoryRoute');

// Ajouter cette ligne avec les autres app.use
app.use('/api', subcategoryRoutes);
```

### 4. TESTER AVANT DE REDÉMARRER
```bash
# Vérifier la syntaxe
node -c index.js
node -c routes/subcategoryRoute.js
```

### 5. REDÉMARRER LE SERVEUR
```bash
# Méthode 1 - npm
npm start

# Méthode 2 - pm2 (recommandé pour o2switch)
pm2 start index.js --name "api-server"

# Méthode 3 - node direct
nohup node index.js > output.log 2>&1 &
```

### 6. VÉRIFIER QUE ÇA MARCHE
```bash
# Test local sur le serveur
curl http://localhost:3000/api/health
curl http://localhost:3000/api/subcategories

# Ou depuis l'extérieur
curl https://3ilmnafi3.digilocx.fr/api/subcategories
```

## En cas d'erreur persistante

### Erreur de base de données
```bash
# Vérifier que PostgreSQL fonctionne
pg_isready -h localhost -p 5432

# Tester la connexion
psql -h localhost -U votre_user -d votre_db
```

### Erreur de permissions
```bash
chmod 644 *.js
chmod 644 routes/*.js
chmod 755 .
```

### Erreur de port
Vérifier dans index.js que le port est correct pour o2switch :
```javascript
const PORT = process.env.PORT || 3000;
```

## Messages d'erreur courants

1. **"EADDRINUSE"** = Port déjà utilisé → Tuer le processus
2. **"Cannot find module"** = Dépendance manquante → npm install
3. **"SyntaxError"** = Erreur de code → Vérifier la syntaxe
4. **"ECONNREFUSED"** = DB inaccessible → Vérifier PostgreSQL
5. **"Permission denied"** = Problème de droits → chmod