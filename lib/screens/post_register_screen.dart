import 'package:flutter/material.dart';
import 'package:_3ilm_nafi3/constants.dart';

class PostRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: const [
              SizedBox(height: 10),
              Text(
                "السّلام عليكم ورحمة الله وبركاته",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 20),
              Text(
                "3ilm Nafi3 est une application conçue, par la grâce d’Allah ﷻ, pour te permettre d’apprendre et surtout de mettre en pratique la science utile tirée de l’islam authentique : le Coran, la Sunna du Prophète ﷺ, selon la compréhension des pieux prédécesseurs.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Une fonctionnalité de partage de vidéos a également été mise en place pour faciliter la transmission du savoir et espérer une sadaqa jariya (صدقة جارية) in shâ’ Allah.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "🕋 Qu’Allah nous facilite et agrée nos œuvres.",
                style: TextStyle(fontSize: 16, color: Color(0xFF029933)),
              ),
              SizedBox(height: 8),
              Text(
                "Amin !",
                style: TextStyle(fontSize: 16, color: Color(0xFF029933)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
