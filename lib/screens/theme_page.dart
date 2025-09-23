import 'dart:convert';

import 'package:_3ilm_nafi3/models/uploader.dart';
import 'package:_3ilm_nafi3/screens/video_screen.dart';
import 'package:_3ilm_nafi3/widgets/robust_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../constants.dart'; // unused
import '../models/video.dart';
// import '../constants/theme_subcategories.dart'; // replaced by dynamic categories

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

Future<List<String>> loadSeenVideosPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('seen_videos') ?? [];
}

class ThemePage extends StatefulWidget {
  final String theme;
  final String videosPath;
  final String imagePath;

  const ThemePage({
    Key? key,
    required this.theme,
    required this.videosPath,
    required this.imagePath,
  }) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late Future<List<Video>> videosFuture;
  List<String> seenVideos = [];

  @override
  void initState() {
    super.initState();
    videosFuture = fetchVideosForTheme(widget.videosPath);
    loadSeenVideosPrefs().then((list) => setState(() => seenVideos = list));
  }

  // ...existing code...

  Future<List<Video>> fetchVideos(String themeId) async {
    final url = Uri.parse(
      'https://3ilmnafi3.digilocx.fr/api/videos/isvalid/theme/$themeId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List videosJson = data['videos'];
      return videosJson.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<void> markVideoAsSeen(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedSeenVideos = prefs.getStringList('seen_videos') ?? [];
    if (!updatedSeenVideos.contains(videoId)) {
      updatedSeenVideos.add(videoId);
      await prefs.setStringList('seen_videos', updatedSeenVideos);
    }
    setState(() {
      seenVideos = updatedSeenVideos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Image Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(widget.imagePath, fit: BoxFit.cover),
                  Center(
                    child: Text(
                      widget.theme,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subcategories list (and navigate to videos for a subcategory)
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catégories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: FutureBuilder<List<Video>>(
                        future: videosFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: Colors.green));
                          if (snapshot.hasError) return Center(child: Text('Erreur de chargement des catégories'));
                          final allVideos = snapshot.data ?? [];
                          // Collect unique subcategories chosen by users for this theme
                          final Set<String> subs = {};
                          for (var v in allVideos) {
                            for (var s in v.subcategories) {
                              final st = s.toString().trim();
                              if (st.isNotEmpty) subs.add(st);
                            }
                          }
                          final List<String> subList = subs.toList()..sort();
                          if (subList.isEmpty) return Center(child: Text('Aucune catégorie disponible pour ce thème'));

                          return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            padding: EdgeInsets.zero,
                            children: subList.map((sub) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubcategoryPage(
                                        theme: widget.theme,
                                        themeId: widget.videosPath,
                                        subcategory: sub,
                                        imagePath: widget.imagePath,
                                      ),
                                    ),
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(sub, style: TextStyle(color: Colors.black)),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Button
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

class SubcategoryPage extends StatefulWidget {
  final String theme;
  final String themeId;
  final String subcategory;
  final String imagePath;

  const SubcategoryPage({Key? key, required this.theme, required this.themeId, required this.subcategory, required this.imagePath}) : super(key: key);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  late Future<List<Video>> videosFuture;
  List<String> seenVideos = [];

  @override
  void initState() {
    super.initState();
  videosFuture = fetchVideosForTheme(widget.themeId);
  loadSeenVideosPrefs().then((list) => setState(() => seenVideos = list));
  }

  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subcategory}')),
      body: FutureBuilder<List<Video>>(
        future: videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: Colors.green));
          if (snapshot.hasError) return Center(child: Text('Erreur de chargement'));
          final all = snapshot.data ?? [];
          final filtered = all.where((v) => v.subcategories.contains(widget.subcategory)).toList();
          if (filtered.isEmpty) return Center(child: Text('Aucune vidéo pour cette sous-catégorie'));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.7),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final video = filtered[index];
              final isSeen = seenVideos.contains(video.id);
                  return GestureDetector(
                onTap: () async {
                  // mark seen and open video page
                  final prefs = await SharedPreferences.getInstance();
                  List<String> updated = prefs.getStringList('seen_videos') ?? [];
                  if (!updated.contains(video.id)) {
                    updated.add(video.id);
                    await prefs.setStringList('seen_videos', updated);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPage(
                        videoId: video.id,
                        videoUrl: video.videoUrl ?? '',
                        title: video.title,
                        uploader: Uploader(
                          id: video.uploader['id'] ?? 'unknown',
                          isAdmin: false,
                          username: (video.uploader['username'] ?? 'Utilisateur inconnu;;;').split(';')[0],
                          email: '',
                          profilePic: (video.uploader['username'] ?? ';;0;').split(';')[2],
                        ),
                        likeCount: video.likesCount,
                        refr: video.ref,
                        playlist: filtered,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          RobustNetworkImage(
                            imageUrl: video.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (isSeen)
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                color: Colors.green,
                                child: Text('Vu', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
