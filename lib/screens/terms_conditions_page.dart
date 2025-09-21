import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
          border: Border.all(color: Color(0xFF1C8B6C), width: 1.2),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(Icons.share, color: Color(0xFF1C8B6C)),
          label: Text(
            "Partager l’application",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Partager l’application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: Icon(Icons.ios_share, color: Colors.white),
                      label: Text('App Store (iOS)', style: TextStyle(color: Colors.orange)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1C8B6C)),
                      onPressed: () {
                        Navigator.pop(context);
                        Share.share('https://apps.apple.com/fr/app/3ilmnafi3/id6742595997');
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.android, color: Colors.white),
                      label: Text('Play Store (Android)', style: TextStyle(color: Colors.orange)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1C8B6C)),
                      onPressed: () {
                        Navigator.pop(context);
                        Share.share('https://play.google.com/store/apps/details?id=com.digilocx._3ilm_nafi3');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Fond dégradé + motif marocain
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1C8B6C), Color(0xFFB2DFDB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/title.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.85),
                  BlendMode.lighten,
                ),
              ),
            ),
          ),
          // Header avec logo et animation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/logo.png", height: 32),
                  ),
                  SizedBox(width: 14),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 600),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text("À propos & Conditions"),
                  ),
                ],
              ),
            ),
          ),
          // Contenu principal avec effet glassmorphism
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                              border: Border.all(color: Color(0xFF1C8B6C), width: 1.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.flag, color: Color(0xFF1C8B6C), size: 28),
                                      SizedBox(width: 8),
                                      Text(
                                        "Notre objectif",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1C8B6C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1.2, color: Color(0xFF1C8B6C)),
                                  SizedBox(height: 10),
                                  Text(
                                    "« Élever la parole d’Allah »",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "السّلام عليكم ورحمة الله وبركاته",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    "3ilm Nafi3 est une application conçue, par la grâce d’Allah ﷻ, pour te permettre d’apprendre et surtout de mettre en pratique la science utile tirée de l’islam authentique : le Coran, la Sunna du Prophète ﷺ, selon la compréhension des pieux prédécesseurs.",
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    "Une fonctionnalité de partage de vidéos a également été mise en place pour faciliter la transmission du savoir et espérer une sadaqa jariya (صدقة جارية) in shâ’ Allah.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    "🕋 Qu’Allah nous facilite et agrée nos œuvres.",
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  Text(
                                    "Amin !",
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                              border: Border.all(color: Color(0xFF1C8B6C), width: 1.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.verified_user, color: Color(0xFF1C8B6C), size: 28),
                                      SizedBox(width: 8),
                                      Text(
                                        "Conditions",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1C8B6C),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1.2, color: Color(0xFF1C8B6C)),
                                  SizedBox(height: 12),
                                  Text(
                                    "Conditions de partage des vidéos :\n\n"
                                    "🟢 Pour que votre vidéo soit validée :\n"
                                    "• Le savant et le(s) thème(s) doivent correspondre à la vidéo\n"
                                    "• La vidéo doit durer 3 minutes maximum\n"
                                    "• Vous devez attendre la validation d’une vidéo avant d’en envoyer une autre\n\n"
                                    "🔴 Une vidéo sera refusée si :\n"
                                    "• Elle contient le visage d’un savant n’autorisant pas sa diffusion\n"
                                    "• Le savant ou le thème choisi ne correspond pas au contenu\n"
                                    "• La miniature est inappropriée",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}