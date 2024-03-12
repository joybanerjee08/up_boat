import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class EndLevel extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const EndLevel({super.key, required this.game});

  @override
  _InventoryMenuState createState() => _InventoryMenuState();
}

class _InventoryMenuState extends State<EndLevel>
    with TickerProviderStateMixin {
  int start = 0;
  int end = 3;
  List<String> inventoryItems = [];
  List<int> inventoryItemCounts = [];
  List<String> inventoryItemType = [];
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
    inventoryItems = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].name);
    inventoryItemCounts = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].count);
    inventoryItemType = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].type);
    itemSelect = List.generate(inventoryItems.length, (index) => false);
    hoverSense = List.generate(inventoryItems.length, (index) => false);
    super.initState();
  }

  void removeInventoryItem(List<CollectableItems> items) {
    items.forEach((item) {
      widget.game.craftItems.remove(item);
    });
    inventoryItems = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].name);
    inventoryItemCounts = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].count);
    inventoryItemType = List.generate(widget.game.craftItems.length,
        (index) => widget.game.craftItems[index].type);
    itemSelect = List.generate(inventoryItems.length, (index) => false);
    hoverSense = List.generate(inventoryItems.length, (index) => false);
    start = 0;
    end = 3;
    setState(() {});
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

    if (inventoryItems.length <= end) {
      end = inventoryItems.length;
    }

    if (inventoryItems.isNotEmpty) {
      for (int i = start; i < end; i++) {
        String fruits = inventoryItems[i];
        int count = inventoryItemCounts[i];

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
          child: GestureDetector(
            onTap: () {
              setState(() {
                itemSelect[i] = !itemSelect[i];
              });
              if (!widget.game.muteSound) {
                FlameAudio.play('press.wav', volume: widget.game.soundVolume);
              }
            },
            child: GlowContainer(
              height: 64,
              color: itemSelect[i]
                  ? Colors.amber
                  : hoverSense[i]
                      ? Colors.blue
                      : Colors.transparent,
              border: Border.all(
                  color:
                      itemSelect[i] ? Colors.amberAccent : Colors.blueAccent),
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: new Image.asset(
                      'assets/images/Items/${inventoryItemType[i]}/$fruits.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                      fruits
                          .replaceAll(new RegExp(r"\d"), "")
                          .replaceAll("_", " "),
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              itemSelect[i] ? blackTextColor : whiteTextColor,
                          fontFamily: "kodemono")),
                  Text(count.toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              itemSelect[i] ? blackTextColor : whiteTextColor,
                          fontFamily: "kodemono"))
                ],
              ),
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
                'Inventory',
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
                    width: 140,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!widget.game.muteSound) {
                          FlameAudio.play('press.wav',
                              volume: widget.game.soundVolume);
                        }
                        widget.game.overlays.remove('End Level');
                        widget.game.player.endLevel();
                        saveScore(
                            widget.game.money.money.toString(),
                            widget.game.secondsElapsed.toString(),
                            widget.game.player.perks,
                            widget.game.currentLevelIndex);
                        widget.game.secondsElapsed = 0;
                        if (widget.game.currentLevelIndex == 0) {
                          if (!widget.game.finishedLevels
                              .contains("A ROCKY START")) {
                            widget.game.finishedLevels.add("A ROCKY START");
                          }
                        }
                        if (widget.game.currentLevelIndex == 1) {
                          if (!widget.game.finishedLevels
                              .contains("'I SEE TEETH'")) {
                            widget.game.finishedLevels.add("'I SEE TEETH'");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: whiteTextColor,
                          disabledBackgroundColor: Colors.grey),
                      child: const Text(
                        'FINISH',
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
                      onPressed: itemSelect.contains(true)
                          ? () {
                              if (!widget.game.muteSound) {
                                FlameAudio.play('press.wav',
                                    volume: widget.game.soundVolume);
                              }
                              List<CollectableItems> removalIndex = [];
                              List.generate(itemSelect.length, (index) {
                                if (itemSelect[index]) {
                                  switch (widget.game.craftItems[index].type) {
                                    case 'Trash':
                                      removalIndex
                                          .add(widget.game.craftItems[index]);
                                      widget.game.money.addMoney(2);
                                      break;
                                    case 'Sellable':
                                      removalIndex
                                          .add(widget.game.craftItems[index]);
                                      widget.game.money.addMoney(15);
                                      break;
                                    case 'Consumable':
                                      removalIndex
                                          .add(widget.game.craftItems[index]);
                                      widget.game.money.addMoney(10);
                                      break;
                                    case 'Craft':
                                      removalIndex
                                          .add(widget.game.craftItems[index]);
                                      widget.game.money.addMoney(10);
                                      break;
                                    default:
                                      widget.game.money.addMoney(1);
                                      break;
                                  }
                                }
                              });

                              removeInventoryItem(removalIndex);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: whiteTextColor,
                          disabledBackgroundColor: Colors.grey),
                      child: const Text(
                        'SELL',
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
                        widget.game.overlays.remove('End Level');
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
