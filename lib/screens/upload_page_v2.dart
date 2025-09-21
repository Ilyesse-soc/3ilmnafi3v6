import 'dart:io';

import 'package:_3ilm_nafi3/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/theme_subcategories.dart';
import '../services/subcategory_service.dart';
import '../services/video_service.dart';
import '../widgets/select_subcategories_widget.dart';

/// **UploadPageV2** - Version améliorée avec service robuste
class UploadPageV2 extends StatefulWidget {
  final String videoPath;
  const UploadPageV2({required this.videoPath, Key? key}) : super(key: key);

  @override
  State<UploadPageV2> createState() => _UploadPageV2State();
}

class _UploadPageV2State extends State<UploadPageV2> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  // Thèmes & sous-catégories
  List<String> selectedThemes = [];
  Map<String, List<String>> selectedSubcategories = {};
  Map<String, List<String>> availableSubcategories = {}; // Sous-catégories depuis l'API
  bool _loadingSubcategories = false;

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
  bool _isSubmitting = false;

  final _uuidRe = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

  @override
  void initState() {
    super.initState();
    _loadSubcategoriesFromAPI();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  /// Charge les sous-catégories depuis l'API
  Future<void> _loadSubcategoriesFromAPI() async {
    setState(() {
      _loadingSubcategories = true;
    });

    try {
      debugPrint('🔄 Chargement des sous-catégories depuis l\'API...');
      
      // Test de connexion d'abord
      final isConnected = await SubcategoryService.testAPIConnection();
      debugPrint('🌐 Connexion API: ${isConnected ? "OK" : "ÉCHEC"}');
      
      // Récupérer les sous-catégories
      final subcategoriesForUI = await SubcategoryService.getSubcategoriesForUI();
      
      setState(() {
        availableSubcategories = subcategoriesForUI;
        _loadingSubcategories = false;
      });
      
      debugPrint('✅ ${availableSubcategories.length} groupes de sous-catégories chargés');
      
      // Afficher quelques exemples dans les logs
      availableSubcategories.forEach((themeKey, subcats) {
        debugPrint('  - $themeKey: ${subcats.take(3).join(", ")}${subcats.length > 3 ? "..." : ""}');
      });
      
    } catch (e) {
      debugPrint('❌ Erreur chargement sous-catégories: $e');
      setState(() {
        _loadingSubcategories = false;
        // Fallback sur les données hardcodées
        availableSubcategories = Map<String, List<String>>.from(themeSubcategories);
      });
    }
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

  void _showMessage(String message, {bool isError = true, String? title}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: isError ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 8),
            Text(title ?? (isError ? 'Erreur' : 'Succès')),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _submitVideo() async {
    if (_isSubmitting) return;

    FocusManager.instance.primaryFocus?.unfocus();

    // Validation des champs
    final title = _titleController.text.trim();
    if (!_validateInputs(title)) return;

    // Vérifier si l'utilisateur peut soumettre une nouvelle vidéo
    final canSubmit = await VideoService.canSubmitNewVideo();
    if (!canSubmit) {
      _showMessage(
        '⏳ Vous devez attendre que votre vidéo précédente soit validée avant d\'en soumettre une nouvelle.\n\n'
        '💡 Consultez "Mes Vidéos" pour voir le statut de vos soumissions.',
        title: 'Soumission en attente'
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Map noms -> IDs pour l'API
    final themeIDs = selectedThemes
        .map((t) => themesIDs[t]?['id'])
        .whereType<String>()
        .toList();

    if (themeIDs.isEmpty || themeIDs.length > 3) {
      setState(() => _isSubmitting = false);
      _showMessage('Thèmes invalides. Réessayez.');
      return;
    }

    final allSubcats = selectedSubcategories.values.expand((x) => x).toList();
    final ref = selectedScholar ?? selectedImam!;

    // Debug des données avant envoi
    debugPrint("🔍 DEBUG Upload - Données à envoyer:");
    debugPrint("   - Titre: '$title'");
    debugPrint("   - Thèmes sélectionnés: $selectedThemes");
    debugPrint("   - Thèmes IDs: $themeIDs");
    debugPrint("   - Sous-catégories sélectionnées: $selectedSubcategories");
    debugPrint("   - Toutes sous-catégories: $allSubcats");
    debugPrint("   - Intervenant: '$ref'");

    // Afficher le loader
    _showSubmissionDialog();

    try {
      final result = await VideoService.submitVideo(
        title: title,
        videoPath: widget.videoPath,
        imagePath: thumbnailPath,
        themeIds: themeIDs,
        subcategories: allSubcats,
        reference: ref,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher le résultat
      _showResultDialog(result);
      
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Fermer le loader
        _showMessage('Erreur inattendue: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  bool _validateInputs(String title) {
    if (title.isEmpty || title.length > 255) {
      _showMessage('Le titre doit contenir entre 1 et 255 caractères.');
      return false;
    }
    if (selectedThemes.isEmpty || selectedThemes.length > 3) {
      _showMessage('Sélectionnez entre 1 et 3 thèmes.');
      return false;
    }

    for (final theme in selectedThemes) {
      final subs = selectedSubcategories[theme] ?? [];
      if (subs.isEmpty || subs.length > 3) {
        _showMessage('Chaque thème doit avoir entre 1 et 3 sous-catégories.');
        return false;
      }
    }

    if (_thumbnail == null || thumbnailPath.isEmpty) {
      _showMessage('Veuillez choisir une couverture (ratio 9:16 recommandé).');
      return false;
    }

    if (!isCheikhSelected && !isImamSelected) {
      _showMessage('Sélectionnez "Savant" ou "Imam/Talibu Ilm".');
      return false;
    }

    final ref = selectedScholar ?? selectedImam;
    if (ref == null) {
      _showMessage('Sélectionnez un intervenant.');
      return false;
    }

    if (!isConsented) {
      _showMessage('Veuillez accepter les conditions d\'utilisation.');
      return false;
    }

    return true;
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Soumission..."),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("📤 Upload de la couverture..."),
              SizedBox(height: 8),
              Text("📹 Upload de la vidéo..."),
              SizedBox(height: 8),
              Text("💾 Enregistrement des données..."),
              SizedBox(height: 16),
              Text(
                "Veuillez patienter, cela peut prendre quelques minutes.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog(VideoSubmissionResult result) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: result.success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(result.success ? "✅ Succès" : "❌ Erreur"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.message),
            if (result.success) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Text(
                  "🔍 Votre vidéo sera examinée par notre équipe dans les plus brefs délais. Vous recevrez une notification dès qu'elle sera validée.",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (result.success) {
                Navigator.pop(context); // Retour à l'écran précédent
              }
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Soumettre une vidéo"),
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section titre
              _buildSectionTitle("📝 Informations générales"),
              const SizedBox(height: 12),
              
              _buildTitleField(),
              const SizedBox(height: 20),

              // Section thèmes
              _buildSectionTitle("🏷️ Thèmes et catégories"),
              const SizedBox(height: 12),
              
              _buildThemesSection(),
              const SizedBox(height: 20),

              // Section intervenant
              _buildSectionTitle("👨‍🏫 Intervenant"),
              const SizedBox(height: 12),
              
              _buildIntervenantSection(),
              const SizedBox(height: 20),

              // Section couverture
              _buildSectionTitle("🖼️ Image de couverture"),
              const SizedBox(height: 12),
              
              _buildCoverageSection(),
              const SizedBox(height: 20),

              // Section conditions
              _buildSectionTitle("📋 Conditions"),
              const SizedBox(height: 12),
              
              _buildConsentSection(),
              const SizedBox(height: 30),

              // Bouton de soumission
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      maxLength: 255,
      decoration: InputDecoration(
        labelText: "Titre de la vidéo *",
        hintText: "Ex: Les mérites de la prière en groupe",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: green, width: 2),
        ),
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Le titre est requis';
        }
        return null;
      },
    );
  }

  Widget _buildThemesSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.category, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  "Sélection des thèmes (1-3)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Liste des thèmes sélectionnés
            if (selectedThemes.isNotEmpty)
              Wrap(
                spacing: 8,
                children: selectedThemes.map((theme) => Chip(
                  label: Text(theme),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      selectedThemes.remove(theme);
                      selectedSubcategories.remove(theme);
                    });
                  },
                )).toList(),
              ),
            
            const SizedBox(height: 12),
            
            // Bouton pour ajouter des thèmes
            OutlinedButton.icon(
              onPressed: selectedThemes.length >= 3 ? null : _showThemeSelector,
              icon: const Icon(Icons.add),
              label: Text(
                selectedThemes.isEmpty 
                  ? "Ajouter des thèmes"
                  : "Ajouter un thème (${selectedThemes.length}/3)"
              ),
            ),

            // Sous-catégories pour chaque thème
            ...selectedThemes.map((theme) => _buildSubcategorySection(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategorySection(String theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Sous-catégories pour: $theme",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              if (!_loadingSubcategories)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: availableSubcategories.isNotEmpty ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    availableSubcategories.isNotEmpty ? 'API' : 'Mock',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _loadingSubcategories
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Chargement des sous-catégories...'),
                      ],
                    ),
                  ),
                )
              : SelectSubcategoriesWidget(
                  theme: theme,
                  subcategories: availableSubcategories[theme] ?? 
                                themeSubcategories[theme] ?? [],
                  selected: selectedSubcategories[theme] ?? [],
                  onChanged: (selected) {
                    setState(() {
                      selectedSubcategories[theme] = selected;
                    });
                  },
                ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sélectionner un thème"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: themes
                .where((theme) => !selectedThemes.contains(theme))
                .map((theme) => ListTile(
                  title: Text(theme),
                  onTap: () {
                    setState(() {
                      selectedThemes.add(theme);
                    });
                    Navigator.pop(context);
                  },
                ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervenantSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Type d'intervenant *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Savant"),
                    value: true,
                    groupValue: isCheikhSelected ? true : (isImamSelected ? false : null),
                    onChanged: (value) {
                      setState(() {
                        isCheikhSelected = value ?? false;
                        isImamSelected = false;
                        selectedImam = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Imam/Talibu Ilm"),
                    value: false,
                    groupValue: isCheikhSelected ? true : (isImamSelected ? false : null),
                    onChanged: (value) {
                      setState(() {
                        isImamSelected = !(value ?? true);
                        isCheikhSelected = false;
                        selectedScholar = null;
                      });
                    },
                  ),
                ),
              ],
            ),

            if (isCheikhSelected) _buildScholarDropdown(),
            if (isImamSelected) _buildImamDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildScholarDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Sélectionner un savant",
        border: OutlineInputBorder(),
      ),
      value: selectedScholar,
      items: scholars.map((scholar) => DropdownMenuItem(
        value: scholar,
        child: Text(scholar),
      )).toList(),
      onChanged: (value) {
        setState(() {
          selectedScholar = value;
        });
      },
    );
  }

  Widget _buildImamDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Sélectionner un imam",
        border: OutlineInputBorder(),
      ),
      value: selectedImam,
      items: imams.map((imam) => DropdownMenuItem(
        value: imam,
        child: Text(imam),
      )).toList(),
      onChanged: (value) {
        setState(() {
          selectedImam = value;
        });
      },
    );
  }

  Widget _buildCoverageSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.image, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Image de couverture *",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (_thumbnail != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _thumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
            const SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(_thumbnail != null ? Icons.edit : Icons.add_a_photo),
              label: Text(_thumbnail != null ? "Changer l'image" : "Sélectionner une image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
              ),
            ),
            
            if (_thumbnail == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Ratio recommandé: 9:16 (format vertical)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              value: isConsented,
              onChanged: (value) {
                setState(() {
                  isConsented = value ?? false;
                });
              },
              title: const Text(
                "J'accepte les conditions d'utilisation",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                "• La vidéo sera soumise à validation\n"
                "• Contenu conforme aux valeurs islamiques\n"
                "• Respect des droits d'auteur",
                style: TextStyle(fontSize: 12),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitVideo,
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isSubmitting
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text("Soumission en cours..."),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file),
                SizedBox(width: 8),
                Text(
                  "Soumettre la vidéo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}