// profile_screen.dart

import 'dart:convert';

import 'package:_3ilm_nafi3/constants.dart'; // expose `green`
import 'package:_3ilm_nafi3/models/user.dart';
import 'package:_3ilm_nafi3/screens/myvideos.dart';
import 'package:_3ilm_nafi3/screens/splash_screen.dart';
import 'package:_3ilm_nafi3/screens/upload_page_v2.dart';
import 'package:_3ilm_nafi3/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// -------------------- Modèle Palier --------------------
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

// -------------------- API helpers --------------------
Future<User?> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users/$userID');
  final res = await http.get(url);
  if (res.statusCode == 200) return User.fromJson(json.decode(res.body));
  throw Exception('Failed to load user data');
}

Future<Map<String, int>> fetchUserStats() async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users/$userID/stats');
  final res = await http.get(url);
  if (res.statusCode == 200) {
    final jsonBody = json.decode(res.body) as Map<String, dynamic>;
    return {
      'likes': jsonBody['likes'] ?? 0,
      'followers': jsonBody['followers'] ?? 0,
      'following': jsonBody['following'] ?? 0,
    };
  }
  return {'likes': 0, 'followers': 0, 'following': 0};
}

Future<Map<String, dynamic>> sendAddRequest(String targetUsername) async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  if (userID == null || userID.isEmpty) {
    return {'success': false, 'message': 'Veuillez vous connecter.'};
  }
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/follow/request');
  try {
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'from': userID, 'to_username': targetUsername}),
    );
    final body = res.body.isNotEmpty ? res.body : '${res.statusCode}';
    return {'success': res.statusCode == 200 || res.statusCode == 201, 'message': body};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

Future<Map<String, dynamic>> followUserApi(String targetUsername) async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  if (userID == null || userID.isEmpty) {
    return {'success': false, 'message': 'Veuillez vous connecter.'};
  }
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/follow');
  try {
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'from': userID, 'to_username': targetUsername}),
    );
    final body = res.body.isNotEmpty ? res.body : '${res.statusCode}';
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        await http.post(
          Uri.parse('https://3ilmnafi3.digilocx.fr/api/notify/follow'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'from': userID, 'to_username': targetUsername}),
        );
      } catch (_) {}
      return {'success': true, 'message': body};
    }
    return {'success': false, 'message': body};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

Future<Map<String, dynamic>> unfollowUserApi(String targetUsername) async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  if (userID == null || userID.isEmpty) {
    return {'success': false, 'message': 'Veuillez vous connecter.'};
  }
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/unfollow');
  try {
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'from': userID, 'to_username': targetUsername}),
    );
    final body = res.body.isNotEmpty ? res.body : '${res.statusCode}';
    return {'success': res.statusCode == 200 || res.statusCode == 204, 'message': body};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

Future<void> updatePic(String username, String password, String newPic, String isAdmin) async {
  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString("loggedID");
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users/$userID');
  final body = isAdmin == "admin"
      ? jsonEncode({'username': '$username;$password;$newPic;$isAdmin'})
      : jsonEncode({'username': '$username;$password;$newPic'});
  await http.put(url, headers: {'Content-Type': 'application/json'}, body: body);
}

Future<void> deleteAcc(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final uID = prefs.getString("loggedID");
  final res = await http.delete(Uri.parse("https://3ilmnafi3.digilocx.fr/api/users/$uID"));
  if (res.statusCode == 200) {
    await prefs.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => SplashScreen()),
      (_) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compte supprimé')));
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Suppression impossible')));
  }
}

