import 'package:flutter/material.dart';

import '../utils/subcategory_encoder.dart';
import '../widgets/robust_network_image.dart';

class Video {
  final String id;
  final String title;
  final String? imageUrl;
  final int likesCount;
  final String? videoUrl; // Rendu nullable pour éviter les erreurs
  final Map<String, dynamic> uploader;
  final String? ref;
  final bool isValid;
  final List<Map<String, dynamic>> themes;
  final List<String> subcategories;

  Video({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.likesCount,
    required this.videoUrl,
    required this.uploader,
    this.ref,
    required this.isValid,
    required this.themes,
    required this.subcategories,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final rawReference = json['reference'] ?? '';
    List<String> subcategories = [];
    String cleanReference = rawReference;
    
    try {
      // Essayer de décoder les sous-catégories du champ reference
      final decodedData = SubcategoryEncoder.decodeFromReference(rawReference);
      subcategories = decodedData['subcategories'] as List<String>;
      cleanReference = decodedData['reference'] as String;
      
      if (subcategories.isNotEmpty) {
        debugPrint('🔍 Sous-catégories décodées: $subcategories');
      }
    } catch (e) {
      // Si le décodage échoue, c'est probablement juste un nom d'intervenant
      // debugPrint('⚠️ Pas de sous-catégories encodées dans reference: $rawReference');
      subcategories = []; // Vide par défaut
      cleanReference = rawReference;
    }
    
    // Vérifier s'il y a des sous-catégories directement dans la réponse API
    if (json['subcategories'] != null) {
      try {
        subcategories = List<String>.from(json['subcategories']);
        debugPrint('✅ Sous-catégories depuis API: $subcategories');
      } catch (e) {
        debugPrint('❌ Erreur parsing subcategories API: $e');
      }
    }
    
    return Video(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      likesCount: json['likesCount'] ?? 0,
      videoUrl: json['videoUrl']?.toString(), // Reste nullable
      uploader: json['uploader'] ?? {},
      ref: cleanReference,
      isValid: json['isValid'] == true,
      themes: (json['themes'] as List<dynamic>? ?? [])
          .map((t) => Map<String, dynamic>.from(t))
          .toList(),
      subcategories: subcategories,
    );
  }

  Map<String, dynamic> toJson() {
    // Encoder les sous-catégories dans le champ reference pour la compatibilité
    final encodedReference = SubcategoryEncoder.encodeWithReference(ref ?? '', subcategories);
    
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'videoUrl': videoUrl,
      'uploader': uploader,
      'reference': encodedReference, // Reference avec sous-catégories encodées
      'isValid': isValid,
      'themes': themes,
      'subcategories': subcategories, // Gardé pour compatibilité frontend
    };
  }
}

class VideoWidget extends StatelessWidget {
  final Video video;

  const VideoWidget({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(video.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: RobustNetworkImage(
            imageUrl: video.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${video.likesCount} likes', style: TextStyle(color: Colors.grey)),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Action pour le bouton plus d'options
              },
            ),
          ],
        ),
      ],
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final String profilePic;

  const UserProfileWidget({Key? key, required this.profilePic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage:
          profilePic != "0"
              ? AssetImage(
                  "assets/images/profiles/profile${profilePic}.PNG",
                )
              : null,
      child: profilePic == "0"
          ? Icon(Icons.person, color: Colors.white)
          : null,
    );
  }
}
