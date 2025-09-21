import 'package:_3ilm_nafi3/constants.dart';
import 'package:_3ilm_nafi3/widgets/clickable_theme_item.dart';
import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart'; // retiré, plus utilisé ici

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Colors.white,
      child: child,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // 🔵 FOND AVEC L’IMAGE
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/title.png"), // ton image
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.9), // lisibilité
                BlendMode.lighten,
              ),
            ),
          ),
        ),

        // 🔲 CONTENU
        ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(height: MediaQuery.of(context).size.height / 20),
              Expanded(
                child: Center(
                  child: Image.asset("assets/images/title.png"), // logo titre
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 2 * MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Thèmes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: Color(0xFF1C8B6C), // 💙 Bleu marocain
                              decorationThickness: 2,
                              decorationColor: Color(0xFF1C8B6C),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: ClickableThemeItem(
                                      imagePath: 'assets/images/1.jpg',
                                      text: themes[0],
                                      routeName: '/page1',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(12, (index) {
                              if (index != 11) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: ClickableThemeItem(
                                          imagePath:
                                              'assets/images/${index * 2 + 2}.jpg',
                                          text: themes[index * 2 + 1],
                                          routeName:
                                              '/page${index * 2 + 2}',
                                        ),
                                      ),
                                      Flexible(
                                        child: ClickableThemeItem(
                                          imagePath:
                                              'assets/images/${index * 2 + 3}.jpg',
                                          text: themes[index * 2 + 2],
                                          routeName:
                                              '/page${index * 2 + 3}',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: ClickableThemeItem(
                                          imagePath:
                                              'assets/images/${index * 2 + 2}.jpg',
                                          text: themes[index * 2 + 1],
                                          routeName:
                                              '/page${index * 2 + 2}',
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  // Plus de bouton de partage ici
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
  }
