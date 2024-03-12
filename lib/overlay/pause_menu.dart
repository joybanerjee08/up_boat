import 'dart:io';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import '../up_boat.dart';

class PauseMenu extends StatelessWidget {
  // Reference to parent game.
  final PixelAdventure game;

  const PauseMenu({super.key, required this.game});

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
              const Text(
                'Game Paused',
                style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 40,
                    fontFamily: "kodemono"),
              ),
              Spacer(
                flex: 2,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                        onPressed: () {
                          game.gamePaused = false;
                          game.overlays.remove('Pause');
                          if (!game.muteSound) {
                            FlameAudio.play('press.wav',
                                volume: game.soundVolume);
                          }
                        },
                        color: Colors.blueAccent,
                        child: const Text(
                          'RESUME GAME',
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
                    game.gamePaused = false;
                    game.resetLevel();
                    game.overlays.remove('Pause');
                    if (!game.muteSound) {
                      FlameAudio.play('press.wav', volume: game.soundVolume);
                    }
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'RESTART GAME',
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
                    game.overlays.remove('Pause');
                    game.overlays.add('Tutorial');
                    if (!game.muteSound) {
                      FlameAudio.play('press.wav', volume: game.soundVolume);
                    }
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
                    duration: Duration(seconds: 2),
                    delay: Duration(seconds: 5)),
              ),
              Spacer(),
              SizedBox(
                width: 200,
                height: 40,
                child: GlowButton(
                  onPressed: () {
                    game.overlays.remove('Pause');
                    game.overlays.add('Settings');
                    if (!game.muteSound) {
                      FlameAudio.play('press.wav', volume: game.soundVolume);
                    }
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
                    if (!game.muteSound) {
                      FlameAudio.play('press.wav', volume: game.soundVolume);
                    }
                    game.overlays.remove('Pause');
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
