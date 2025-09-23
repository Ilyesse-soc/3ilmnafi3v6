import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/video.dart';
import '../utils/subcategory_encoder.dart';
import 'notification_service.dart';
import 'subcategory_api_service.dart';

enum VideoStatus {
  pending,    // En attente de validation
  approved,   // Validée par l'admin
  rejected,   // Refusée par l'admin
}

class VideoSubmissionResult {
  final bool success;
  final String message;
  final String? videoId;

  VideoSubmissionResult({
    required this.success,
    required this.message,
    this.videoId,
  });
}

class VideoService {
  static const String baseUrl = 'https://3ilmnafi3.digilocx.fr/api';
  static const Duration timeout = Duration(seconds: 30);

  // ============================================================================
  // GESTION DES SOUS-CATÉGORIES VIA API
  // ============================================================================

  /// Récupère toutes les sous-catégories depuis l'API
  static Future<List<Map<String, dynamic>>> getAllSubcategories() async {
    try {
      debugPrint('🔗 Récupération des sous-catégories depuis l\'API...');
      return await SubcategoryApiService.getAllSubcategories();
    } catch (e) {
      debugPrint('❌ Erreur récupération sous-catégories: $e');
      return [];
    }
  }

  /// Récupère les sous-catégories d'un thème spécifique
  static Future<List<Map<String, dynamic>>> getSubcategoriesByTheme(int themeId) async {
    try {
      debugPrint('🔗 Récupération des sous-catégories pour le thème $themeId...');
      return await SubcategoryApiService.getSubcategoriesByTheme(themeId);
    } catch (e) {
      debugPrint('❌ Erreur récupération sous-catégories par thème: $e');
      return [];
    }
  }

  /// Récupère les sous-catégories et les convertit en format compatible avec l'encodeur
  static Future<Map<int, List<String>>> getSubcategoriesForEncoder() async {
    try {
      final allSubcategories = await getAllSubcategories();
      Map<int, List<String>> subcategoriesByTheme = {};
      
      for (var subcategory in allSubcategories) {
        final themeId = subcategory['themeId'] as int;
        final name = subcategory['name'] as String;
        
        if (!subcategoriesByTheme.containsKey(themeId)) {
          subcategoriesByTheme[themeId] = [];
        }
        subcategoriesByTheme[themeId]!.add(name);
      }
      
      debugPrint('📊 Sous-catégories groupées par thème: ${subcategoriesByTheme.keys.length} thèmes');
      return subcategoriesByTheme;
    } catch (e) {
      debugPrint('❌ Erreur conversion sous-catégories: $e');
      return {};
    }
  }

  // Test de l'API des sous-catégories
  static Future<void> testSubcategoryAPI() async {
    print('🧪 === TEST API SOUS-CATÉGORIES ===');
    
    try {
      // Test connexion
      bool connected = await SubcategoryApiService.testConnection();
      print('Connexion API: ${connected ? "✅" : "❌"}');
      
      if (connected) {
        // Test récupération sous-catégories
        List<Map<String, dynamic>> subcategories = await getAllSubcategories();
        print('Sous-catégories récupérées: ${subcategories.length}');
        
        // Afficher quelques exemples
        if (subcategories.isNotEmpty) {
          print('Exemples:');
          for (int i = 0; i < 3 && i < subcategories.length; i++) {
            print('  - ${subcategories[i]['name']} (Thème ${subcategories[i]['themeId']})');
          }
        }
        
        // Test format pour encodeur
        final subcategoriesForEncoder = await getSubcategoriesForEncoder();
        print('Format encodeur: ${subcategoriesForEncoder.keys.length} thèmes');
      }
    } catch (e) {
      print('❌ Erreur test API: $e');
    }
    
    print('🧪 === FIN TEST ===');
  }

  // ============================================================================
  // SOUMISSION DE VIDÉO PAR L'UTILISATEUR
  // ============================================================================

  /// Vérifie si l'utilisateur peut soumettre une nouvelle vidéo
  static Future<bool> canSubmitNewVideo() async {
    try {
      final userVideos = await getUserVideos();
      final pendingVideos = userVideos.where((v) => !v.isValid).toList();
      return pendingVideos.isEmpty;
    } catch (e) {
      debugPrint("❌ Erreur canSubmitNewVideo: $e");
      return false;
    }
  }

