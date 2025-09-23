import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/video.dart';
import 'subcategory_videos_page.dart';

// Fonction pour récupérer le nombre de vidéos par sous-catégorie
Future<Map<String, int>> fetchVideoCountsForTheme(String themeId) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$themeId');
  final response = await http.get(url);
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List videosJson = data['videos'] ?? [];
    final videos = videosJson.map((json) => Video.fromJson(json)).toList();
    
    // Compter les vidéos par sous-catégorie
    Map<String, int> counts = {};
    for (final video in videos) {
      for (final subcategory in video.subcategories) {
        counts[subcategory] = (counts[subcategory] ?? 0) + 1;
      }
    }
    
    return counts;
  }
  throw Exception('Failed to load video counts');
}

class TawhidPage extends StatefulWidget {
  const TawhidPage({super.key});

  @override
  State<TawhidPage> createState() => _TawhidPageState();
}

class _TawhidPageState extends State<TawhidPage> {
  
  Map<String, int> subcategoryVideoCounts = {};
  bool isLoading = true;
  final String tawhidThemeId = "92a89d9e-ebf2-4ed3-9ce4-03d06f7a6690"; // ID du thème Tawhid
  final String themeName = "Tawhid";
  
  // Sous-catégories du thème Tawhid
  final List<String> tawhidSubcategories = [
    'L\'intention',
    'Définition du tawhid',
    'Tawhid de l\'adoration',
    'Tawhid de la seigneurie',
    'Tawhid des noms et attributs',
    'Le shirk majeur',
    'Le shirk mineur',
    'Le shirk caché',
    'L\'aveux et le désaveu',
    'Tawhid dans le coran',
    'Tawhid dans la Sunna',
  ];

  @override
  void initState() {
    super.initState();
    _loadVideoCountsForSubcategories();
  }

  Future<void> _loadVideoCountsForSubcategories() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      print('🔄 Chargement des compteurs de vidéos par sous-catégorie...');
      final counts = await fetchVideoCountsForTheme(tawhidThemeId);
      
      print('📊 Compteurs récupérés:');
      for (final entry in counts.entries) {
        print('  ${entry.key}: ${entry.value} vidéos');
      }
      
      setState(() {
        subcategoryVideoCounts = counts;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des compteurs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xff345d42)),
                      SizedBox(height: 16),
                      Text("Chargement des sous-catégories...", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // En-tête avec titre et bouton refresh
                    Container(
                      margin: EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tawhid",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff345d42),
                                ),
                              ),
                              Text(
                                "${tawhidSubcategories.length} sous-catégories",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _loadVideoCountsForSubcategories,
                            icon: Icon(Icons.refresh, color: Color(0xff345d42)),
                            tooltip: "Actualiser",
                          ),
                        ],
                      ),
                    ),
                    
                    // Liste des sous-catégories
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          itemCount: tawhidSubcategories.length,
                          itemBuilder: (context, index) {
                            final subcategory = tawhidSubcategories[index];
                            final videoCount = subcategoryVideoCounts[subcategory] ?? 0;
                            
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 2,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    // Naviguer vers la page des vidéos de cette sous-catégorie
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubcategoryVideosPage(
                                          themeName: themeName,
                                          subcategoryName: subcategory,
                                          themeId: tawhidThemeId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xffff751f).withOpacity(0.1),
                                          Color(0xffff751f).withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Icône de catégorie
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0xff345d42),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            _getSubcategoryIcon(subcategory),
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        
                                        SizedBox(width: 16),
                                        
                                        // Nom de la sous-catégorie
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                subcategory,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff345d42),
                                                ),
                                              ),
                                              if (videoCount > 0)
                                                Text(
                                                  "$videoCount vidéo${videoCount > 1 ? 's' : ''}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xffff751f),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        
                                        // Badge avec le nombre de vidéos et flèche
                                        Row(
                                          children: [
                                            if (videoCount > 0)
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffff751f),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  videoCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Color(0xff345d42),
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            
            // Bouton retour
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xff345d42), size: 35),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
    );
  }

  /// Retourne une icône appropriée pour chaque sous-catégorie du Tawhid
  IconData _getSubcategoryIcon(String subcategory) {
    switch (subcategory) {
      case 'L\'intention':
        return Icons.favorite;
      case 'Définition du tawhid':
        return Icons.book;
      case 'Tawhid de l\'adoration':
        return Icons.mosque;
      case 'Tawhid de la seigneurie':
        return Icons.admin_panel_settings;
      case 'Tawhid des noms et attributs':
        return Icons.stars;
      case 'Le shirk majeur':
        return Icons.warning;
      case 'Le shirk mineur':
        return Icons.error_outline;
      case 'Le shirk caché':
        return Icons.visibility_off;
      case 'L\'aveux et le désaveu':
        return Icons.handshake;
      case 'Tawhid dans le coran':
        return Icons.menu_book;
      case 'Tawhid dans la Sunna':
        return Icons.library_books;
      default:
        return Icons.star;
    }
  }
}