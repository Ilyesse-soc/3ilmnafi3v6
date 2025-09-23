import 'package:_3ilm_nafi3/screens/admin_page.dart';
import 'package:_3ilm_nafi3/screens/admin_video_page.dart';
import 'package:_3ilm_nafi3/screens/home_screen.dart';
import 'package:_3ilm_nafi3/screens/login_screen.dart';
import 'package:_3ilm_nafi3/screens/register_screen.dart';
import 'package:_3ilm_nafi3/screens/require_profile.dart';
import 'package:_3ilm_nafi3/screens/splash_screen.dart';
import 'package:_3ilm_nafi3/screens/terms_conditions_page.dart';
import 'package:_3ilm_nafi3/screens/theme_subcategories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // 🔧 Initialisation notifications

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3ilm Nafi3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/adminConsole': (context) => AdminPage(),
        '/admin_video_page': (context) => AdminValidationPage(),
        '/page1': (context) => ThemeSubcategoriesPage(
              themeName: "Tawhid",
            ),
        '/page2': (context) => ThemeSubcategoriesPage(
              themeName: "Prière",
            ),
        '/page3': (context) => ThemeSubcategoriesPage(
              themeName: "Ramadan",
            ),
        '/page4': (context) => ThemeSubcategoriesPage(
              themeName: "Zakat",
            ),
        '/page5': (context) => ThemeSubcategoriesPage(
              themeName: "Hajj",
            ),
        '/page6': (context) => ThemeSubcategoriesPage(
              themeName: "Le Coran",
            ),
        '/page7': (context) => ThemeSubcategoriesPage(
              themeName: "La Sunna",
            ),
        '/page8': (context) => ThemeSubcategoriesPage(
              themeName: "Prophètes",
            ),
        '/page9': (context) => ThemeSubcategoriesPage(
              themeName: "73 Sectes",
            ),
        '/page10': (context) => ThemeSubcategoriesPage(
              themeName: "Compagnons",
            ),
        '/page11': (context) => ThemeSubcategoriesPage(
              themeName: "Les Savants",
            ),
        '/page12': (context) => ThemeSubcategoriesPage(
              themeName: "Les innovations",
            ),
        '/page13': (context) => ThemeSubcategoriesPage(
              themeName: "La mort",
            ),
        '/page14': (context) => ThemeSubcategoriesPage(
              themeName: "La tombe",
            ),
        '/page15': (context) => ThemeSubcategoriesPage(
              themeName: "Le jour dernier",
            ),
        '/page16': (context) => ThemeSubcategoriesPage(
              themeName: "Les 4 Imams",
            ),
        '/page17': (context) => ThemeSubcategoriesPage(
              themeName: "Les Anges",
            ),
        '/page18': (context) => ThemeSubcategoriesPage(
              themeName: "Les Djinns",
            ),
        '/page19': (context) => ThemeSubcategoriesPage(
              themeName: "Les gens du livre",
            ),
        '/page20': (context) => ThemeSubcategoriesPage(
              themeName: "99 Noms",
            ),
        '/page21': (context) => ThemeSubcategoriesPage(
              themeName: "Femmes",
            ),
        '/page22': (context) => ThemeSubcategoriesPage(
              themeName: "Voyage",
            ),
        '/page23': (context) => ThemeSubcategoriesPage(
              themeName: "Signes",
            ),
        '/page24': (context) => ThemeSubcategoriesPage(
              themeName: "Adkars",
            ),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    TermsAndConditionsPage(),
    HomeScreen(),
    RequireProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // ✅ fond blanc
        selectedItemColor: Color(0xFF1C8B6C), // ✅ bleu marocain sélectionné
        unselectedItemColor: Colors.grey,     // ✅ gris clair non sélectionné
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 35,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/logo3.png'),
              color: _currentIndex == 1
                  ? Color(0xFF1C8B6C)
                  : Colors.grey,
              size: 60,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
