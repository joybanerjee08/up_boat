import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:up_boat/up_boat.dart';

class ThankyouDialog extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const ThankyouDialog({super.key, required this.game});

  @override
  _ThankyouDialogState createState() => _ThankyouDialogState();
}

class _ThankyouDialogState extends State<ThankyouDialog>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Animate(
        effects: [ElevationEffect(duration: Duration(seconds: 1))],
        child: Center(
          child: Container(
            height: 300,
            width: 400,
            decoration: const BoxDecoration(
              color: blackTextColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Thank you for playing ! More levels coming soon :)",
                      speed: Duration(milliseconds: 10),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: 25.0,
                          color: whiteTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "kodemono"),
                    ),
                  ],
                  pause: Duration(seconds: 5),
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // game.reset();
                      widget.game.playClick();
                      widget.game.overlays.remove('Thank You');
                      widget.game.overlays.add('Start');
                      widget.game.gamePaused = true;
                      widget.game.gameNotStarted = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: const Text(
                      'CLOSE',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: blackTextColor,
                          fontFamily: "kodemono"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
