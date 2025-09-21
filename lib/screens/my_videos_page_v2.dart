import 'package:_3ilm_nafi3/constants.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';
import '../services/video_service.dart';

/// **MyVideosPageV2** - Suivi des vidéos soumises par l'utilisateur
class MyVideosPageV2 extends StatefulWidget {
  const MyVideosPageV2({super.key});

  @override
  State<MyVideosPageV2> createState() => _MyVideosPageV2State();
}

class _MyVideosPageV2State extends State<MyVideosPageV2> 
    with SingleTickerProviderStateMixin {
  
  List<Video> userVideos = [];
  bool isLoading = true;
  String? errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserVideos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserVideos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final videos = await VideoService.getUserVideos();
      if (mounted) {
        setState(() {
          userVideos = videos;
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

  List<Video> get pendingVideos => userVideos.where((v) => !v.isValid).toList();
  List<Video> get approvedVideos => userVideos.where((v) => v.isValid).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Mes vidéos"),
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadUserVideos,
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
              text: "Toutes (${userVideos.length})",
              icon: const Icon(Icons.video_library),
            ),
            Tab(
              text: "En attente (${pendingVideos.length})",
              icon: const Icon(Icons.pending_actions),
            ),
            Tab(
              text: "Validées (${approvedVideos.length})",
              icon: const Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideosList(userVideos, showAll: true),
          _buildVideosList(pendingVideos, isPending: true),
          _buildVideosList(approvedVideos, isApproved: true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation vers l'écran d'upload
          Navigator.pushNamed(context, '/upload').then((_) => _loadUserVideos());
        },
        icon: const Icon(Icons.add),
        label: const Text("Nouvelle vidéo"),
        backgroundColor: green,
      ),
    );
  }

  Widget _buildVideosList(List<Video> videos, {
    bool showAll = false, 
    bool isPending = false, 
    bool isApproved = false
  }) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Chargement de vos vidéos..."),
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
                  onPressed: _loadUserVideos,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Réessayer"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (videos.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPending ? Icons.pending_actions :
                  isApproved ? Icons.check_circle : Icons.video_library,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _getEmptyMessage(isPending, isApproved),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Commencez par soumettre votre première vidéo !",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/upload').then((_) => _loadUserVideos());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter une vidéo"),
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUserVideos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) => _buildVideoCard(videos[index]),
      ),
    );
  }

  String _getEmptyMessage(bool isPending, bool isApproved) {
    if (isPending) return "Aucune vidéo en attente";
    if (isApproved) return "Aucune vidéo validée";
    return "Aucune vidéo";
  }

  Widget _buildVideoCard(Video video) {
    final statusColor = video.isValid ? Colors.green : Colors.orange;
    final statusText = video.isValid ? "VALIDÉE" : "EN ATTENTE";
    final statusIcon = video.isValid ? Icons.check_circle : Icons.pending_actions;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec statut
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (video.isValid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.thumb_up, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          "${video.likesCount}",
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Contenu principal
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
                    child: video.imageUrl != null
                        ? Image.network(
                            video.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                ),
                const SizedBox(width: 16),

                // Informations
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      _buildInfoRow(Icons.category, _getThemesText(video)),
                      _buildInfoRow(Icons.person, video.ref ?? "Non spécifié"),
                      
                      const SizedBox(height: 12),

                      // Message d'encouragement selon le statut
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              video.isValid ? Icons.celebration : Icons.hourglass_empty,
                              color: statusColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                video.isValid 
                                  ? "Alhamdulillah ! Vidéo publiée"
                                  : "En cours de validation...",
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          if (video.isValid)
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
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Naviguer vers la vidéo publiée
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Redirection vers la vidéo..."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Voir la vidéo"),
                      style: OutlinedButton.styleFrom(foregroundColor: green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Partager la vidéo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fonctionnalité de partage à venir..."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Partager"),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getThemesText(Video video) {
    if (video.themes.isEmpty) return "Aucun thème";
    return video.themes.map((t) => t['name'] ?? 'Inconnu').join(", ");
  }
}