import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/uploader.dart';
import '../models/video.dart';
import '../widgets/robust_network_image.dart';
import 'video_screen.dart';

/// Page pour afficher les vidéos d'une sous-catégorie spécifique
class SubcategoryVideosPage extends StatefulWidget {
  final String themeName;
  final String subcategoryName;
  final String themeId;

  const SubcategoryVideosPage({
    super.key,
    required this.themeName,
    required this.subcategoryName,
    required this.themeId,
  });

  @override
  State<SubcategoryVideosPage> createState() => _SubcategoryVideosPageState();
}

class _SubcategoryVideosPageState extends State<SubcategoryVideosPage> {
  List<Video> videos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubcategoryVideos();
  }

  /// Récupère les vidéos filtrées par thème et sous-catégorie
  Future<void> _loadSubcategoryVideos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      print('🔍 Chargement des vidéos pour:');
      print('   - Thème: ${widget.themeName}');
      print('   - Sous-catégorie: ${widget.subcategoryName}');
      
      // Récupérer toutes les vidéos validées du thème
      final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/${widget.themeId}');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List videosJson = data['videos'] ?? [];
        
        // Convertir en objets Video
        final allThemeVideos = videosJson.map((json) => Video.fromJson(json)).toList();
        
        print('📊 Total vidéos du thème ${widget.themeName}: ${allThemeVideos.length}');
        
        // Filtrer par sous-catégorie
        final filteredVideos = allThemeVideos.where((video) {
          // Vérifier si la sous-catégorie est dans la liste des sous-catégories de la vidéo
          return video.subcategories.contains(widget.subcategoryName);
        }).toList();
        
        print('✅ Vidéos filtrées pour "${widget.subcategoryName}": ${filteredVideos.length}');
        
        // Debug: afficher les sous-catégories de chaque vidéo
        for (int i = 0; i < allThemeVideos.length; i++) {
          final video = allThemeVideos[i];
          print('  ${i + 1}. ${video.title}');
          print('     - Sous-catégories: ${video.subcategories}');
        }
        
        setState(() {
          videos = filteredVideos;
          isLoading = false;
        });
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subcategoryName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.themeName}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadSubcategoryVideos,
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
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text("Chargement des vidéos...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        "Erreur de chargement",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadSubcategoryVideos,
                        icon: Icon(Icons.refresh),
                        label: Text("Réessayer"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                )
              : videos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "Aucune vidéo trouvée",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "pour la sous-catégorie \"${widget.subcategoryName}\"",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadSubcategoryVideos,
                            icon: Icon(Icons.refresh),
                            label: Text("Actualiser"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // En-tête avec le nombre de vidéos
                        Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.video_library, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${videos.length} vidéo${videos.length > 1 ? 's' : ''} disponible${videos.length > 1 ? 's' : ''}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Grille des vidéos
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 9 / 16,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final video = videos[index];
                                return _buildVideoCard(video);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildVideoCard(Video video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPage(
              videoId: video.id,
              videoUrl: video.videoUrl ?? '',
              title: video.title,
              uploader: Uploader.fromJson(video.uploader),
              likeCount: video.likesCount,
              refr: video.ref,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Image avec gestion d'erreur robuste
              RobustNetworkImage(
                imageUrl: video.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Titre de la vidéo
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  video.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Icône de lecture
              Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}