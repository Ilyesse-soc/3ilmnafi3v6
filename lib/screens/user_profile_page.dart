import 'package:_3ilm_nafi3/models/uploader.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';

// Modèle Palier
class Palier {
  final int seuil;
  final String nomAr;
  final String nomFr;
  final String desc;
  Palier(this.seuil, this.nomAr, this.nomFr, this.desc);
}

final List<Palier> paliers = [
  Palier(10, 'المُبتدئ (Al-Mubtadi’)', 'Le Débutant', 'Il commence à partager humblement'),
  Palier(30, 'الطَّالِب (Aṭ-Ṭālib)', 'L’Étudiant', 'Il entre sur le chemin de la science'),
  Palier(50, 'المُتَعَلِّم (Al-Mutaʿallim)', 'L’Apprenant appliqué', 'Il progresse et s’implique dans l’apprentissage'),
  Palier(70, 'السَّامِع (As-Sāmiʿ)', 'L’Auditeur attentif', 'Il écoute avec soin et réflexion'),
  Palier(100, 'المُتَفَقِّه (Al-Mutafaqqih)', 'L’Initié au fiqh', 'Il commence à comprendre les règles de la religion'),
  Palier(150, 'المُتَذَكِّر (Al-Mutadhakkir)', 'Le Rappelé', 'Il médite et applique ce qu’il a appris'),
  Palier(200, 'المُوَحِّد (Al-Muwaḥḥid)', 'Le Monothéiste', 'Il renforce son tawḥīd et s’enracine dans l’unicité d’Allah'),
  Palier(250, 'المُتَّبِع (Al-Mutābiʿ)', 'Le Suiveur de la Sunnah', 'Il imite le Prophète ﷺ dans ses actes'),
  Palier(300, 'الحَرِيص على السُّنَّة', 'Le Soucieux de la Sunnah', 'Il veille scrupuleusement à la suivre'),
  Palier(350, 'المُجْتَهِد (Al-Mujtahid)', 'L’Assidu', 'Il persévère avec sérieux et régularité'),
  Palier(400, 'الصَّابِر (Aṣ-Ṣābir)', 'Le Patient', 'Il supporte les épreuves sur le chemin d’Allah'),
  Palier(450, 'المُتَقَدِّم (Al-Mutaqaddim)', 'Le Progressant', 'Il avance avec constance vers la science'),
  Palier(500, 'الثَّابِت (Ath-Thābit)', 'Le Ferme', 'Il reste droit et solide sur la vérité'),
  Palier(550, 'النَّاصِح (An-Nāṣiḥ)', 'Le Conseiller sincère', 'Il conseille avec loyauté et bienveillance'),
  Palier(600, 'المُعِين على الخير', 'L’Aide dans le bien', 'Il soutient et encourage les autres dans le bien'),
  Palier(650, 'نَاشِر السُّنَّة', 'Le Diffuseur de la Sunnah', 'Il la transmet avec clarté et loyauté'),
  Palier(700, 'الدَّاعِي إلى الحق', 'L’Appelant à la vérité', 'Il invite à l’Islam authentique'),
  Palier(750, 'المُثَبِّت (Al-Muthabbit)', 'L’Affermisseur', 'Il renforce les autres dans leur engagement'),
  Palier(800, 'المُنَاضِل عن السُّنَّة', 'Le Défenseur de la Sunnah', 'Il la protège contre les innovations et les doutes'),
  Palier(850, 'المُقْبِل على العِلْم', 'Tourné vers la science', 'Il donne la priorité à l’apprentissage'),
  Palier(900, 'المَنْشُور بالخير', 'Répandu par le bien', 'Connu pour sa piété et sa droiture'),
  Palier(950, 'الغَالِب بالحق', 'Victorieux par la vérité', 'Il triomphe par la science et la piété'),
  Palier(1000, 'صَاحِب السُّنَّة', 'Le Compagnon de la Sunnah', 'Il s’y attache fermement et constamment'),
  Palier(1100, 'نُور السُّنَّة', 'La Lumière de la Sunnah', 'Exemple rayonnant pour les autres'),
  Palier(1500, 'عُرْوَة السُّنَّة الوُثْقَى', 'Le Pilier inébranlable', 'Niveau ultime, solide et ferme sur la voie prophétique'),
];

