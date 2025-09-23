import 'package:flutter/material.dart';

/// Widget pour afficher des images avec gestion d'erreurs robuste
class RobustNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  
  const RobustNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si pas d'URL, afficher directement le placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorPlaceholder(context, 'Aucune image');
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      
      // Widget pendant le chargement
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _buildLoadingPlaceholder(context);
      },
      
      // Widget en cas d'erreur
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Erreur image pour ${_getVideoTitle(imageUrl!)}: $error');
        
        // Essayer de déterminer le type d'erreur
        String errorMessage = 'Image indisponible';
        if (error.toString().contains('404')) {
          errorMessage = 'Image non trouvée';
        } else if (error.toString().contains('403')) {
          errorMessage = 'Accès refusé';
        } else if (error.toString().contains('timeout')) {
          errorMessage = 'Délai dépassé';
        }
        
        return errorWidget ?? _buildErrorPlaceholder(context, errorMessage);
      },
    );
  }

  /// Widget affiché pendant le chargement
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 8),
            Text(
              'Chargement...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget affiché en cas d'erreur
  Widget _buildErrorPlaceholder(BuildContext context, String message) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '🖼️',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  /// Extraire le titre de la vidéo depuis l'URL (heuristique)
  String _getVideoTitle(String url) {
    try {
      // Extraire le nom du fichier
      final uri = Uri.parse(url);
      final filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'Inconnue';
      
      // Simplifier le nom
      if (filename.contains('image_picker_')) {
        return 'Image uploadée';
      }
      
      return filename.split('.').first;
    } catch (e) {
      return 'Image inconnue';
    }
  }
}