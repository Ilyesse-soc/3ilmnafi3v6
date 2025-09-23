// example_theme_navigation_integration.dart
// 
// EXEMPLE d'intégration de ThemeSubcategoriesPage dans votre page principale
// Ce fichier montre comment remplacer les pages spécifiques par la page générique

import 'package:flutter/material.dart';

import '../constants/theme_ids.dart';
import '../screens/theme_subcategories_page.dart';

class MainThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thèmes Islamiques')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return GestureDetector(
            onTap: () {
              // Vérifier si le thème a un ID configuré
              if (hasThemeId(theme.name)) {
                // Naviguer vers la page générique des sous-catégories
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThemeSubcategoriesPage(
                      themeName: theme.name,
                    ),
                  ),
                );
              } else {
                // Afficher un message d'information
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thème ${theme.name} en cours de configuration'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    theme.icon,
                    size: 48,
                    color: theme.color,
                  ),
                  SizedBox(height: 8),
                  Text(
                    theme.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Indicateur de statut
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: hasThemeId(theme.name) ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hasThemeId(theme.name) ? 'Disponible' : 'En cours',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Exemple de structure de données pour les thèmes
class ThemeData {
  final String name;
  final IconData icon;
  final Color color;

  ThemeData({required this.name, required this.icon, required this.color});
}

final List<ThemeData> themes = [
  ThemeData(name: 'Prière', icon: Icons.mosque, color: Colors.green),
  ThemeData(name: 'Tawhid', icon: Icons.star, color: Colors.blue),
  ThemeData(name: 'Ramadan', icon: Icons.nights_stay, color: Colors.purple),
  ThemeData(name: 'Zakat', icon: Icons.volunteer_activism, color: Colors.teal),
  ThemeData(name: 'Hajj', icon: Icons.location_on, color: Colors.brown),
  // ... ajoutez tous les autres thèmes
];

/* 
INSTRUCTIONS D'INTÉGRATION :

1. Remplacez vos pages spécifiques (comme tawhid_page.dart) par des appels à ThemeSubcategoriesPage
2. Utilisez la fonction hasThemeId() pour vérifier si un thème est prêt
3. Configurez progressivement les IDs dans theme_ids.dart au fur et à mesure

AVANT (page spécifique) :
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TawhidPage()))

APRÈS (page générique) :
onTap: () => Navigator.push(context, MaterialPageRoute(
  builder: (context) => ThemeSubcategoriesPage(themeName: 'Tawhid')
))

4. Pour récupérer les vrais IDs des thèmes, vous devez :
   - Consulter votre base de données ou API
   - Remplacer les placeholders dans theme_ids.dart
   - Tester chaque thème individuellement
*/