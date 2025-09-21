import 'dart:convert';
import 'dart:io';

import 'package:_3ilm_nafi3/constants.dart'; // -> contient: themes, themesIDs, scholars, imams, green...
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme_subcategories.dart'; // -> Map<String, List<String>> themeSubcategories
import '../widgets/select_subcategories_widget.dart'; // -> widget multi-select sous-catégories

// ==============================
// API HELPERS
// ==============================

Future<bool> createNewVideo({
  required String title,
  required String videoUrl,
  required String uploaderId,
  required List<String> themes,           // IDs de thèmes (1..3)
  required List<String> subcategories,    // IDs de sous-catégories (0..*)
  required String imageUrl,
  required String ref,                    // intervenant choisi
}) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/videos');

  final body = jsonEncode({
    "title": title,
    "videoUrl": videoUrl,
    "uploaderId": uploaderId,
    "themes": themes,
    "subcategories": subcategories,
    "imageUrl": imageUrl,
    "reference": ref,
    "isValid": false,
  });

  try {
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    debugPrint("📤 /api/videos body: $body");
    debugPrint("📥 /api/videos resp: ${resp.statusCode} ${resp.body}");
    return resp.statusCode == 200 || resp.statusCode == 201;
  } catch (e) {
    debugPrint("❌ createNewVideo error: $e");
    return false;
  }
}

Future<String?> uploadVideo(String filePath) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/upload/upload-media');
  final req = http.MultipartRequest('POST', url)
    ..files.add(
      await http.MultipartFile.fromPath(
        'video',
        filePath,
        filename: p.basename(filePath),
        contentType: MediaType('video', 'mp4'),
      ),
    );

  try {
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    debugPrint("📥 uploadVideo: ${resp.statusCode} ${resp.body}");
    final data = jsonDecode(resp.body);
    return data['data']?['video'] as String?;
  } catch (e) {
    debugPrint('❌ uploadVideo error: $e');
    return null;
  }
}

Future<String?> uploadImage(String filePath) async {
  final url = Uri.parse('https://3ilmnafi3.digilocx.fr/api/upload/upload-media');
  final ext = _extensionFromPath(filePath);
  final mediaType = _mediaTypeForExt(ext);

  final req = http.MultipartRequest('POST', url)
    ..files.add(
      await http.MultipartFile.fromPath(
        'image',
        filePath,
        filename: p.basename(filePath),
        contentType: mediaType,
      ),
    );

  try {
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    debugPrint("📥 uploadImage: ${resp.statusCode} ${resp.body}");
    final data = jsonDecode(resp.body);
    return data['data']?['image'] as String?;
  } catch (e) {
    debugPrint('❌ uploadImage error: $e');
    return null;
  }
}

String _extensionFromPath(String filePath) => p.extension(filePath).replaceFirst('.', '').toLowerCase();

MediaType _mediaTypeForExt(String ext) {
  switch (ext) {
    case 'png':
      return MediaType('image', 'png');
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'gif':
      return MediaType('image', 'gif');
    case 'webp':
      return MediaType('image', 'webp');
    case 'bmp':
      return MediaType('image', 'bmp');
    case 'tif':
    case 'tiff':
      return MediaType('image', 'tiff');
    default:
      return MediaType('application', 'octet-stream');
  }
}

// ==============================
// UI
// ==============================

