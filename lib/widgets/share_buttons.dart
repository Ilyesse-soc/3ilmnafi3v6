/*import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButtonRow extends StatelessWidget {
  final String videoTitle;
  final String videoUrl;

  ShareButtonRow({required this.videoTitle, required this.videoUrl});

  void _share(BuildContext context, String platform) {
    final message = '$videoTitle\n📽️ Regarde la vidéo ici : $videoUrl';

    switch (platform) {
      case 'whatsapp':
        Share.share(message); // Tu peux intégrer des liens personnalisés plus tard
        break;
      case 'instagram':
      case 'facebook':
      case 'twitter':
        Share.share(message);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(context, 'WhatsApp', Icons.chat, Colors.green, 'whatsapp'),
          _buildButton(context, 'Instagram', Icons.camera_alt, Colors.purple, 'instagram'),
          _buildButton(context, 'Facebook', Icons.facebook, Colors.blue, 'facebook'),
          _buildButton(context, 'Twitter', Icons.share, Colors.lightBlue, 'twitter'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Color color, String platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => _share(context, platform),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}*/
