import 'package:flutter/material.dart';

/// Widget informatif pour expliquer la restriction de soumission
class VideoSubmissionInfoWidget extends StatelessWidget {
  const VideoSubmissionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                "Règle de soumission",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "📋 Un utilisateur ne peut soumettre qu'une seule vidéo à la fois",
            style: TextStyle(color: Colors.blue.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            "⏳ Il doit attendre la validation (ou le refus) avant de soumettre la suivante",
            style: TextStyle(color: Colors.blue.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            "✅ Cette règle évite le spam et assure une modération de qualité",
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}

/// Widget d'aide pour les tests en développement  
class DevTestingWidget extends StatelessWidget {
  const DevTestingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                "Mode Développement",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "🔧 Pour tester les soumissions multiples :",
            style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "1️⃣ Validez ou refusez les vidéos en attente",
            style: TextStyle(color: Colors.orange.shade700),
          ),
          Text(
            "2️⃣ L'utilisateur pourra alors soumettre une nouvelle vidéo",
            style: TextStyle(color: Colors.orange.shade700),
          ),
          Text(
            "3️⃣ Répétez le processus pour tester le workflow complet",
            style: TextStyle(color: Colors.orange.shade700),
          ),
        ],
      ),
    );
  }
}