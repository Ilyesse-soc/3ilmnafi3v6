import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Script d'administration pour supprimer les vidéos selon des critères
/// Version plus sûre avec filtres
/// 
/// Usage: dart run admin_delete_videos_filtered.dart

const String baseUrl = 'https://3ilmnafi3.digilocx.fr/api';

void main() async {
  print('🔧 SUPPRESSION SÉLECTIVE DE VIDÉOS');
  print('=' * 40);
  
  print('Choisissez le type de suppression:');
  print('1. Supprimer toutes les vidéos NON-VALIDÉES');
  print('2. Supprimer toutes les vidéos VALIDÉES');
  print('3. Supprimer toutes les vidéos (DANGER)');
  print('4. Supprimer par plage de dates');
  print('5. Supprimer par utilisateur spécifique');
  print('0. Annuler');
  
  stdout.write('Votre choix (0-5): ');
  final choice = stdin.readLineSync();
  
  switch (choice) {
    case '1':
      await deleteByValidationStatus(false);
      break;
    case '2':
      await deleteByValidationStatus(true);
      break;
    case '3':
      await deleteAllVideos();
      break;
    case '4':
      await deleteByDateRange();
      break;
    case '5':
      await deleteByUser();
      break;
    case '0':
    default:
      print('❌ Opération annulée.');
      return;
  }
}

Future<void> deleteByValidationStatus(bool isValid) async {
  final statusText = isValid ? 'VALIDÉES' : 'NON-VALIDÉES';
  print('');
  print('🔍 Suppression des vidéos $statusText...');
  
  try {
    final videos = await fetchAllVideos();
    final filteredVideos = videos.where((v) => (v['isValid'] == true) == isValid).toList();
    
    print('📊 Trouvé ${filteredVideos.length} vidéos $statusText sur ${videos.length} total');
    
    if (filteredVideos.isEmpty) {
      print('✅ Aucune vidéo $statusText à supprimer');
      return;
    }
    
    await confirmAndDelete(filteredVideos, 'vidéos $statusText');
  } catch (e) {
    print('❌ Erreur: $e');
  }
}

Future<void> deleteAllVideos() async {
  print('');
  print('⚠️  SUPPRESSION TOTALE - TRÈS DANGEREUX!');
  stdout.write('Tapez "SUPPRIMER TOUT DEFINITIVEMENT" pour confirmer: ');
  final confirmation = stdin.readLineSync();
  
  if (confirmation != 'SUPPRIMER TOUT DEFINITIVEMENT') {
    print('❌ Opération annulée.');
    return;
  }
  
  try {
    final videos = await fetchAllVideos();
    await confirmAndDelete(videos, 'TOUTES les vidéos');
  } catch (e) {
    print('❌ Erreur: $e');
  }
}

Future<void> deleteByDateRange() async {
  print('');
  print('📅 Suppression par plage de dates');
  print('Format de date: YYYY-MM-DD (ex: 2025-01-01)');
  
  stdout.write('Date de début (laisser vide pour ignorer): ');
  final startDateStr = stdin.readLineSync();
  
  stdout.write('Date de fin (laisser vide pour ignorer): ');
  final endDateStr = stdin.readLineSync();
  
  DateTime? startDate;
  DateTime? endDate;
  
  if (startDateStr != null && startDateStr.isNotEmpty) {
    startDate = DateTime.tryParse(startDateStr);
    if (startDate == null) {
      print('❌ Date de début invalide');
      return;
    }
  }
  
  if (endDateStr != null && endDateStr.isNotEmpty) {
    endDate = DateTime.tryParse(endDateStr);
    if (endDate == null) {
      print('❌ Date de fin invalide');
      return;
    }
  }
  
  try {
    final videos = await fetchAllVideos();
    final filteredVideos = videos.where((v) {
      final createdAtStr = v['created_at']?.toString();
      if (createdAtStr == null) return false;
      
      final createdAt = DateTime.tryParse(createdAtStr);
      if (createdAt == null) return false;
      
      if (startDate != null && createdAt.isBefore(startDate)) return false;
      if (endDate != null && createdAt.isAfter(endDate)) return false;
      
      return true;
    }).toList();
    
    print('📊 Trouvé ${filteredVideos.length} vidéos dans la plage de dates');
    
    if (filteredVideos.isEmpty) {
      print('✅ Aucune vidéo dans cette plage de dates');
      return;
    }
    
    await confirmAndDelete(filteredVideos, 'vidéos dans la plage de dates');
  } catch (e) {
    print('❌ Erreur: $e');
  }
}

