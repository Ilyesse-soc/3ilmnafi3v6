//screens/admin_video_page.dart

import 'dart:convert';

import 'package:_3ilm_nafi3/constants.dart';
import 'package:_3ilm_nafi3/widgets/robust_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../constants/theme_subcategories.dart'; // Pour les sous-catégories par thème
import '../models/video.dart';
import '../services/notification_service.dart';
import 'admin_video_details_page.dart';


class _ImageVideoPager extends StatefulWidget {
  final String imageUrl;
  final String videoUrl;

  const _ImageVideoPager({required this.imageUrl, required this.videoUrl});

  @override
  State<_ImageVideoPager> createState() => _ImageVideoPagerState();
}

class _ImageVideoPagerState extends State<_ImageVideoPager> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://3ilmnafi3.digilocx.fr/uploads/${widget.videoUrl.split("/")[4]}",
    )..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: RobustNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        _isVideoInitialized
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 64,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator(color: green)),
      ],
    );
  }
}

class AdminValidationPage extends StatefulWidget {
  @override
  _AdminValidationPageState createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  List<Video> unapprovedVideos = [];

  @override
  void initState() {
    super.initState();
    fetchUnapprovedVideos();
  }

  Future<void> fetchUnapprovedVideos() async {
    try {
      final response = await http.get(
        Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        print("📦 Données API récupérées : ${data.length} éléments");

        setState(() {
          unapprovedVideos = data
              .map((v) => Video.fromJson(v))
              .where((v) => v.isValid == false)
              .toList();
        });

        print("📽️ Vidéos non validées trouvées : ${unapprovedVideos.length}");
      } else {
        print("❌ Erreur API : ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Exception dans fetchUnapprovedVideos: $e");
    }
  }

  Future<void> updateApproval(String videoId, bool approve) async {
    try {
      if (approve) {
        final response = await http.put(
          Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/$videoId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'isValid': true}),
        );

        if (response.statusCode == 200) {
          await NotificationService.showValidationNotification(
            true,
            customMessage: "✅ Votre vidéo a été validée alhamdulillah.",
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Vidéo validée avec succès'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );

          fetchUnapprovedVideos();
        }
      } else {
        final response = await http.delete(
          Uri.parse("https://3ilmnafi3.digilocx.fr/api/videos/$videoId"),
        );

        if (response.statusCode == 200) {
          await NotificationService.showValidationNotification(
            false,
            customMessage: "❌ Votre vidéo a été refusée.",
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Vidéo refusée'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );

          fetchUnapprovedVideos();
        }
      }
    } catch (e) {
      print("🚨 Erreur lors de l'approbation/refus : $e");
    }
  }

  void showVideoDialog(BuildContext context, String imageUrl, String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: _ImageVideoPager(imageUrl: imageUrl, videoUrl: videoUrl),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Validation des vidéos")),
      body: unapprovedVideos.isEmpty
          ? Center(
              child: Text(
                "Aucune vidéo à valider.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: unapprovedVideos.length,
              itemBuilder: (_, index) {
                final video = unapprovedVideos[index];
                final themes = (video.themes as List)
                    .map((theme) => theme['name'])
                    .join(', ');

                // Ajout affichage sous-catégories
                final subcats = (video.subcategories != null && video.subcategories.isNotEmpty)
                    ? video.subcategories.join(', ')
                    : null;

                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      if (video.imageUrl != null && video.videoUrl != null) {
                        showVideoDialog(context, video.imageUrl!, video.videoUrl!);
                      }
                    },
                    child: RobustNetworkImage(
                      imageUrl: video.imageUrl,
                      width: 50,
                      height: 170,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  title: Text(
                    video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ref: ${video.ref}"),
                      Text("Thèmes: $themes"),
                      if (subcats != null)
                        Text(
                          "Sous-catégories: $subcats",
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AdminVideoDetailsPage(video: video),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => EditVideoDialog(
                              video: video,
                              onSaved: fetchUnapprovedVideos,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => updateApproval(video.id, true),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => updateApproval(video.id, false),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class EditVideoDialog extends StatefulWidget {
  final Video video;
  final Function() onSaved;

  const EditVideoDialog({required this.video, required this.onSaved, Key? key}) : super(key: key);

  @override
  State<EditVideoDialog> createState() => _EditVideoDialogState();
}

class _EditVideoDialogState extends State<EditVideoDialog> {
  late String selectedTheme;
  late List<String> selectedSubcategories;

  @override
  void initState() {
    super.initState();
    selectedTheme = widget.video.themes.isNotEmpty
        ? widget.video.themes.first['name']
        : '';
    selectedSubcategories = List<String>.from(widget.video.subcategories);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier la vidéo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedTheme,
            items: themeSubcategories.keys.map((theme) {
              return DropdownMenuItem(
                value: theme,
                child: Text(theme),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTheme = value!;
                selectedSubcategories = [];
              });
            },
          ),
          const SizedBox(height: 10),
          Wrap(
            children: (themeSubcategories[selectedTheme] ?? []).map<Widget>((subcat) {
              return FilterChip(
                label: Text(subcat),
                selected: selectedSubcategories.contains(subcat),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      if (selectedSubcategories.length < 3) {
                        selectedSubcategories.add(subcat);
                      }
                    } else {
                      selectedSubcategories.remove(subcat);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Annuler'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text('Enregistrer'),
          onPressed: () async {
            // Appel API PUT
            await updateVideoThemeAndSubcategories(
              widget.video.id,
              selectedTheme,
              selectedSubcategories,
            );
            widget.onSaved();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

// Fonction pour faire le PUT
Future<void> updateVideoThemeAndSubcategories(
    String videoId, String theme, List<String> subcategories) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/$videoId');
  await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'themes': [theme],
      'subcategories': subcategories,
    }),
  );
}