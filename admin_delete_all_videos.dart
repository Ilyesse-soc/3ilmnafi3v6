import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Script d'administration pour supprimer toutes les anciennes vidéos
/// ATTENTION: Cette action est irréversible!
/// 
/// Usage: dart run admin_delete_all_videos.dart

const String baseUrl = 'https://3ilmnafi3.digilocx.fr/api';

void main() async {
  print('🔥 SCRIPT DE SUPPRESSION MASSIVE DE VIDÉOS');
  print('=' * 50);
  print('⚠️  ATTENTION: Cette action supprimera TOUTES les vidéos de la base de données!');
  print('⚠️  Cette action est IRRÉVERSIBLE!');
  print('');
  
  // Demander confirmation
  stdout.write('Voulez-vous vraiment continuer? (tapez "SUPPRIMER TOUT" pour confirmer): ');
  final confirmation = stdin.readLineSync();
  
  if (confirmation != 'SUPPRIMER TOUT') {
    print('❌ Opération annulée.');
    return;
  }
  
  print('');
  print('🔍 Récupération de toutes les vidéos...');
  
  try {
    // 1. Récupérer toutes les vidéos
    final videosResponse = await http.get(
      Uri.parse('$baseUrl/videos'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (videosResponse.statusCode != 200) {
      print('❌ Erreur lors de la récupération des vidéos: ${videosResponse.statusCode}');
      return;
    }
    
    final List<dynamic> videos = jsonDecode(videosResponse.body);
    print('📊 Trouvé ${videos.length} vidéos à supprimer');
    
    if (videos.isEmpty) {
      print('✅ Aucune vidéo à supprimer');
      return;
    }
    
    // 2. Demander confirmation finale
    stdout.write('Continuer avec la suppression de ${videos.length} vidéos? (oui/non): ');
    final finalConfirm = stdin.readLineSync()?.toLowerCase();
    
    if (finalConfirm != 'oui') {
      print('❌ Opération annulée.');
      return;
    }
    
    print('');
    print('🗑️  Suppression en cours...');
    
    int deleted = 0;
    int errors = 0;
    
    // 3. Supprimer chaque vidéo
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
          print('✅ Vidéo ${i + 1}/${videos.length}: "${video['title'] ?? 'Sans titre'}" supprimée (ID: $videoId)');
        } else {
          errors++;
          print('❌ Vidéo ${i + 1}/${videos.length}: Erreur ${deleteResponse.statusCode} pour ID: $videoId');
        }
      } catch (e) {
        errors++;
        print('❌ Vidéo ${i + 1}/${videos.length}: Exception pour ID: $videoId - $e');
      }
      
      // Petit délai pour éviter de surcharger le serveur
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    print('');
    print('🎉 SUPPRESSION TERMINÉE');
    print('=' * 30);
    print('✅ Vidéos supprimées: $deleted');
    print('❌ Erreurs: $errors');
    print('📊 Total traité: ${deleted + errors}/${videos.length}');
    
  } catch (e) {
    print('❌ Erreur critique: $e');
  }
}