class UploadPage extends StatefulWidget {
  final String videoPath;
  const UploadPage({required this.videoPath, Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  // Thèmes & sous-catégories
  List<String> selectedThemes = []; // noms affichés
  Map<String, List<String>> selectedSubcategories = {}; // par nom de thème

  // Intervenants
  String? selectedScholar;
  String? selectedImam;
  bool isCheikhSelected = false;
  bool isImamSelected = false;
  bool isScholarExpanded = false;
  bool isImamExpanded = false;

  // Image
  File? _thumbnail;
  String thumbnailPath = "";

  // UI
  bool isThemeExpanded = false;
  bool isConsented = false;

  final _uuidRe = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _thumbnail = File(picked.path);
        thumbnailPath = picked.path;
      });
    }
  }

  void _msg(BuildContext c, String m, {String title = 'Erreur'}) {
    showDialog(
      context: c,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(m),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
      ),
    );
  }

  Future<void> _uploadFlow() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // Validations
    final title = _titleController.text.trim();
    if (title.isEmpty || title.length > 255) {
      _msg(context, 'Titre requis (1 à 255 caractères).');
      return;
    }
    if (selectedThemes.isEmpty || selectedThemes.length > 3) {
      _msg(context, 'Sélectionnez entre 1 et 3 thèmes.');
      return;
    }
    final subsInvalid = selectedThemes.any((t) {
      final s = selectedSubcategories[t] ?? [];
      return s.isEmpty || s.length > 3;
    });
    if (subsInvalid) {
      _msg(context, 'Chaque thème doit avoir 1 à 3 sous-catégories.');
      return;
    }
    if (_thumbnail == null || thumbnailPath.isEmpty) {
      _msg(context, 'Veuillez choisir une couverture (ratio 9:16).');
      return;
    }
    if (!isCheikhSelected && !isImamSelected) {
      _msg(context, 'Sélectionnez "Savant" ou "Imam/Talibu Ilm".');
      return;
    }
    final ref = selectedScholar ?? selectedImam;
    if (ref == null) {
      _msg(context, 'Sélectionnez un intervenant.');
      return;
    }
    if (!isConsented) {
      _msg(context, 'Merci de confirmer les conditions.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("loggedID");
    if (userID == null || !_uuidRe.hasMatch(userID)) {
      _msg(context, 'Session invalide. Merci de vous reconnecter.');
      return;
    }

    // Map noms -> IDs attendus par l’API
    final themeIDs = selectedThemes
        .map((t) => themesIDs[t]?['id'])
        .whereType<String>()
        .toList();
    if (themeIDs.isEmpty || themeIDs.length > 3) {
      _msg(context, 'Thèmes invalides. Réessayez.');
      return;
    }
    final allSubcats = selectedSubcategories.values.expand((x) => x).toList();

    // Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Téléchargement..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Veuillez patienter...")
          ],
        ),
      ),
    );

    try {
      final imageUrl = await uploadImage(thumbnailPath);
      final videoUrl = await uploadVideo(widget.videoPath);

      if (!mounted) return;
      Navigator.of(context).pop(); // close loader

      if (imageUrl == null || videoUrl == null) {
        _msg(context, 'Échec du téléversement de l’image ou de la vidéo.');
        return;
      }

      final ok = await createNewVideo(
        title: title,
        videoUrl: videoUrl,
        uploaderId: userID,
        themes: themeIDs,
        subcategories: allSubcats,
        imageUrl: imageUrl,
        ref: ref,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(ok ? "Succès" : "Erreur"),
          content: Text(ok
              ? "Votre vidéo a été soumise avec succès."
              : "Une erreur est survenue lors de l'envoi."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // close loader
      _msg(context, 'Téléversement échoué: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.orange),
                        ),
                        const Expanded(
                          child: Text(
                            "Ajouter Une Vidéo",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Titre
                  TextFormField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: 'Titre',
                      labelStyle: TextStyle(
                        color: _titleFocusNode.hasFocus ? Colors.green : Colors.black,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return 'Veuillez insérer un titre';
                      if (t.length > 255) return '255 caractères max';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Thèmes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Sélectionnez 1 à 3 thèmes',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isThemeExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 30,
                        ),
                        onPressed: () => setState(() => isThemeExpanded = !isThemeExpanded),
                      ),
                    ],
                  ),
                  if (isThemeExpanded)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: themes.map((theme) {
                        return ChoiceChip(
                          label: Text(theme, style: const TextStyle(fontSize: 10)),
                          selected: selectedThemes.contains(theme),
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                if (selectedThemes.length < 3) {
                                  selectedThemes.add(theme);
                                  selectedSubcategories[theme] = [];
                                }
                              } else {
                                selectedThemes.remove(theme);
                                selectedSubcategories.remove(theme);
                              }
                            });
                          },
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(
                            color: selectedThemes.contains(theme) ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),

                  // Sous-catégories par thème
                  ...selectedThemes.map(
                    (theme) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sous-catégories pour "$theme" (1 à 3)',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        SelectSubcategoriesWidget(
                          theme: theme,
                          subcategories: themeSubcategories[theme] ?? [],
                          selected: selectedSubcategories[theme] ?? [],
                          onChanged: (list) {
                            setState(() => selectedSubcategories[theme] = list);
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Intervenant
                  const Text('Sélectionnez un intervenant', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isCheikhSelected,
                          onChanged: (v) {
                            setState(() {
                              isCheikhSelected = v ?? false;
                              if (isCheikhSelected) {
                                isImamSelected = false;
                                selectedImam = null;
                              }
                            });
                          },
                          activeColor: green,
                        ),
                        const Text("Savant"),
                        const SizedBox(width: 20),
                        Checkbox(
                          value: isImamSelected,
                          onChanged: (v) {
                            setState(() {
                              isImamSelected = v ?? false;
                              if (isImamSelected) {
                                isCheikhSelected = false;
                                selectedScholar = null;
                              }
                            });
                          },
                          activeColor: green,
                        ),
                        const Text("Imam /\nTalibu Ilm"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (isCheikhSelected) ...[
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Sélectionnez 1 Savant',
                              style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          icon: Icon(isScholarExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                              size: 30),
                          onPressed: () => setState(() => isScholarExpanded = !isScholarExpanded),
                        ),
                      ],
                    ),
                    if (isScholarExpanded)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: scholars.map((s) {
                          return ChoiceChip(
                            label: Text(s, style: const TextStyle(fontSize: 10)),
                            selected: selectedScholar == s,
                            onSelected: (sel) =>
                                setState(() => selectedScholar = sel ? s : null),
                            selectedColor: Colors.green,
                            labelStyle: TextStyle(
                              color: selectedScholar == s ? Colors.white : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                  ],

                  if (isImamSelected) ...[
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Sélectionnez 1 Imam',
                              style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          icon:
                              Icon(isImamExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 30),
                          onPressed: () => setState(() => isImamExpanded = !isImamExpanded),
                        ),
                      ],
                    ),
                    if (isImamExpanded)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: imams.map((i) {
                          return Material(
                            color: Colors.transparent,
                            child: ChoiceChip(
                              label: Text(i, style: const TextStyle(fontSize: 10)),
                              selected: selectedImam == i,
                              onSelected: (sel) => setState(() => selectedImam = sel ? i : null),
                              selectedColor: Colors.green,
                              labelStyle: TextStyle(
                                color: selectedImam == i ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                  const SizedBox(height: 20),

                  // Image de couverture
                  const Text('Sélectionnez une couverture pour votre vidéo',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8 * 1.6, // 9:16
                        width: MediaQuery.of(context).size.width * 0.8 * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _thumbnail == null
                            ? const Center(
                                child: Text(
                                  'Choisir couverture\n(Doit être en ratio 9:16)',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const AspectRatio(
                                aspectRatio: 9 / 16,
                                child: SizedBox.expand(), // placeholder for Image.file below
                              ),
                      ),
                    ),
                  ),
                  if (_thumbnail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Image.file(_thumbnail!, fit: BoxFit.cover),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Consentement
                  Row(
                    children: [
                      Checkbox(
                        value: isConsented,
                        onChanged: (v) => setState(() => isConsented = v ?? false),
                        activeColor: green,
                      ),
                      const Flexible(
                        child: Text(
                          'Je confirme avoir lu les conditions pour pouvoir poster ma vidéo',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Bouton
                  Center(
                    child: ElevatedButton(
                      onPressed: _uploadFlow,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
                        child: Text('Télécharger Vidéo',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
