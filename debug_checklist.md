# Checklist de débogage pour l'erreur 500

## 1. Vérifier les logs d'erreur
```bash
# Sur o2switch
tail -f ~/logs/error.log
cat ~/logs/nodejs.log
```

## 2. Vérifier l'installation des dépendances
```bash
cd /path/to/your/app
npm install
# Vérifier que toutes les dépendances sont installées
npm list
```

## 3. Tester la syntaxe des nouveaux fichiers
```bash
# Vérifier la syntaxe JavaScript
node -c routes/subcategoryRoute.js
node -c index.js
```

## 4. Vérifier la connexion à la base de données
- Tester la connexion PostgreSQL
- S'assurer que les tables existent
- Vérifier les credentials de DB

## 5. Redémarrer le serveur proprement
```bash
# Arrêter le serveur
pm2 stop all
# ou kill les processus Node.js
pkill node

# Redémarrer
npm start
# ou
pm2 start index.js
```

## 6. Vérifier les permissions des fichiers
```bash
chmod 644 routes/subcategoryRoute.js
chmod 644 index.js
```

## Fichiers modifiés récemment :
- `routes/subcategoryRoute.js` (nouveau)
- `index.js` (modifié)
- `subcategories_complete.sql` (nouveau)

## Test de base :
Une fois le serveur redémarré, tester :
```
GET https://3ilmnafi3.digilocx.fr/api/health
```
Puis :
```
GET https://3ilmnafi3.digilocx.fr/api/subcategories
```