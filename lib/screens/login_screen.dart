// ✅ Page de connexion 

import 'dart:convert';

import 'package:_3ilm_nafi3/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  Future<void> saveValues(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("loggedID", user["id"].toString());
    await prefs.setString("admin", user["username"].toString().contains("admin") ? "yes" : "no");
    if (user["username"] != null) await prefs.setString("username", user["username"].toString());
    if (user["email"] != null) await prefs.setString("email", user["email"].toString());
    if (user["profilePic"] != null) await prefs.setString("profilePic", user["profilePic"].toString());
    if (user["userRole"] != null) await prefs.setString("userRole", user["userRole"].toString());
  }

  void _login(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    // Vider d'abord toute session existante
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Nettoie complètement les préférences

    // Afficher loading indicator simple
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users');
      final response = await http.get(url).timeout(Duration(seconds: 15)); // Timeout plus long
      
      // Vérifier la réponse HTTP
      if (response.statusCode != 200) {
        if (!mounted) return;
        Navigator.pop(context); // Fermer loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur serveur: ${response.statusCode}. Vérifiez votre connexion.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      var data = jsonDecode(response.body);
      
      // Vérifier que data est une liste
      if (data == null || data is! List) {
        if (!mounted) return;
        Navigator.pop(context); // Fermer loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur: format de données invalide du serveur.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      var loggedUser;
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      
      // Debug: afficher le nombre d'utilisateurs
      print('🔍 Nombre d\'utilisateurs dans la base: ${data.length}');
      print('🔍 Recherche pour: "$username" / "$password"');
      
      for (var element in data) {
        if (element["username"] != null) {
          final userStr = element["username"].toString();
          
          // Debug: afficher quelques exemples pour comprendre le format
          if (data.indexOf(element) < 3) {
            print('👤 Exemple utilisateur ${data.indexOf(element)}: ${userStr.substring(0, userStr.length > 50 ? 50 : userStr.length)}...');
          }
          
          // Pattern plus précis pour éviter les faux positifs
          if (userStr.contains("/$username;") && userStr.contains(";$password;")) {
            loggedUser = element;
            print('✅ Utilisateur trouvé: ${element["id"]}');
            break;
          }
        }
      }
      
      // Si pas trouvé, essayer des patterns alternatifs
      if (loggedUser == null) {
        print('🔍 Recherche alternative...');
        for (var element in data) {
          if (element["username"] != null) {
            final userStr = element["username"].toString().toLowerCase();
            final userLower = username.toLowerCase();
            final passLower = password.toLowerCase();
            
            if (userStr.contains(userLower) && userStr.contains(passLower)) {
              print('🔄 Trouvé avec recherche alternative: ${element["id"]}');
              loggedUser = element;
              break;
            }
          }
        }
      }

      if (!mounted) return;
      Navigator.pop(context); // Fermer loading

      if (loggedUser != null) {
        // Sauvegarder toutes les infos utilisateur
        await saveValues(loggedUser);
        if (!mounted) return;
        // Navigation selon le type d'utilisateur
        if (loggedUser["username"].toString().contains("admin")) {
          Navigator.pushNamedAndRemoveUntil(context, '/adminConsole', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        // Message de succès
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connexion réussie !'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      } else {
        // Afficher message d'erreur plus informatif
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Identifiants incorrects"),
                Text("Vérifiez votre nom d'utilisateur et mot de passe", 
                     style: TextStyle(fontSize: 12)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
      
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Fermer loading
      
      // Message d'erreur détaillé
      String errorMessage = 'Erreur de connexion';
      if (e.toString().contains('timeout')) {
        errorMessage = 'Timeout: Vérifiez votre connexion internet';
      } else if (e.toString().contains('socket')) {
        errorMessage = 'Problème réseau: Réessayez dans quelques instants';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage\n${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/transparent.jpg',
                      height: 90,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133434),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        prefixIcon: Icon(Icons.person, color: Color(0xFF133434)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF133434)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF133434),
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Se Connecter',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Nouvel utilisateur? ",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            'Créer un compte!',
                            style: TextStyle(color: green, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
} 
