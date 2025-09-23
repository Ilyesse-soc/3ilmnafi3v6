import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:_3ilm_nafi3/constants.dart';
import 'package:_3ilm_nafi3/models/uploader.dart';
import 'package:_3ilm_nafi3/screens/metadata.dart';
import 'package:_3ilm_nafi3/screens/user_profile_page.dart';
// ...existing imports...
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  final String title;
  final Uploader uploader;
  final String? refr;
  final int likeCount;
  final List<dynamic>? playlist;
  final int initialIndex;

  VideoPage({
    Key? key,
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.uploader,
  required this.likeCount,
    required this.refr,
    this.playlist,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  bool isPlaying = false;
  bool isFavorite = false;
  String? _seekOverlayText;
  bool _showSeekOverlay = false;
  Timer? _overlayTimer;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _loadLikeStatus();
    markVideoAsSeen(); // ✅ Marque la vidéo comme vue dès l'ouverture
  _likeCount = widget.likeCount;
    _currentIndex = widget.initialIndex;
  }

  int _currentIndex = 0;

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _showOverlay(String text) {
    _overlayTimer?.cancel();
    setState(() {
      _seekOverlayText = text;
      _showSeekOverlay = true;
    });
    _overlayTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _showSeekOverlay = false);
    });
  }

  void _handleHorizontalSwipe(DragEndDetails details) async {
    final v = details.primaryVelocity ?? 0.0;
    // right swipe -> positive velocity -> forward
    // left swipe -> negative velocity -> rewind
    const int deltaSeconds = 10;
    try {
  final position = await _videoPlayerController.position;
  final duration = _videoPlayerController.value.duration;
  if (position == null) return;
      // If there's a playlist and swipe is very strong, change video
      const int changeThreshold = 1500; // px/s
      if (widget.playlist != null && v.abs() > changeThreshold) {
        if (v < 0) {
          // fast left swipe -> next video
          await _playAtIndex(_currentIndex + 1);
        } else {
          // fast right swipe -> previous video
          await _playAtIndex(_currentIndex - 1);
        }
        return;
      }

      if (v > 300) {
        // forward small swipe -> seek forward
        final newPos = position + Duration(seconds: deltaSeconds);
        final target = newPos > duration ? duration : newPos;
        await _videoPlayerController.seekTo(target);
        _showOverlay('+${deltaSeconds}s');
      } else if (v < -300) {
        // rewind small swipe -> seek backward
        final newPos = position - Duration(seconds: deltaSeconds);
        final target = newPos.inMilliseconds < 0 ? Duration.zero : newPos;
        await _videoPlayerController.seekTo(target);
        _showOverlay('-${deltaSeconds}s');
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _playAtIndex(int index) async {
    if (widget.playlist == null) return;
    if (index < 0 || index >= (widget.playlist?.length ?? 0)) return;
    final video = widget.playlist![index];
    // update widget fields via controller re-init
    await _videoPlayerController.pause();
    await _videoPlayerController.dispose();
    setState(() {
      _currentIndex = index;
    });
    _videoPlayerController = VideoPlayerController.network(
      'https://3ilmnafi3.digilocx.fr/uploads/${(video.videoUrl ?? '').split('/').last}',
    );
    await _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.setVolume(1.0);
    await _videoPlayerController.play();
  }

  Future<void> _initVideo() async {
    String url = widget.videoUrl;
    if (widget.playlist != null && widget.playlist!.isNotEmpty) {
      final video = widget.playlist![_currentIndex];
      url = video.videoUrl ?? widget.videoUrl;
    }

    _videoPlayerController = VideoPlayerController.network(
      "https://3ilmnafi3.digilocx.fr/uploads/${url.split("/").last}",
    );
    await _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.setVolume(1.0);
    await _videoPlayerController.play();
    setState(() => isPlaying = true);
  }

  /// ✅ Fonction pour marquer la vidéo comme vue
  Future<void> markVideoAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> seenVideos = prefs.getStringList('seen_videos') ?? [];

    if (!seenVideos.contains(widget.videoId)) {
      seenVideos.add(widget.videoId);
      await prefs.setStringList('seen_videos', seenVideos);
      print("✅ Vidéo marquée comme vue : ${widget.videoId}");
    }
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      isPlaying = !isPlaying;
    });
  }

  Future<void> _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getString("loggedID")?.isNotEmpty ?? false;
    final likedVideos = prefs.getStringList('liked_videos') ?? [];
    setState(() {
      isFavorite = isLogged && likedVideos.contains(widget.videoId);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getString("loggedID")?.isNotEmpty ?? false;

    if (isLogged) {
      final likedVideos = prefs.getStringList('liked_videos') ?? [];

      setState(() {
        if (isFavorite) {
          likedVideos.remove(widget.videoId);
          _likeCount--;
        } else {
          likedVideos.add(widget.videoId);
          _likeCount++;
        }
        isFavorite = !isFavorite;
        prefs.setStringList('liked_videos', likedVideos);
      });

      final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos/${widget.videoId}');
      try {
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'likesCount': _likeCount}),
        );

        if (response.statusCode != 200) {
          print('Failed to update likes: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating like count: $e');
      }
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Veuillez vous connecter pour pouvoir liker."),
          backgroundColor: green,
          action: SnackBarAction(
            label: "Se connecter",
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/login");
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? GestureDetector(
                    onHorizontalDragEnd: _handleHorizontalSwipe,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: _videoPlayerController.value.size.width,
                        height: _videoPlayerController.value.size.height,
                        child: Stack(
                          children: [
                            VideoPlayer(_videoPlayerController),
                            if (_showSeekOverlay && _seekOverlayText != null)
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                                  child: Text(_seekOverlayText!, style: TextStyle(color: Colors.white, fontSize: 18)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
          ),
          Positioned(
            top: 35,
            left: 50,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoMetadataPage(
                      title: widget.title,
                      uploaderUsername: widget.uploader.username,
                      ref: widget.refr,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black.withOpacity(0.3),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Positioned(
            width: 50,
            top: 25,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.orange, size: 40),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoPlayerController.pause();
                      isPlaying = false;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfilePage(user: widget.uploader),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: (widget.uploader.profilePic == null || widget.uploader.profilePic == "0")
                        ? Icon(Icons.person, color: Colors.white, size: 30)
                        : null,
                    backgroundImage: (widget.uploader.profilePic != null && widget.uploader.profilePic != "0")
                        ? AssetImage(
                            "assets/images/small_profiles/profile${widget.uploader.profilePic}.PNG",
                          )
                        : null,
                  ),
                ),
                IconButton(
                  onPressed: togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  color: Colors.white,
                  onPressed: () {
                    final String message =
                        '${widget.title}\n📽️ Regarde ici : https://3ilmnafi3.digilocx.fr/uploads/${widget.videoUrl.split("/").last}';
                    Share.share(message);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.download_rounded),
                  color: Colors.white,
                  onPressed: () async {
                    _downloadVideo(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadVideo(BuildContext context) async {
    // Ask permission (Android)
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission de stockage refusée')));
          return;
        }
      }

      final url = widget.playlist != null && widget.playlist!.isNotEmpty
          ? widget.playlist![_currentIndex].videoUrl ?? widget.videoUrl
          : widget.videoUrl;

      final uri = Uri.parse('https://3ilmnafi3.digilocx.fr/uploads/${url.split('/').last}');
      final client = http.Client();
      final req = await client.get(uri);

      if (req.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec du téléchargement (${req.statusCode})')));
        return;
      }

      final bytes = req.bodyBytes;

      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
        // On some devices getExternalStorageDirectory returns app-specific dir; try Downloads
        final downloads = Directory('/storage/emulated/0/Download');
        if (downloads.existsSync()) dir = downloads;
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'obtenir le répertoire de destination')));
        return;
      }

      final fileName = url.split('/').last;
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Téléchargé: ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur téléchargement: $e')));
    }
  }
}
