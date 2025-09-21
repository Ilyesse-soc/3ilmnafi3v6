import 'dart:convert';

import 'package:_3ilm_nafi3/models/user.dart';
import 'package:_3ilm_nafi3/screens/post_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool readTC = false;
  bool _isPasswordVisible = false;
  bool _isVerifyPasswordVisible = false;
  String _selectedProfilePicture = '';

  Future<void> saveValues(String username, String password) async {
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users');
    final response = await http.get(url);
    var data = jsonDecode(response.body);

    var loggedUser = data.firstWhere(
      (element) => element["username"].contains(username) && element["username"].contains(password),
      orElse: () => null,
    );

    if (loggedUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("loggedID", loggedUser["id"]);
      await prefs.setString("admin", "no");
    }
  }

  Future<void> _uploadUser(User user) async {
    final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      saveValues(user.username.split(";")[0] ?? '', user.passwordHash ?? '');
      Navigator.pushReplacementNamed(context, '/home');
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(color: Colors.white, child: PostRegisterPage()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de la création du compte")));
    }
  }

  void _createAccount() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final verifyPassword = _verifyPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || verifyPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez remplir tous les champs.")));
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(username)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le nom d'utilisateur ne doit contenir que des lettres, chiffres ou _")));
      return;
    }
    if (username.contains(";") || username.contains("/")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nom d'utilisateur invalide.")));
      return;
    }
    if (!email.contains("@") || (!email.contains("gmail.com") && !email.contains("hotmail"))) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email non valide (gmail ou hotmail).")));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mot de passe trop court (min 6 caractères).")));
      return;
    }
    if (password != verifyPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Les mots de passe ne correspondent pas.")));
      return;
    }
    if (!readTC) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez accepter les conditions d'utilisation.")));
      return;
    }

    User user = User(
      id: '', // Provide an appropriate id value here, e.g., '' or generate one if needed
      username: "/$username;$password;${_selectedProfilePicture.isEmpty ? '0' : _selectedProfilePicture.split("profile")[1].split(".")[0]}",
      email: email,
      passwordHash: password,
    );

    _uploadUser(user);
  }

  void _selectProfilePicture() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Sélectionner une photo"),
        content: Container(
          height: 200,
          width: double.maxFinite,
          child: GridView.builder(
            itemCount: 34,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedProfilePicture = 'assets/images/profiles/profile${index + 1}.PNG';
                });
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profiles/profile${index + 1}.PNG'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond marocain décoratif
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
                   ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    'assets/images/transparent.jpg',
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                    Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133434),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // USERNAME
                    TextField(
                      controller: _usernameController,
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

                    // EMAIL
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF133434)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF133434)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Color(0xFF133434)),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // VERIFY PASSWORD
                    TextField(
                      controller: _verifyPasswordController,
                      obscureText: !_isVerifyPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF133434)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(_isVerifyPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Color(0xFF133434)),
                          onPressed: () => setState(() => _isVerifyPasswordVisible = !_isVerifyPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // PROFILE PICTURE
                    GestureDetector(
                      onTap: _selectProfilePicture,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: _selectedProfilePicture.isNotEmpty
                            ? AssetImage(_selectedProfilePicture)
                            : null,
                        backgroundColor: Colors.white,
                        child: _selectedProfilePicture.isEmpty
                            ? Icon(Icons.account_circle, size: 54, color: Color(0xFF133434))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // MENTION LÉGALE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: readTC,
                          activeColor: Color(0xFF133434),
                          onChanged: (val) => setState(() => readTC = val!),
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () async {
                              final url = Uri.parse("https://e-kitab.my.canva.site/3ilmnafi3");
                              if (await canLaunchUrl(url)) launchUrl(url);
                            },
                            child: Text(
                              "J'accepte les conditions d'utilisation",
                              style: TextStyle(
                                color: Color(0xFF133434),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // BOUTON VALIDER
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF133434),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Créer le compte",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Vous avez déjà un compte ? ", style: TextStyle(fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                              color: Color(0xFF133434),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
