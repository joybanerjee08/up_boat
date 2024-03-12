import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import '../up_boat.dart';

class SettingsMenu extends StatefulWidget {
  // Reference to parent widget.game.
  final PixelAdventure game;
  const SettingsMenu({super.key, required this.game});

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu>
    with TickerProviderStateMixin {
  static const blackTextColor = Color.fromRGBO(0, 0, 0, 0.6);
  static const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

  @override
  Widget build(BuildContext context) {
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
                'Settings',
                style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 40,
                    fontFamily: "kodemono"),
              ),
              Spacer(
                flex: 2,
              ),
              GlowButton(
                onPressed: () {
                  if (!widget.game.muteSound) {
                    FlameAudio.play('press.wav',
                        volume: widget.game.soundVolume);
                  }
                  setState(() {
                    widget.game.muteSound = !widget.game.muteSound;
                  });
                },
                color: widget.game.muteSound ? Colors.amber : Colors.blueAccent,
                child: const Text(
                  'MUTE',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: whiteTextColor,
                      fontFamily: "kodemono"),
                ),
              ),
              SizedBox(
                  width: 300,
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'MUSIC VOLUME',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: whiteTextColor,
                            fontFamily: "kodemono"),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                            setState(() {
                              if (widget.game.musicVolume < 1) {
                                widget.game.musicVolume += 0.1;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: whiteTextColor,
                          )),
                      Text(
                        (widget.game.musicVolume * 10).toInt().toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            color: whiteTextColor,
                            fontFamily: "kodemono"),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                            setState(() {
                              if (widget.game.musicVolume > 0) {
                                widget.game.musicVolume -= 0.1;
                              }
                            });
                          },
                          icon: Icon(Icons.remove, color: whiteTextColor))
                    ],
                  )),
              Spacer(),
              SizedBox(
                  width: 300,
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'SFX VOLUME',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: whiteTextColor,
                            fontFamily: "kodemono"),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                            setState(() {
                              if (widget.game.soundVolume < 1) {
                                widget.game.soundVolume += 0.1;
                              }
                            });
                          },
                          icon: Icon(Icons.add, color: whiteTextColor)),
                      Text(
                        (widget.game.soundVolume * 10).toInt().toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            color: whiteTextColor,
                            fontFamily: "kodemono"),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                            setState(() {
                              if (widget.game.soundVolume > 0) {
                                widget.game.soundVolume -= 0.1;
                              }
                            });
                          },
                          icon: Icon(Icons.remove, color: whiteTextColor))
                    ],
                  )),
              Spacer(),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (!widget.game.muteSound) {
                      FlameAudio.play('press.wav',
                          volume: widget.game.soundVolume);
                    }
                    widget.game.overlays.remove('Settings');
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
