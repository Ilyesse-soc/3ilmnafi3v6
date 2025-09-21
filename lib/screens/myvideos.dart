import 'dart:convert';

import 'package:_3ilm_nafi3/constants.dart';
// S'assurer que le fichier existe bien dans lib/utils/nom_respectueux.dart
import 'package:_3ilm_nafi3/utils/nom_respectueux.dart';
import 'package:flutter/material.dart';
// Retirer l'import direct de flutter_local_notifications ici
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/video.dart';

// Retirer la fonction main ici, elle doit être dans main.dart
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initialize();
//   runApp(MyApp());
// }

class MyVideosPage extends StatefulWidget {
  @override
  _MyVideosPageState createState() => _MyVideosPageState();
}

class _MyVideosPageState extends State<MyVideosPage> {
  List<Video> myVideos = [];
  String? loggedID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMyVideos();
  }

  Future<void> loadMyVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedID = prefs.getString('loggedID');

    final response = await http.get(
      Uri.parse("https://3ilmnafi3.digilocx.fr/api/videos"),
    );

    if (response.statusCode == 200 && loggedID != null) {
      List allVideos = json.decode(response.body);
      setState(() {
        myVideos =
            allVideos
                .map((json) => Video.fromJson(json))
                .where((video) => video.uploader['id'] == loggedID)
                .toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteVideo(String id) async {
    final response = await http.delete(
      Uri.parse("https://3ilmnafi3.digilocx.fr/api/videos/$id"),
    );
    if (response.statusCode == 200) {
      setState(() {
        myVideos.removeWhere((video) => video.id == id);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Veuillez réessayer plus tard.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes vidéos')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: green,))
              : GridView.builder(
                padding: EdgeInsets.all(8),
                itemCount: myVideos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 9 / 16,
                ),
                itemBuilder: (context, index) {
                  final video = myVideos[index];
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: video.imageUrl != null && video.imageUrl!.isNotEmpty 
                                  ? DecorationImage(
                                      image: NetworkImage(video.imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                                borderRadius: BorderRadius.circular(8),
                                color: video.imageUrl == null || video.imageUrl!.isEmpty 
                                  ? Colors.grey.shade300 
                                  : null,
                              ),
                              child: video.imageUrl == null || video.imageUrl!.isEmpty
                                ? const Center(
                                    child: Icon(
                                      Icons.video_library,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.white),
                                onPressed:
                                    () => showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Supprimer'),
                                            content: Text(
                                              'Voulez-vous supprimer cette vidéo?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                    ), 
                                                child: Text('Annuler',style: TextStyle(color: Colors.black),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                    context,
                                                  ); 
                                                  deleteVideo(
                                                    video.id,
                                                  ); 
                                                },
                                                child: Text(
                                                  'Supprimer',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        video.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        afficherNomRespectueux(
                          video.uploader['name'],
                          video.uploader['genre'] ?? 'homme', // valeur par défaut si absent
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}

// Supprimer la classe NotificationService d'ici, elle doit être dans lib/services/notification_service.dart
// Supprimer aussi la fonction afficherNomRespectueux d'ici, elle doit être dans lib/utils/nom_respectueux.dart
