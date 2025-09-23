import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/theme_ids.dart';
import '../constants/theme_subcategories.dart';
import '../models/video.dart';
import 'subcategory_videos_page.dart';

/// Page générique pour afficher les sous-catégories d'un thème
class ThemeSubcategoriesPage extends StatefulWidget {
  final String themeName;

  const ThemeSubcategoriesPage({
    super.key,
    required this.themeName,
  });

  @override
  State<ThemeSubcategoriesPage> createState() => _ThemeSubcategoriesPageState();
}

class _ThemeSubcategoriesPageState extends State<ThemeSubcategoriesPage> {
  
  Map<String, int> subcategoryVideoCounts = {};
  bool isLoading = true;
  List<String> subcategories = [];

  @override
  void initState() {
    super.initState();
    _initializeSubcategories();
    _loadVideoCountsForSubcategories();
  }

  void _initializeSubcategories() {
    // Récupérer les sous-catégories prédéfinies pour ce thème
    subcategories = themeSubcategories[widget.themeName] ?? [];
    print('📋 Sous-catégories pour ${widget.themeName}: ${subcategories.length}');
  }

  Future<void> _loadVideoCountsForSubcategories() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Récupérer l'ID du thème depuis la constante
      final themeId = getThemeId(widget.themeName);
      if (themeId == null || themeId.contains('_THEME_ID_HERE')) {
        print('⚠️ ID de thème non défini pour : ${widget.themeName}');
        setState(() {
          isLoading = false;
        });
        return;
      }

      print('🔄 Chargement des compteurs pour ${widget.themeName} (ID: $themeId)...');
      final counts = await fetchVideoCountsForTheme(themeId);
      
      print('📊 Compteurs récupérés pour ${widget.themeName}:');
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