// -------------------- UI --------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;
  late Future<Map<String, int>> _statsFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserData();
    _statsFuture = fetchUserStats();
  }

  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF133434))),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  Future<void> _pickVideo() async {
    final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (!mounted) return;
    if (picked != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => UploadPageV2(videoPath: picked.path)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune vidéo sélectionnée')));
    }
  }

  void _selectProfilePicture(String u, String p, String a) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Changer la photo de profil"),
          content: SizedBox(
            height: 280,
            width: double.maxFinite,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12,
              ),
              itemCount: 35,
              itemBuilder: (context, index) {
                final id = '${index + 1}';
                return InkWell(
                  onTap: () async {
                    final selected = id == '35' ? '0' : id;
                    await updatePic(u, p, selected, a);
                    if (!mounted) return;
                    Navigator.pop(context);
                    setState(() => _userFuture = fetchUserData());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo mise à jour')));
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profiles/profile${index + 1}.PNG'),
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
        );
      },
    );
  }

  Widget _greenButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _infoField({required IconData icon, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF133434))),
        const SizedBox(height: 8),
        TextField(
          enabled: false,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF133434)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/title.png',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.93),
              colorBlendMode: BlendMode.lighten,
            ),
          ),
          Center(
            child: FutureBuilder<User?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: green);
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 8))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('Service indisponible.\nDéconnectez-vous puis réessayez.', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          _greenButton(
                            icon: Icons.logout_rounded,
                            label: 'Se déconnecter',
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove("loggedID");
                              if (!mounted) return;
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Text('Aucun utilisateur trouvé.');
                }

                final user = snapshot.data!;
                final parts = user.username.split(";");
                final uname = parts.isNotEmpty ? parts[0].replaceAll(RegExp(r'/'), '') : '';
                final pwd = parts.length > 1 ? parts[1] : '';
                final pic = parts.length > 2 ? parts[2] : '0';
                final role = parts.length > 3 ? parts[3] : '';

                // Score à adapter: nombre de vidéos, etc.
                final int score = 0;
                Palier? prochainPalier;
                int seuilPrec = 0;
                for (final p in paliers) {
                  if (score < p.seuil) {
                    prochainPalier = p;
                    break;
                  }
                  seuilPrec = p.seuil;
                }
                final int seuilNext = prochainPalier?.seuil ?? paliers.last.seuil;
                final int denom = (seuilNext - seuilPrec).clamp(1, 1 << 30);
                final double progress = (score - seuilPrec) / denom;
                final bool palierDebloque = score >= 10;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 8))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Jauge
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Progression vers le prochain palier',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: palierDebloque ? Colors.orange : Colors.grey)),
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
                            const SizedBox(height: 16),
                          ],
                        ),

                        // Paliers list
                        SizedBox(
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
                                          Icon(unlocked ? Icons.verified : Icons.lock_outline,
                                              color: unlocked ? Colors.orange : Colors.grey),
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
                                              style: TextStyle(fontSize: 12, color: unlocked ? Colors.orange : Colors.grey)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Logo / titre
                        Image.asset('assets/images/transparent.jpg', height: 90),
                        const SizedBox(height: 16),
                        const Text('Mon Profil',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF133434))),
                        const SizedBox(height: 20),

                        // Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: green, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.white,
                                child: pic != "0"
                                    ? ClipOval(
                                        child: Image.asset(
                                          "assets/images/small_profiles/profile$pic.PNG",
                                          width: 92, height: 92, fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.person, color: Color(0xFF133434), size: 48),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              child: IconButton(
                                tooltip: 'Modifier',
                                icon: Icon(Icons.edit, color: green, size: 20),
                                onPressed: () => _selectProfilePicture(uname, pwd, role),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Stats
                        FutureBuilder<Map<String, int>>(
                          future: _statsFuture,
                          builder: (context, snapshotStats) {
                            final stats = snapshotStats.data ?? {'likes': 0, 'followers': 0, 'following': 0};
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statItem('Likes', stats['likes'] ?? 0),
                                _statItem('Abonnés', stats['followers'] ?? 0),
                                _statItem('Abonnements', stats['following'] ?? 0),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        _infoField(icon: Icons.person, label: "Nom d'utilisateur", value: uname),
                        const SizedBox(height: 16),

                        _greenButton(
                          icon: Icons.videocam,
                          label: 'Mes vidéos',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyVideosPage())),
                        ),
                        const SizedBox(height: 12),

                        // Ajouter un utilisateur
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final controller = TextEditingController();
                              final action = await showDialog<String?>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Ajouter un utilisateur'),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(hintText: 'Nom d\'utilisateur cible'),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Annuler')),
                                    TextButton(onPressed: () => Navigator.pop(context, 'request'), child: const Text('Envoyer demande')),
                                    TextButton(onPressed: () => Navigator.pop(context, 'follow'), child: const Text('Suivre maintenant')),
                                  ],
                                ),
                              );
                              if (!mounted) return;
                              if (action != null && controller.text.trim().isNotEmpty) {
                                final target = controller.text.trim();
                                if (action == 'request') {
                                  final res = await sendAddRequest(target);
                                  if (res['success'] == true) {
                                    await NotificationService.showFriendRequestNotification(target);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demande envoyée à $target')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible: ${res['message']}')));
                                  }
                                } else if (action == 'follow') {
                                  final res = await followUserApi(target);
                                  if (res['success'] == true) {
                                    await NotificationService.showFollowNotification(target);
                                    setState(() => _statsFuture = fetchUserStats());
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vous suivez maintenant $target')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible: ${res['message']}')));
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.person_add, color: Colors.white),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Ajouter un utilisateur', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              minimumSize: const Size(double.infinity, 50),
                              elevation: 0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Se désabonner
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final controller = TextEditingController();
                              final ok = await showDialog<bool?>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Se désabonner'),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(hintText: 'Nom d\'utilisateur à désabonner'),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Désabonner')),
                                  ],
                                ),
                              );
                              if (!mounted) return;
                              if (ok == true && controller.text.trim().isNotEmpty) {
                                final target = controller.text.trim();
                                final res = await unfollowUserApi(target);
                                if (res['success'] == true) {
                                  setState(() => _statsFuture = fetchUserStats());
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Désabonné de $target')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible: ${res['message']}')));
                                }
                              }
                            },
                            icon: const Icon(Icons.person_off, color: Colors.white),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Se désabonner', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              minimumSize: const Size(double.infinity, 50),
                              elevation: 0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Uploader une vidéo
                        _greenButton(icon: Icons.file_upload, label: 'Uploader une vidéo', onTap: _pickVideo),

                        const SizedBox(height: 12),

                        // Déconnexion et suppression
                        _greenButton(
                          icon: Icons.logout_rounded,
                          label: 'Se déconnecter',
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove("loggedID");
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                        ),
                        const SizedBox(height: 12),
                        _greenButton(
                          icon: Icons.delete_forever,
                          label: 'Supprimer mon compte',
                          onTap: () => deleteAcc(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
