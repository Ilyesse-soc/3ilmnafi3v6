import 'package:flutter/material.dart';

import '../constants/theme_subcategories.dart';


class AddVideoForm extends StatefulWidget {
  // ...existing code...
  @override
  State<AddVideoForm> createState() => _AddVideoFormState();
}

class _AddVideoFormState extends State<AddVideoForm> {
  String? selectedTheme;
  List<String> selectedSubcategories = [];

  // ...autres contrôleurs...

  @override
  Widget build(BuildContext context) {
    return Form(
      
      child: Column(
        children: [
          

          // Sélection du thème
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Thème",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), // Arrondi
            ),
            value: selectedTheme,
            items: themeSubcategories.keys
                .map((theme) => DropdownMenuItem(
                      value: theme,
                      child: Text(theme),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedTheme = value;
                selectedSubcategories.clear();
              });
            },
            validator: (value) =>
                value == null ? "Veuillez choisir un thème" : null,
          ),
          const SizedBox(height: 16),

          // Sélection des sous-catégories
          if (selectedTheme != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sous-catégorie(s) (1 à 3)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: themeSubcategories[selectedTheme]!
                      .map((subcat) => FilterChip(
                            label: Text(subcat),
                            selected: selectedSubcategories.contains(subcat),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  if (selectedSubcategories.length < 3) {
                                    selectedSubcategories.add(subcat);
                                  }
                                } else {
                                  selectedSubcategories.remove(subcat);
                                }
                              });
                            },
                            shape: StadiumBorder(), // Arrondi
                          ))
                      .toList(),
                ),
                if (selectedSubcategories.length < 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Veuillez choisir au moins une sous-catégorie",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 16),

          // ...autres champs et bouton submit...
        ],
      ),
    );
  }

  void _submitForm() {
    if (selectedTheme == null) {
      // Affiche une erreur
      return;
    }
    if (selectedSubcategories.length < 1 || selectedSubcategories.length > 3) {
      // Affiche une erreur
      return;
    }

    // ...suite de la soumission...
  }
}
