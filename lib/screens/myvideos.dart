import 'package:_3ilm_nafi3/constants.dart';
import 'package:_3ilm_nafi3/services/video_service.dart';
import 'package:_3ilm_nafi3/utils/nom_respectueux.dart';
import 'package:_3ilm_nafi3/widgets/robust_network_image.dart';
import 'package:flutter/material.dart';
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

    print('🔍 Chargement des vidéos pour l\'utilisateur: $loggedID');

    try {
      // Utiliser VideoService pour récupérer TOUTES les vidéos de l'utilisateur (validées et non-validées)
      final userVideos = await VideoService.getUserVideos();
      
      print('📊 Total vidéos utilisateur récupérées: ${userVideos.length}');
      
      setState(() {
        myVideos = userVideos;
        
        print('✅ Mes vidéos: ${myVideos.length}');
        
        // Debug: afficher les infos des vidéos avec leur statut
        for (int i = 0; i < myVideos.length; i++) {
          final video = myVideos[i];
          print('  ${i + 1}. ${video.title}');
          print('     - Image: ${video.imageUrl ?? "null"}');
          print('     - Valid: ${video.isValid}');
          print('     - Uploader: ${video.uploader['name'] ?? 'Utilisateur inconnu'}');
          print('     - Status: ${video.isValid ? "✅ Validée" : "⏳ En attente"}');
        }
        
        isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des vidéos: $e');
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: RobustNetworkImage(
                                  imageUrl: video.imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            // Indicateur de statut de validation
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: video.isValid ? Colors.green : Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  video.isValid ? 'Validée' : 'En attente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                video.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                afficherNomRespectueux(
                                  video.uploader['name'] ?? 'Utilisateur inconnu',
                                  video.uploader['genre'] ?? 'homme', // valeur par défaut si absent
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