  /// Fonction pour récupérer le nombre de vidéos par sous-catégorie
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
    throw Exception('Failed to load video counts for theme $themeId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.themeName),
        backgroundColor: _getThemeColor(widget.themeName),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadVideoCountsForSubcategories,
            icon: Icon(Icons.refresh),
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _getThemeColor(widget.themeName)),
                  SizedBox(height: 16),
                  Text(
                    "Chargement des sous-catégories...", 
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : subcategories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Aucune sous-catégorie définie",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "pour le thème \"${widget.themeName}\"",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // En-tête avec informations du thème
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getThemeColor(widget.themeName).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getThemeColor(widget.themeName).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getThemeColor(widget.themeName),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getThemeIcon(widget.themeName),
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.themeName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _getThemeColor(widget.themeName),
                                  ),
                                ),
                                Text(
                                  "${subcategories.length} sous-catégories disponibles",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Liste des sous-catégories
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          itemCount: subcategories.length,
                          itemBuilder: (context, index) {
                            final subcategory = subcategories[index];
                            final videoCount = subcategoryVideoCounts[subcategory] ?? 0;
                            
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 2,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    // Récupérer l'ID du thème
                                    final themeId = getThemeId(widget.themeName);
                                    if (themeId == null || themeId.contains('_THEME_ID_HERE')) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('ID de thème non configuré pour ${widget.themeName}')),
                                      );
                                      return;
                                    }

                                    // Naviguer vers la page des vidéos de cette sous-catégorie
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubcategoryVideosPage(
                                          themeName: widget.themeName,
                                          subcategoryName: subcategory,
                                          themeId: themeId,
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
                                          _getThemeColor(widget.themeName).withOpacity(0.05),
                                          _getThemeColor(widget.themeName).withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Icône de sous-catégorie
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _getThemeColor(widget.themeName),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            _getSubcategoryIcon(widget.themeName, subcategory),
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
                                                  color: _getThemeColor(widget.themeName).withOpacity(0.8),
                                                ),
                                              ),
                                              if (videoCount > 0)
                                                Text(
                                                  "$videoCount vidéo${videoCount > 1 ? 's' : ''}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: _getThemeColor(widget.themeName).withOpacity(0.6),
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
                                                  color: _getThemeColor(widget.themeName),
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
                                              color: _getThemeColor(widget.themeName),
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
    );
  }

  /// Retourne une couleur appropriée pour chaque thème
  /// Utilise uniquement orange (#ff751f) et vert (#345d42)
  Color _getThemeColor(String themeName) {
    // Couleurs définies par l'utilisateur
    final Color orange = Color(0xffff751f);
    final Color vert = Color(0xff345d42);
    
    switch (themeName) {
      case 'Tawhid':
        return vert;
      case 'Prière':
        return orange;
      case 'Ramadan':
        return orange;
      case 'Zakat':
        return orange;
      case 'Hajj':
        return orange;
      case 'Le Coran':
        return vert;
      case 'La Sunna':
        return vert;
      case 'Prophètes':
        return vert;
      case '73 Sectes':
        return orange;
      case 'Compagnons':
        return orange;
      case 'Les innovations':
        return orange;
      case 'Les Savants':
        return vert;
      case 'La mort':
        return orange;
      case 'La tombe':
        return orange;
      case 'Le jour dernier':
        return orange;
      case 'Les 4 Imams':
        return vert;
      case 'Les Anges':
        return vert;
      case 'Les Djinns':
        return orange;
      case 'Les gens du livre':
        return orange;
      case '99 Noms':
        return vert;
      case 'Femmes':
        return orange;
      case 'Voyage':
        return vert;
      case 'Signes':
        return orange;
      case 'Adkars':
        return vert;
      case 'Mariage':
        return orange;
      case '2 fêtes':
        return orange;
      case 'Jours importants':
        return orange;
      case 'Hijra':
        return vert;
      case 'Djihad':
        return orange;
      case 'Gouverneurs musulmans':
        return orange;
      case 'Transactions':
        return vert;
      default:
        return vert; // Couleur par défaut
    }
  }

  /// Retourne une icône appropriée pour chaque thème
  IconData _getThemeIcon(String themeName) {
    switch (themeName) {
      case 'Tawhid':
        return Icons.star;
      case 'Prière':
        return Icons.place;
      case 'Ramadan':
        return Icons.nightlight;
      case 'Zakat':
        return Icons.monetization_on;
      case 'Hajj':
        return Icons.location_on;
      case 'Le Coran':
        return Icons.menu_book;
      case 'La Sunna':
        return Icons.format_quote;
      case 'Prophètes':
        return Icons.person;
      case '73 Sectes':
        return Icons.warning;
      case 'Compagnons':
        return Icons.people;
      case 'Les innovations':
        return Icons.block;
      case 'Les Savants':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  /// Retourne une icône appropriée pour chaque sous-catégorie selon le thème
  IconData _getSubcategoryIcon(String themeName, String subcategory) {
    // Icônes spécifiques pour les sous-catégories de Prière
    if (themeName == 'Prière') {
      switch (subcategory) {
        case 'Les ablutions':
        case 'Le ghusl (lavage)':
        case 'Le Tayammum':
          return Icons.water_drop;
        case 'Les règles':
          return Icons.rule;
        case 'Istikhara (demande)':
          return Icons.help_outline;
        case 'Istisqa (pluie)':
          return Icons.cloud;
        case 'Vendredi':
          return Icons.calendar_today;
        case 'Les 5 prières obligatoires':
        case 'Les 12 rawatib':
          return Icons.access_time;
        case 'Mortuaire':
          return Icons.favorite;
        case 'Prière de nuit':
          return Icons.nightlight;
        case 'Salat Doha (jour montant)':
          return Icons.wb_sunny;
        case 'Salat al koussouf (éclipse)':
          return Icons.brightness_2;
        case 'Prière du voyageur':
          return Icons.luggage;
      }
    }

    // Icônes génériques selon le thème
    switch (themeName) {
      case 'Tawhid':
        return Icons.star_outline;
      case 'Ramadan':
        return Icons.nightlight_round;
      case 'Zakat':
        return Icons.attach_money;
      case 'Hajj':
        return Icons.flight_takeoff;
      case 'Le Coran':
        return Icons.chrome_reader_mode;
      case 'La Sunna':
        return Icons.format_quote;
      case 'Prophètes':
        return Icons.person_outline;
      default:
        return Icons.play_circle_outline;
    }
  }
}