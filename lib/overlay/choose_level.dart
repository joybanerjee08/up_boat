import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:up_boat/components/utils.dart';
import '../up_boat.dart';

class ChooseLevel extends StatelessWidget {
  // Reference to parent game.
  final PixelAdventure game;

  const ChooseLevel({super.key, required this.game});

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
                'Choose Level',
                style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 40,
                    fontFamily: "kodemono"),
              ),
              Spacer(
                flex: 2,
              ),
              SizedBox(
                width: 250,
                height: 40,
                child: GlowButton(
                        onPressed: () {
                          if (!game.muteSound) {
                            FlameAudio.play('press.wav',
                                volume: game.soundVolume);
                          }
                          game.overlays.remove('Level');
                          game.currentLevelIndex = -1;
                          game.player.endLevel();
                          Future.delayed(Duration(seconds: 5), () {
                            game.gamePaused = false;
                            game.gameNotStarted = false;
                          });
                        },
                        color: Colors.blueAccent,
                        child: const Text(
                          'A ROCKY START',
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
                width: 250,
                height: 40,
                child: GlowButton(
                  onPressed: game.finishedLevels.contains('A ROCKY START')
                      ? () async {
                          if (!game.muteSound) {
                            FlameAudio.play('press.wav',
                                volume: game.soundVolume);
                          }
                          game.overlays.remove('Level');
                          game.currentLevelIndex = 0;
                          game.player.perks =
                              await loadPerks(game.currentLevelIndex);
                          game.player.endLevel();
                          Future.delayed(Duration(seconds: 5), () {
                            game.gamePaused = false;
                            game.gameNotStarted = false;
                          });
                        }
                      : null,
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'I SEE TEETH',
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
                width: 250,
                height: 40,
                child: GlowButton(
                  onPressed: null,
                  color: Colors.blueAccent,
                  splashColor: Colors.amber,
                  child: const Text(
                    'COMING SOON',
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
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // game.reset();
                    game.overlays.remove('Level');
                    game.overlays.add('Start');
                    if (!game.muteSound) {
                      FlameAudio.play('press.wav', volume: game.soundVolume);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
