import 'package:_3ilm_nafi3/constants.dart';
import 'package:_3ilm_nafi3/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class RequireProfile extends StatefulWidget {
  const RequireProfile({super.key});

  @override
  State<RequireProfile> createState() => _RequireProfileState();
}

class _RequireProfileState extends State<RequireProfile> {
  Future<bool> getUserState() async {
    final prefs = await SharedPreferences.getInstance();
    String? uID = prefs.getString("loggedID");
    return uID != null && uID.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getUserState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Une erreur s'est produite.")),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return ProfileScreen();
        } else {
          return Scaffold(
            body: Stack(
              children: [
                // 🖼 Fond calligraphique
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/title.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.9),
                        BlendMode.lighten,
                      ),
                    ),
                  ),
                ),

                // 🧱 Contenu centré
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 80, color: Color(0xFF1C8B6C)),
                        SizedBox(height: 20),
                        Text(
                          "Connexion requise",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C8B6C),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Vous devez vous connecter pour accéder à votre profil.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 16),
                        ),
                        SizedBox(height: 30),

                        // 🔵 Bouton Connexion
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/login");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1C8B6C),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          "Vous n'avez pas encore de compte ?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        SizedBox(height: 10),

                        // 🟢 Bouton Créer un compte
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/register");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1C8B6C),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Créer un compte",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
