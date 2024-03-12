import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:up_boat/up_boat.dart';

class LevelDialog extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const LevelDialog({super.key, required this.game});

  @override
  _LevelDialogState createState() => _LevelDialogState();
}

class _LevelDialogState extends State<LevelDialog>
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
            width: 800,
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
                      widget
                          .game.levelNameDialog[widget.game.currentLevelIndex],
                      speed: Duration(milliseconds: 70),
                      textStyle: TextStyle(
                          fontSize: 40.0,
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
                      widget.game.overlays.remove('Dialog');
                      widget.game.overlays.add('Story');
                      if (!widget.game.muteSound) {
                        FlameAudio.play('press.wav',
                            volume: widget.game.soundVolume);
                      }
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