Future<void> deleteByUser() async {
  print('');
  stdout.write('ID de l\'utilisateur à supprimer (laisser vide pour annuler): ');
  final userId = stdin.readLineSync();
  
  if (userId == null || userId.isEmpty) {
    print('❌ Opération annulée.');
    return;
  }
  
  try {
    final videos = await fetchAllVideos();
    final filteredVideos = videos.where((v) {
      final uploader = v['uploader'];
      if (uploader is Map) {
        return uploader['id']?.toString() == userId;
      }
      return false;
    }).toList();
    
    print('📊 Trouvé ${filteredVideos.length} vidéos pour l\'utilisateur $userId');
    
    if (filteredVideos.isEmpty) {
      print('✅ Aucune vidéo trouvée pour cet utilisateur');
      return;
    }
    
    await confirmAndDelete(filteredVideos, 'vidéos de l\'utilisateur $userId');
  } catch (e) {
    print('❌ Erreur: $e');
  }
}

Future<List<dynamic>> fetchAllVideos() async {
  final response = await http.get(
    Uri.parse('$baseUrl/videos'),
    headers: {'Content-Type': 'application/json'},
  );
  
  if (response.statusCode != 200) {
    throw Exception('Erreur lors de la récupération des vidéos: ${response.statusCode}');
  }
  
  return jsonDecode(response.body) as List<dynamic>;
}

Future<void> confirmAndDelete(List<dynamic> videos, String description) async {
  print('');
  stdout.write('Confirmer la suppression de ${videos.length} $description? (oui/non): ');
  final confirm = stdin.readLineSync()?.toLowerCase();
  
  if (confirm != 'oui') {
    print('❌ Opération annulée.');
    return;
  }
  
  print('');
  print('🗑️  Suppression en cours...');
  
  int deleted = 0;
  int errors = 0;
  
  for (int i = 0; i < videos.length; i++) {
    final video = videos[i];
    final videoId = video['id']?.toString();
    
    if (videoId == null) {
      print('⚠️  Vidéo ${i + 1}: ID manquant, ignorée');
      errors++;
      continue;
    }
    
    try {
      final deleteResponse = await http.delete(
        Uri.parse('$baseUrl/videos/$videoId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (deleteResponse.statusCode == 200 || deleteResponse.statusCode == 204) {
        deleted++;
        final title = video['title']?.toString() ?? 'Sans titre';
        final status = video['isValid'] == true ? '✅' : '⏳';
        print('🗑️  ${i + 1}/${videos.length}: $status "$title" supprimée');
      } else {
        errors++;
        print('❌ Vidéo ${i + 1}/${videos.length}: Erreur ${deleteResponse.statusCode} pour ID: $videoId');
      }
    } catch (e) {
      errors++;
      print('❌ Vidéo ${i + 1}/${videos.length}: Exception pour ID: $videoId - $e');
    }
    
    // Délai pour éviter de surcharger le serveur
    await Future.delayed(Duration(milliseconds: 100));
  }
  
  print('');
  print('🎉 SUPPRESSION TERMINÉE');
  print('=' * 30);
  print('✅ Vidéos supprimées: $deleted');
  print('❌ Erreurs: $errors');
  print('📊 Total traité: ${deleted + errors}/${videos.length}');
}