  /// Soumet une nouvelle vidéo avec tous les métadonnées
  static Future<VideoSubmissionResult> submitVideo({
    required String title,
    required String videoPath,
    required String imagePath,
    required List<String> themeIds,
    required List<String> subcategories,
    required String reference,
  }) async {
    try {
      // Vérifier la session utilisateur
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("loggedID");
      
      if (userId == null || userId.isEmpty) {
        return VideoSubmissionResult(
          success: false,
          message: "Session expirée. Veuillez vous reconnecter.",
        );
      }

      // 1. Upload de l'image de couverture
      debugPrint("🖼️ Upload de l'image...");
      final imageUrl = await _uploadImage(imagePath);
      if (imageUrl == null) {
        return VideoSubmissionResult(
          success: false,
          message: "Échec du téléversement de l'image de couverture.",
        );
      }

      // 2. Upload de la vidéo
      debugPrint("📹 Upload de la vidéo...");
      final videoUrl = await _uploadVideo(videoPath);
      if (videoUrl == null) {
        return VideoSubmissionResult(
          success: false,
          message: "Échec du téléversement de la vidéo.",
        );
      }

      // 3. Création de l'entrée vidéo dans la base
      debugPrint("💾 Création de l'entrée vidéo...");
      final videoId = await _createVideoEntry(
        title: title,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        uploaderId: userId,
        themeIds: themeIds,
        subcategories: subcategories,
        reference: reference,
      );

      if (videoId == null) {
        return VideoSubmissionResult(
          success: false,
          message: "Échec de l'enregistrement des métadonnées.",
        );
      }

      // Succès !
      await NotificationService.showSubmissionNotification();
      
      return VideoSubmissionResult(
        success: true,
        message: "Vidéo soumise avec succès ! Elle sera examinée par notre équipe.",
        videoId: videoId,
      );

    } catch (e) {
      debugPrint("❌ Erreur submitVideo: $e");
      return VideoSubmissionResult(
        success: false,
        message: "Erreur inattendue: ${e.toString()}",
      );
    }
  }

  // ============================================================================
  // GESTION ADMIN DES VIDÉOS
  // ============================================================================

