import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:up_boat/up_boat.dart';

class Tutorial extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const Tutorial({super.key, required this.game});

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> with TickerProviderStateMixin {
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
            height: 500,
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
                      "How To Play",
                      speed: Duration(milliseconds: 30),
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
                Spacer(),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Press W A S D or Arrow Keys to move around and collect all items by swimming to it. The bag in the top right corner is your inventory. It will glow red if it is full, then either use the items in the inventory, craft a new item or go to the Redpod and sell items. Finish the map with highest possible money in least possible time.",
                      speed: Duration(milliseconds: 10),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: 20.0,
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
                Spacer(),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Enemies",
                      speed: Duration(milliseconds: 30),
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
                Spacer(),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Colorful fishes are harmless, Jelly Fishes will stun you and reduce health by 1%, Puffer Fish and Lion Fish will reduce health by 5-10%, smaller Crabs and Sea Urchins will reduce health by 15%, and large Crabs and Sharks will finish you instantly.",
                      speed: Duration(milliseconds: 10),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: 20.0,
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
                Spacer(),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.game.playClick();
                      widget.game.overlays.remove('Tutorial');
                      if (widget.game.gameNotStarted) {
                        widget.game.overlays.add('Start');
                      } else {
                        widget.game.overlays.add('Pause');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: const Text(
                      'BACK',
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
