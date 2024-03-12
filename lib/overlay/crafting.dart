import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:up_boat/up_boat.dart';

class Crafting extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const Crafting({super.key, required this.game});

  @override
  _CraftingState createState() => _CraftingState();
}

class _CraftingState extends State<Crafting> with TickerProviderStateMixin {
  int start = 0;
  int end = 3;
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
    hoverSense =
        List.generate(widget.game.recipeTable.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    List<Widget> itemList = [];
    // AnimationController controller = AnimationController(
    //     vsync: this,
    //     duration: Duration(milliseconds: 800),
    //     reverseDuration: Duration(milliseconds: 800));
    for (int i = start; i < end; i++) {
      List<String> fruits = widget.game.recipeTable.keys.toList()[i];
      String perk = widget.game.recipeTable.values.toList()[i];

      List<Widget> craftFormula = [];
      fruits.forEach((element) {
        craftFormula.add(SizedBox(
          width: 48,
          height: 48,
          child: new Image.asset(
            'assets/images/Items/Craft/$element.png',
            fit: BoxFit.cover,
          ),
        ));
      });

      craftFormula.add(Text(perk,
          style: TextStyle(
              fontSize: 20.0, color: whiteTextColor, fontFamily: "kodemono")));

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
          color: hoverSense[i] ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blueAccent),
          margin: EdgeInsets.all(10),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: craftFormula,
          ),
        ),
      ));
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
                'Crafting',
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
                            widget.game.playClick();
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
                onPressed: end < widget.game.recipeTable.length
                    ? () {
                        setState(
                          () {
                            end++;
                            start++;
                            controller.forward();
                            widget.game.playClick();
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
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // game.reset();
                        widget.game.overlays.remove('Crafting');
                        widget.game.overlays.add('Inventory');
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
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // game.reset();
                        widget.game.overlays.remove('Crafting');
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
