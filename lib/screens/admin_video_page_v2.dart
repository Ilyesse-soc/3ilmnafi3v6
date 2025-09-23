import 'package:_3ilm_nafi3/constants.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';
import '../services/video_service.dart';
import '../widgets/robust_network_image.dart';
import '../widgets/video_submission_info_widget.dart';
import 'admin_video_details_page.dart';

/// **AdminVideoPageV2** - Tableau de bord admin amélioré
class AdminVideoPageV2 extends StatefulWidget {
  const AdminVideoPageV2({super.key});

  @override
  State<AdminVideoPageV2> createState() => _AdminVideoPageV2State();
}

class _AdminVideoPageV2State extends State<AdminVideoPageV2> 
    with SingleTickerProviderStateMixin {
  
  List<Video> pendingVideos = [];
  bool isLoading = true;
  String? errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPendingVideos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPendingVideos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final videos = await VideoService.getPendingVideos();
      if (mounted) {
        setState(() {
          pendingVideos = videos;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Erreur lors du chargement: $e";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleVideoAction(String videoId, bool approve, {String? reason}) async {
    // Afficher un loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Traitement en cours..."),
              ],
            ),
          ),
        ),
      ),
    );

    bool success = false;
    try {
      if (approve) {
        success = await VideoService.approveVideo(videoId, adminMessage: reason);
      } else {
        success = await VideoService.rejectVideo(videoId, reason: reason);
      }
      
      if (mounted) Navigator.pop(context); // Fermer le loader
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              approve ? '✅ Vidéo validée avec succès' : '❌ Vidéo refusée',
            ),
            backgroundColor: approve ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Recharger la liste
        await _loadPendingVideos();
      } else {
        _showErrorDialog("Échec de l'opération. Veuillez réessayer.");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorDialog("Erreur: $e");
    }
  }

  void _showApprovalDialog(Video video) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Valider la vidéo"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titre: ${video.title}"),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Message de validation (optionnel)",
                hintText: "Ex: MashAllah, excellente vidéo !",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _handleVideoAction(
                video.id, 
                true, 
                reason: messageController.text.trim(),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text("Valider"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(Video video) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text("Refuser la vidéo"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titre: ${video.title}"),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Raison du refus *",
                hintText: "Ex: Contenu non conforme aux critères",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Veuillez indiquer une raison"),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _handleVideoAction(video.id, false, reason: reason);
            },
            icon: const Icon(Icons.close),
            label: const Text("Refuser"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text("Erreur"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Administration - Validation vidéos"),
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadPendingVideos,
            icon: const Icon(Icons.refresh),
            tooltip: "Actualiser",
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: "En attente (${pendingVideos.length})",
              icon: const Icon(Icons.pending_actions),
            ),
            const Tab(
              text: "Statistiques",
              icon: Icon(Icons.analytics),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingVideosTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildPendingVideosTab() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Chargement des vidéos..."),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadPendingVideos,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Réessayer"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (pendingVideos.isEmpty) {
      return const Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  "Aucune vidéo en attente",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Toutes les vidéos ont été traitées !",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingVideos,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Widgets informatifs en haut
          const VideoSubmissionInfoWidget(),
          const DevTestingWidget(),
          const SizedBox(height: 8),
          
          // Liste des vidéos
          ...pendingVideos.map((video) => _buildVideoCard(video)).toList(),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et uploader
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Uploader: ${(video.uploader['username'] ?? 'Inconnu').toString().split(';')[0]}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "EN ATTENTE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal avec image et métadonnées
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image de couverture
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
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
                const SizedBox(width: 16),

                // Métadonnées
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetadataRow("Thèmes", _getThemesText(video)),
                      _buildMetadataRow("Sous-catégories", _getSubcategoriesText(video)),
                      _buildMetadataRow("Intervenant", video.ref ?? "Non spécifié"),
                      const SizedBox(height: 12),
                      
                      // Bouton pour voir les détails
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminVideoDetailsPage(video: video),
                          ),
                        ),
                        icon: const Icon(Icons.visibility),
                        label: const Text("Voir détails"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions d'approbation/refus
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApprovalDialog(video),
                    icon: const Icon(Icons.check),
                    label: const Text("Valider"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRejectionDialog(video),
                    icon: const Icon(Icons.close),
                    label: const Text("Refuser"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemesText(Video video) {
    if (video.themes.isEmpty) return "Aucun";
    return video.themes.map((t) => t['name'] ?? 'Inconnu').join(", ");
  }

  String _getSubcategoriesText(Video video) {
    if (video.subcategories.isEmpty) return "Aucune";
    return video.subcategories.join(", ");
  }

  Widget _buildStatsTab() {
    return const Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics, size: 48),
              SizedBox(height: 16),
              Text(
                "Statistiques",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Fonctionnalité à venir..."),
            ],
          ),
        ),
      ),
    );
  }
}