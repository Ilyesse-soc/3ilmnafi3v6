import 'package:flutter/material.dart';

import '../services/subcategory_api_service.dart';

class SubcategoryTestPage extends StatefulWidget {
  const SubcategoryTestPage({Key? key}) : super(key: key);

  @override
  State<SubcategoryTestPage> createState() => _SubcategoryTestPageState();
}

class _SubcategoryTestPageState extends State<SubcategoryTestPage> {
  List<Map<String, dynamic>> subcategories = [];
  bool isLoading = false;
  String statusMessage = 'Prêt pour le test';

  // Test de connexion API
  Future<void> testApiConnection() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Test de connexion...';
    });

    try {
      bool connected = await SubcategoryApiService.testConnection();
      setState(() {
        statusMessage = connected ? 
          '✅ Connexion API réussie !' : 
          '❌ Échec connexion API';
      });
    } catch (e) {
      setState(() {
        statusMessage = '❌ Erreur: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Test récupération sous-catégories
  Future<void> loadSubcategories() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Chargement sous-catégories...';
    });

    try {
      List<Map<String, dynamic>> data = await SubcategoryApiService.getAllSubcategories();
      setState(() {
        subcategories = data;
        statusMessage = data.isNotEmpty ? 
          '✅ ${data.length} sous-catégories chargées' : 
          '⚠️ Aucune sous-catégorie trouvée';
      });
    } catch (e) {
      setState(() {
        statusMessage = '❌ Erreur chargement: $e';
        subcategories = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Test comparaison avec données locales
  Future<void> testComparison() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Comparaison en cours...';
    });

    try {
      await SubcategoryApiService.compareWithLocalData();
      setState(() {
        statusMessage = '✅ Comparaison terminée (voir console)';
      });
    } catch (e) {
      setState(() {
        statusMessage = '❌ Erreur comparaison: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API Sous-catégories'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statut
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  if (isLoading) 
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (isLoading) const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      statusMessage,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Boutons de test
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : testApiConnection,
                    icon: const Icon(Icons.wifi),
                    label: const Text('1. Test Connexion API'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : loadSubcategories,
                    icon: const Icon(Icons.download),
                    label: const Text('2. Charger Sous-catégories'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : testComparison,
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('3. Comparaison Complète'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Liste des sous-catégories
            if (subcategories.isNotEmpty) ...[
              Text(
                'Sous-catégories récupérées (${subcategories.length}):',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(subcategory['name'] ?? 'Sans nom'),
                        subtitle: Text('Thème ID: ${subcategory['themeId']}'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text('${subcategory['id']}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}