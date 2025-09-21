import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/video.dart';

class AdminVideoDetailsPage extends StatefulWidget {
  final Video video;

  const AdminVideoDetailsPage({super.key, required this.video});

  @override
  State<AdminVideoDetailsPage> createState() => _AdminVideoDetailsPageState();
}

class _AdminVideoDetailsPageState extends State<AdminVideoDetailsPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Vérifier si videoUrl existe avant d'initialiser le controller
    if (widget.video.videoUrl != null && widget.video.videoUrl!.isNotEmpty) {
      try {
        final urlParts = widget.video.videoUrl!.split("/");
        if (urlParts.length > 4) {
          _controller = VideoPlayerController.network(
            "https://3ilmnafi3.digilocx.fr/uploads/${urlParts[4]}"
          );
          
          // Initialiser de manière sécurisée
          _controller.initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          }).catchError((error) {
            print('Erreur initialisation vidéo: $error');
            // Ne pas crash, juste logger l'erreur
          });
        }
      } catch (e) {
        print('Erreur parsing videoUrl: $e');
        // Créer un controller vide pour éviter les erreurs
        _controller = VideoPlayerController.network('');
      }
    } else {
      // Créer un controller vide si pas de video URL
      _controller = VideoPlayerController.network('');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    final themes = video.themes.map((t) => t['name']).join(", ");
    final subcategories = video.subcategories.join(", ");

    return Scaffold(
      appBar: AppBar(title: Text("🧐 Détails de la vidéo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📌 Titre :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(video.title),
            SizedBox(height: 12),

           /* if (video.description != null) ...[
              Text("📝 Description :", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(video.description!),
              SizedBox(height: 12),
            ],*/

            Text("🗂️ Thèmes :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(themes),
            SizedBox(height: 12),

            Text("🔖 Sous-catégories :", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(subcategories),
            SizedBox(height: 12),

            /*if (video.author != null) ...[
              Text("👤 Intervenant :", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(video.author!),
              SizedBox(height: 12),
            ],*/

            Text("🖼️ Image & Vidéo :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            if (video.imageUrl != null && video.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(video.imageUrl!),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.video_library, size: 50, color: Colors.grey.shade600),
              ),
            SizedBox(height: 16),

            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
