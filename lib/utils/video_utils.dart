import 'package:shared_preferences/shared_preferences.dart';

Future<void> markVideoAsSeen(String videoId) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> seenVideos = prefs.getStringList('seenVideos') ?? [];
  if (!seenVideos.contains(videoId)) {
    seenVideos.add(videoId);
    await prefs.setStringList('seenVideos', seenVideos);
  }
}

Future<bool> isVideoSeen(String videoId) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> seenVideos = prefs.getStringList('seenVideos') ?? [];
  return seenVideos.contains(videoId);
}
