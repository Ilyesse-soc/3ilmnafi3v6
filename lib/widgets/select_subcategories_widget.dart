import 'package:flutter/material.dart';
import '../constants/theme_subcategories.dart';

class SelectSubcategoriesWidget extends StatelessWidget {
  final String theme;
  final List<String> subcategories;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const SelectSubcategoriesWidget({
    Key? key,
    required this.theme,
    required this.subcategories,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Sous-catégories pour : $theme",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: subcategories.map((subcategory) {
        final isSelected = selected.contains(subcategory);
        return CheckboxListTile(
          title: Text(subcategory),
          value: isSelected,
          onChanged: (bool? checked) {
            List<String> updated = List.from(selected);
            if (checked == true) {
              if (updated.length < 3) {
                updated.add(subcategory);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Maximum 3 sous-catégories."),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            } else {
              updated.remove(subcategory);
            }
            onChanged(updated);
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}