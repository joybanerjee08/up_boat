import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class Scoreboard extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const Scoreboard({super.key, required this.game});

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin {
  int start = 0;
  int end = 3;
  List<String> inventoryItems = [];
  List<String> inventoryItemCounts = [];
  List<bool> itemSelect = [];
  List<bool> hoverSense = [];

  late final controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 200))
        ..addListener(() {
          setState(() {});
        });

  late final animation = Tween<Matrix4>(
          begin: Matrix4.translationValues(0, 12, 0), end: Matrix4.identity())
      .animate(controller);

  @override
  void initState() {
    widget.game.allScores.forEach((element) {
      List<String> scoresAndTime = element.values.toList()[0];
      inventoryItems.add(scoresAndTime[0]);
      inventoryItemCounts.add("\$" +
          scoresAndTime[1] +
          " - " +
          double.parse(scoresAndTime[2]).toStringAsFixed(0) +
          "s");
      itemSelect.add(false);
      hoverSense.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    List<Widget> itemList = [];

    if (inventoryItems.length <= end) {
      end = inventoryItems.length;
    }

    if (inventoryItems.isNotEmpty) {
      for (int i = start; i < end; i++) {
        String level = inventoryItems[i];
        String time = inventoryItemCounts[i];

        itemList.add(MouseRegion(
          onEnter: (event) {
            setState(() {
              hoverSense[i] = true;
            });
          },
          onExit: (event) {
            setState(() {
              hoverSense[i] = false;
            });
          },
          child: GlowContainer(
            height: 64,
            color: itemSelect[i]
                ? Colors.amber
                : hoverSense[i]
                    ? Colors.blue
                    : Colors.transparent,
            border: Border.all(
                color: itemSelect[i] ? Colors.amberAccent : Colors.blueAccent),
            margin: EdgeInsets.all(10),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text((i + 1).toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono")),
                Text(level,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono")),
                Text(time,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: whiteTextColor,
                        fontFamily: "kodemono"))
              ],
            ),
          ),
        ));
      }
    }

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 500,
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
              const Text(
                'High Scores',
                style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 40,
                    fontFamily: "kodemono"),
              ),
              // const SizedBox(height: 20),
              IconButton(
                iconSize: 36,
                color: Colors.white,
                hoverColor: Colors.blue,
                icon: const Icon(
                  Icons.arrow_drop_up,
                ),
                // the method which is called
                // when button is pressed
                onPressed: start != 0
                    ? () {
                        setState(
                          () {
                            end--;
                            start--;
                            controller.reverse();
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                          },
                        );
                      }
                    : null,
              ),
              AnimatedContainer(
                transform: animation.value,
                duration: controller.duration!,
                child: Column(
                  children: itemList,
                ),
              ),
              IconButton(
                iconSize: 36,
                color: Colors.white,
                hoverColor: Colors.blue,
                icon: const Icon(
                  Icons.arrow_drop_down,
                ),
                // the method which is called
                // when button is pressed
                onPressed: end < inventoryItems.length
                    ? () {
                        setState(
                          () {
                            end++;
                            start++;
                            controller.forward();
                            if (!widget.game.muteSound) {
                              FlameAudio.play('press.wav',
                                  volume: widget.game.soundVolume);
                            }
                          },
                        );
                      }
                    : null,
              ),
              // const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // game.reset();
                        deleteAll();
                        widget.game.overlays.remove('Score');
                        widget.game.overlays.add('Start');
                        if (!widget.game.muteSound) {
                          FlameAudio.play('press.wav',
                              volume: widget.game.soundVolume);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: whiteTextColor,
                      ),
                      child: const Text(
                        'RESET',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: blackTextColor,
                            fontFamily: "kodemono"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // game.reset();
                        widget.game.overlays.remove('Score');
                        widget.game.overlays.add('Start');
                        if (!widget.game.muteSound) {
                          FlameAudio.play('press.wav',
                              volume: widget.game.soundVolume);
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
            ],
          ),
        ),
      ),
    );
  }
}
