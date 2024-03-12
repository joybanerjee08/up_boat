import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:up_boat/components/utils.dart';
import '../up_boat.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final PixelAdventure game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 0.6);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 350,
          width: 400,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(
                flex: 2,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'UP BOAT !',
                    textStyle: TextStyle(
                        fontSize: 40.0,
                        color: whiteTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "pacifico"),
                  ),
                  WavyAnimatedText(
                    'BOAT UP !',
                    textStyle: TextStyle(
                        fontSize: 40.0,
                        color: whiteTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "pacifico"),
                  ),
                ],
                pause: Duration(seconds: 5),
                isRepeatingAnimation: true,
                repeatForever: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
              Spacer(
                flex: 3,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                        onPressed: () async {
                          game.playClick();
                          game.gamePaused = false;
                          game.gameNotStarted = false;
                          game.overlays.remove('Start');
                          game.overlays.add('Dialog');
                          game.secondsElapsed = 0;
                          game.changeBGM();
                        },
                        color: Colors.blueAccent,
                        child: const Text(
                          'NEW GAME',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: whiteTextColor,
                              fontFamily: "kodemono"),
                        ))
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                        color: Colors.white,
                        size: 0.25,
                        duration: Duration(seconds: 2),
                        delay: Duration(seconds: 3)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () {
                    game.playClick();
                    game.overlays.remove('Start');
                    game.overlays.add('Tutorial');
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'HOW TO PLAY',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    color: Colors.white,
                    size: 0.25,
                    duration: Duration(seconds: 1),
                    delay: Duration(seconds: 5)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () {
                    game.playClick();
                    game.overlays.remove('Start');
                    game.overlays.add('Level');
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'LOAD GAME',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    color: Colors.white,
                    size: 0.25,
                    duration: Duration(seconds: 4),
                    delay: Duration(seconds: 5)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () async {
                    game.playClick();
                    game.allScores = await getAllScores();
                    game.overlays.remove('Start');
                    game.overlays.add('Score');
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'HIGH SCORE',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    color: Colors.white,
                    size: 0.25,
                    duration: Duration(seconds: 3),
                    delay: Duration(seconds: 5)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () {
                    game.playClick();
                    game.overlays.remove('Start');
                    game.overlays.add('Settings');
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'SETTINGS',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    color: Colors.white,
                    size: 0.25,
                    duration: Duration(seconds: 2),
                    delay: Duration(seconds: 5)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () {
                    game.playClick();
                    game.overlays.remove('Start');
                    exit(0);
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'QUIT',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    color: Colors.white,
                    size: 0.25,
                    duration: Duration(seconds: 2),
                    delay: Duration(seconds: 9)),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