  /// Récupère toutes les vidéos en attente de validation
  static Future<List<Video>> getPendingVideos() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/videos?status=pending'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data
            .map((v) => Video.fromJson(v))
            .where((v) => !v.isValid) // Filtrer les non-validées
            .toList();
      } else {
        debugPrint("❌ Erreur getPendingVideos: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Exception getPendingVideos: $e");
      return [];
    }
  }

  /// Approuve une vidéo (admin)
  static Future<bool> approveVideo(String videoId, {String? adminMessage}) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/videos/$videoId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'isValid': true,
              'approvedAt': DateTime.now().toIso8601String(),
              'adminMessage': adminMessage,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        // Notifier l'utilisateur de l'approbation
        await NotificationService.showValidationNotification(
          true,
          customMessage: adminMessage ?? "✅ Votre vidéo a été validée alhamdulillah !",
        );
        return true;
      } else {
        debugPrint("❌ Erreur approveVideo: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception approveVideo: $e");
      return false;
    }
  }

  /// Rejette une vidéo (admin)
  static Future<bool> rejectVideo(String videoId, {String? reason}) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/videos/$videoId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'reason': reason,
              'rejectedAt': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        // Notifier l'utilisateur du refus
        await NotificationService.showValidationNotification(
          false,
          customMessage: reason ?? "❌ Votre vidéo ne respecte pas nos critères.",
        );
        return true;
      } else {
        debugPrint("❌ Erreur rejectVideo: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception rejectVideo: $e");
      return false;
    }
  }

  // ============================================================================
  // MÉTHODES PRIVÉES D'UPLOAD
  // ============================================================================

  static Future<String?> _uploadImage(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      debugPrint("❌ Fichier image introuvable: $filePath");
      return null;
    }

    try {
      final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/upload-media'));
      
      req.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filePath,
          contentType: _getImageMediaType(filePath),
        ),
      );

      final streamedResponse = await req.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Upload image réussi: ${response.statusCode}");
        return data['data']?['image'] as String?;
      } else {
        debugPrint("❌ Upload image échec: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Exception _uploadImage: $e");
      return null;
    }
  }

  static Future<String?> _uploadVideo(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      debugPrint("❌ Fichier vidéo introuvable: $filePath");
      return null;
    }

    try {
      final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/upload-media'));
      
      req.files.add(
        await http.MultipartFile.fromPath(
          'video',
          filePath,
          contentType: MediaType('video', 'mp4'),
        ),
      );

      final streamedResponse = await req.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Upload vidéo réussi: ${response.statusCode}");
        return data['data']?['video'] as String?;
      } else {
        debugPrint("❌ Upload vidéo échec: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Exception _uploadVideo: $e");
      return null;
    }
  }

  static Future<String?> _createVideoEntry({
    required String title,
    required String videoUrl,
    required String imageUrl,
    required String uploaderId,
    required List<String> themeIds,
    required List<String> subcategories,
    required String reference,
  }) async {
    try {
      // Encoder les sous-catégories dans le champ reference
      final encodedReference = SubcategoryEncoder.encodeWithReference(reference, subcategories);
      
      final bodyData = {
        'title': title,
        'videoUrl': videoUrl,
        'imageUrl': imageUrl,
        'uploaderId': uploaderId,
        'themes': themeIds,
        // Ne plus envoyer subcategories car non supporté par le backend
        // 'subcategories': subcategories,
        'reference': encodedReference, // Reference avec sous-catégories encodées
        'isValid': false,
        'submittedAt': DateTime.now().toIso8601String(),
      };
      
      final bodyJson = jsonEncode(bodyData);
      
      // Debug détaillé
      debugPrint("📤 Envoi vers /api/videos:");
      debugPrint("   - Titre: $title");
      debugPrint("   - Thèmes IDs: $themeIds");
      debugPrint("   - Sous-catégories: $subcategories");
      debugPrint("   - Intervenant: $reference");
      debugPrint("   - Reference encodée: $encodedReference");
      debugPrint("📤 Body complet: $bodyJson");
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/videos'),
            headers: {'Content-Type': 'application/json'},
            body: bodyJson,
          )
          .timeout(timeout);

      debugPrint("📥 Réponse API (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Vérifier si les sous-catégories ont été encodées correctement
        final videoData = data['video'] ?? data;
        final returnedReference = videoData['reference'] ?? '';
        final decodedData = SubcategoryEncoder.decodeFromReference(returnedReference);
        debugPrint("✅ Sous-catégories encodées dans reference: ${decodedData['subcategories']}");
        debugPrint("✅ Reference décodée: ${decodedData['reference']}");
        
        return data['video']?['id']?.toString() ?? data['id']?.toString();
      } else {
        debugPrint("❌ Création vidéo échec: ${response.statusCode} ${response.body}");
        
        // Gestion spécifique de l'erreur "vidéo précédente non validée"
        if (response.statusCode == 400) {
          final errorData = jsonDecode(response.body);
          final message = errorData['message'] ?? '';
          if (message.contains('until the last one is validated')) {
            throw Exception(
              'Vous devez attendre que votre vidéo précédente soit validée avant d\'en soumettre une nouvelle.'
            );
          }
          throw Exception(message.isNotEmpty ? message : 'Erreur de validation des données');
        }
        
        return null;
      }
    } catch (e) {
      debugPrint("❌ Exception _createVideoEntry: $e");
      return null;
    }
  }

  static MediaType _getImageMediaType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return MediaType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  // ============================================================================
  // UTILITAIRES
  // ============================================================================

  /// Récupère les vidéos de l'utilisateur connecté
  static Future<List<Video>> getUserVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("loggedID");
      
      if (userId == null) return [];

      final response = await http
          .get(
            Uri.parse('$baseUrl/videos?uploaderId=$userId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((v) => Video.fromJson(v)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ Exception getUserVideos: $e");
      return [];
    }
  }

  /// Vérifie si l'utilisateur est admin
  static Future<bool> isUserAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool("isAdmin") ?? false;
    } catch (e) {
      return false;
    }
  }
}