

import 'package:flutter/material.dart';

import 'lib/constants/theme_ids.dart';
import 'lib/screens/theme_subcategories_page.dart';

class MainThemePage extends StatelessWidget {
  const MainThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thèmes Islamiques')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return GestureDetector(
            onTap: () {
              
              if (hasThemeId(theme.name)) {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThemeSubcategoriesPage(
                      themeName: theme.name,
                    ),
                  ),
                );
              } else {
                
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
                  const SizedBox(height: 8),
                  Text(
                    theme.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: hasThemeId(theme.name) ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hasThemeId(theme.name) ? 'Disponible' : 'En cours',
                      style: const TextStyle(
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


class ThemeData {
  final String name;
  final IconData icon;
  final Color color;

  const ThemeData({required this.name, required this.icon, required this.color});
}

final List<ThemeData> themes = [
  const ThemeData(name: 'Prière', icon: Icons.mosque, color: Colors.green),
  const ThemeData(name: 'Tawhid', icon: Icons.star, color: Colors.blue),
  const ThemeData(name: 'Ramadan', icon: Icons.nights_stay, color: Colors.purple),
  const ThemeData(name: 'Zakat', icon: Icons.volunteer_activism, color: Colors.teal),
  const ThemeData(name: 'Hajj', icon: Icons.location_on, color: Colors.brown),
  const ThemeData(name: 'Le Coran', icon: Icons.book, color: Colors.indigo),
  const ThemeData(name: 'La Sunna', icon: Icons.library_books, color: Colors.amber),
  const ThemeData(name: 'Prophètes', icon: Icons.people, color: Colors.cyan),
  const ThemeData(name: '73 Sectes', icon: Icons.group, color: Colors.red),
  const ThemeData(name: 'Compagnons', icon: Icons.person, color: Colors.orange),
  const ThemeData(name: 'Les Savants', icon: Icons.school, color: Colors.deepPurple),
  const ThemeData(name: 'Les innovations', icon: Icons.warning, color: Colors.redAccent),
  const ThemeData(name: 'La mort', icon: Icons.sentiment_neutral, color: Colors.grey),
  const ThemeData(name: 'La tombe', icon: Icons.terrain, color: Colors.brown),
  const ThemeData(name: 'Le jour dernier', icon: Icons.schedule, color: Colors.deepOrange),
  const ThemeData(name: 'Les 4 Imams', icon: Icons.account_balance, color: Colors.blueGrey),
  const ThemeData(name: 'Les Anges', icon: Icons.flight, color: Colors.lightBlue),
  const ThemeData(name: 'Les Djinns', icon: Icons.visibility_off, color: Colors.black),
  const ThemeData(name: 'Les gens du livre', icon: Icons.menu_book, color: Colors.lime),
  const ThemeData(name: '99 Noms', icon: Icons.format_list_numbered, color: Colors.pink),
  const ThemeData(name: 'Femmes', icon: Icons.female, color: Colors.pinkAccent),
  const ThemeData(name: 'Voyage', icon: Icons.flight_takeoff, color: Colors.lightGreen),
  const ThemeData(name: 'Signes', icon: Icons.visibility, color: Colors.yellow),
  const ThemeData(name: 'Adkars', icon: Icons.favorite, color: Colors.red),
];