class UserProfilePage extends StatefulWidget {
  final Uploader user;
  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Données simulées
  List<Video> userVideos = [];
  bool isFollowing = false;
  bool followLoading = false;
  bool isLoading = false;

  void followUser() => setState(() => isFollowing = true);
  void unfollowUser() => setState(() => isFollowing = false);

  // Utilitaires progression
  Palier? _nextPalier(int score) {
    for (final p in paliers) {
      if (score < p.seuil) return p;
    }
    return null;
  }

  int _prevSeuil(int score) {
    final unlocked = paliers.where((p) => p.seuil <= score).toList();
    return unlocked.isNotEmpty ? unlocked.last.seuil : 0;
    }

  @override
  Widget build(BuildContext context) {
    final score = userVideos.length;
    final prochainPalier = _nextPalier(score);
    final seuilPrec = _prevSeuil(score);
    final seuilNext = prochainPalier?.seuil ?? paliers.last.seuil;
    final denom = (seuilNext - seuilPrec).clamp(1, 1 << 30); // éviter /0
    final progress = (score - seuilPrec) / denom;
  final palierDebloque = score >= 10;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil utilisateur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jauge de progression toujours visible en haut
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progression vers le prochain palier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: palierDebloque ? Colors.orange : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: palierDebloque ? progress.clamp(0, 1) : 0,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: palierDebloque ? Colors.orange : Colors.grey,
                ),
                const SizedBox(height: 6),
                Text(
                  palierDebloque
                      ? (prochainPalier != null
                          ? 'Prochain palier : ${prochainPalier.nomFr} ($score/${prochainPalier.seuil})'
                          : 'Tous les paliers sont débloqués !')
                      : 'Débloque le premier palier en partageant 10 vidéos.',
                  style: TextStyle(
                    fontSize: 13,
                    color: palierDebloque ? Colors.orange : Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

            const SizedBox(height: 20),

            // Nom utilisateur
            Text(
              widget.user.username.replaceAll(RegExp(r'/'), ''),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Bloc paliers
            Container(
              height: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Paliers',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: palierDebloque ? progress.clamp(0, 1) : 0,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: palierDebloque ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    palierDebloque
                        ? (prochainPalier != null
                            ? 'Prochain palier : ${prochainPalier.nomFr} ($score/${prochainPalier.seuil})'
                            : 'Tous les paliers sont débloqués !')
                        : 'Débloque le premier palier en partageant 10 vidéos.',
                    style: TextStyle(fontSize: 13, color: palierDebloque ? Colors.orange : Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paliers.length,
                      itemBuilder: (context, i) {
                        final p = paliers[i];
                        final unlocked = score >= p.seuil;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: unlocked ? Colors.orange.shade50 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: unlocked ? Colors.orange : Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                unlocked ? Icons.verified : Icons.lock_outline,
                                color: unlocked ? Colors.orange : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.nomAr,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: unlocked ? Colors.orange : Colors.grey)),
                                    Text(p.nomFr,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: unlocked ? Colors.black : Colors.grey)),
                                    Text(p.desc,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: unlocked ? Colors.black87 : Colors.grey)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${p.seuil}',
                                  style: TextStyle(
                                      fontSize: 12, color: unlocked ? Colors.orange : Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            const Text('Vidéos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Bouton ajouter utilisateur (toujours au-dessus)
            followLoading
                ? const CircularProgressIndicator(color: Colors.orange)
                : Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.person_add, color: Colors.white),
                        label: const Text('S’abonner', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        onPressed: isFollowing ? null : followUser,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.person_remove, color: Colors.white),
                        label: const Text('Se désabonner', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        onPressed: isFollowing ? unfollowUser : null,
                      ),
                    ],
                  ),

            const SizedBox(height: 12),

            // Liste vidéos
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: CircularProgressIndicator(color: Colors.orange)),
              )
            else if (userVideos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: Text('No videos uploaded yet.')),
              )
            else
              SizedBox(
                height: 400,
                child: GridView.builder(
                  itemCount: userVideos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 16 / 10, mainAxisSpacing: 8, crossAxisSpacing: 8),
                  itemBuilder: (context, i) {
                    final v = userVideos[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          v.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action à définir
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
