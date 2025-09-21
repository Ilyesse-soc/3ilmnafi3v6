import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/uploader.dart';
import '../models/video.dart';
import 'video_screen.dart';

// Fonction pour récupérer les vidéos du thème Prière
Future<List<Video>> fetchVideosForTheme(String themeId) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$themeId');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List videosJson = data['videos'];
    return videosJson.map((json) => Video.fromJson(json)).toList();
  }
  throw Exception('Failed to load videos');
}

class TawhidPage extends StatefulWidget {
  const TawhidPage({super.key});

  @override
  State<TawhidPage> createState() => _TawhidPageState();
}

class _TawhidPageState extends State<TawhidPage> {
  
  List<Video> videos = [];
  bool isLoading = true;
  final String prayerThemeId = "33b5b607-10f7-4b40-a1ad-8becbcfa7983"; // ID du thème Prière

  @override
  void initState() {
    super.initState();
    _loadPrayerVideos();
  }

  Future<void> _loadPrayerVideos() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      print('🔄 Chargement des vidéos du thème Prière...');
      videos = await fetchVideosForTheme(prayerThemeId);
      print('📊 Vidéos récupérées: ${videos.length}');
      
      // Afficher les titres des vidéos pour debug
      for (int i = 0; i < videos.length; i++) {
        print('  ${i + 1}. ${videos[i].title}');
      }
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des vidéos: $e');
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
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Chargement des vidéos...", style: TextStyle(color: Colors.grey)),
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
                          "Aucune vidéo validée trouvée\npour le thème Prière",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadPrayerVideos,
                          icon: Icon(Icons.refresh),
                          label: Text("Actualiser"),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // En-tête avec nombre de vidéos et bouton refresh
                      Container(
                        margin: EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Prière (${videos.length} vidéos)",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              onPressed: _loadPrayerVideos,
                              icon: Icon(Icons.refresh, color: Colors.orange),
                              tooltip: "Actualiser",
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
                                        // Image ou container de fallback
                                        video.imageUrl != null && video.imageUrl!.isNotEmpty
                                          ? Image.network(
                                              video.imageUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: Colors.grey.shade300,
                                              child: Icon(Icons.video_library, size: 50, color: Colors.grey.shade600),
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
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
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
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.orange, size: 35),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
    );
  }
}