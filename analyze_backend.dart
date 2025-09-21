import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  
  try {
    print("🔍 Analyzing backend architecture...");
    
    // 1. Test themes endpoint
    print("\n📋 1. Testing /themes endpoint:");
    final themesRequest = await client.getUrl(Uri.parse('https://3ilmnafi3.digilocx.fr/api/themes'));
    final themesResponse = await themesRequest.close();
    final themesBody = await themesResponse.transform(utf8.decoder).join();
    
    if (themesResponse.statusCode == 200) {
      final themes = jsonDecode(themesBody);
      print("✅ Themes found: ${themes.length}");
      if (themes.isNotEmpty) {
        print("📋 First theme structure:");
        print(JsonEncoder.withIndent('  ').convert(themes[0]));
      }
    } else {
      print("❌ Themes endpoint error: ${themesResponse.statusCode}");
    }
    
    // 2. Test subcategories endpoint (if exists)
    print("\n📂 2. Testing /subcategories endpoint:");
    try {
      final subcatRequest = await client.getUrl(Uri.parse('https://3ilmnafi3.digilocx.fr/api/subcategories'));
      final subcatResponse = await subcatRequest.close();
      final subcatBody = await subcatResponse.transform(utf8.decoder).join();
      
      print("📡 Subcategories response: ${subcatResponse.statusCode}");
      if (subcatResponse.statusCode == 200) {
        final subcats = jsonDecode(subcatBody);
        print("✅ Subcategories found: ${subcats.length}");
        if (subcats.isNotEmpty) {
          print("📂 First subcategory structure:");
          print(JsonEncoder.withIndent('  ').convert(subcats[0]));
        }
      } else {
        print("Response: $subcatBody");
      }
    } catch (e) {
      print("❌ Subcategories endpoint doesn't exist or error: $e");
    }
    
    // 3. Analyze video creation endpoint
    print("\n🎬 3. Analyzing video creation structure from existing data:");
    final videosRequest = await client.getUrl(Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos'));
    final videosResponse = await videosRequest.close();
    final videosBody = await videosResponse.transform(utf8.decoder).join();
    
    if (videosResponse.statusCode == 200) {
      final videos = jsonDecode(videosBody);
      print("📦 Total videos: ${videos.length}");
      
      // Check different video structures
      int validVideos = 0;
      int themesCount = 0;
      Set<String> allFields = {};
      
      for (var video in videos.take(10)) { // Check first 10 videos
        if (video['isValid'] == true) validVideos++;
        if (video['themes'] != null) themesCount++;
        allFields.addAll(video.keys.cast<String>());
      }
      
      print("📊 Analysis results:");
      print("  - Valid videos: $validVideos");
      print("  - Videos with themes: $themesCount");
      print("  - All fields found: ${allFields.toList()}");
      
      // Check if any video has subcategories-like fields
      bool hasSubcategories = allFields.contains('subcategories');
      bool hasCategories = allFields.contains('categories');
      bool hasTags = allFields.contains('tags');
      
      print("🔍 Related fields:");
      print("  - subcategories: $hasSubcategories");
      print("  - categories: $hasCategories");  
      print("  - tags: $hasTags");
    }
    
  } catch (e) {
    print("🚨 Exception: $e");
  } finally {
    client.close();
  }
}