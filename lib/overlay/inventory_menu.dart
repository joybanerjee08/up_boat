import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:up_boat/up_boat.dart';

class InventoryMenu extends StatefulWidget {
  // Reference to parent game.
  final PixelAdventure game;
  const InventoryMenu({super.key, required this.game});

  @override
  _InventoryMenuState createState() => _InventoryMenuState();
}

class _InventoryMenuState extends State<InventoryMenu>
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

    bool anyTrash(List<CollectableItems> items, List<bool> itemSelect) {
      // print(itemSelect.contains(true));
      if (!itemSelect.contains(true)) {
        return true;
      }
      if (List.generate(itemSelect.length, (index) => index)
              .where((int index) =>
                  items[index].type != 'Consumable' && itemSelect[index])
              .length ==
          0) {
        return false;
      }
      return true;
    }

    String matchCraft(List<CollectableItems> items, List<bool> itemSelect) {
      if (List.generate(itemSelect.length, (index) => index)
              .where((int index) =>
                  items[index].type == 'Craft' && itemSelect[index])
              .length <=
          1) {
        return '';
      }
      List<String> selection = [];
      List.generate(
          itemSelect.length,
          (index) => {
                if (itemSelect[index]) {selection.add(items[index].name)}
              });
      String recipe = '';
      int itemsMatch = 0;
      List.generate(widget.game.recipeTable.keys.length, (index) {
        List<String> currentRecipe =
            widget.game.recipeTable.keys.toList()[index];
        itemsMatch = 0;
        selection.forEach((element) {
          if (currentRecipe.contains(element)) {
            itemsMatch++;
          }
        });
        if (itemsMatch == currentRecipe.length) {
          recipe = widget.game.recipeTable.values.toList()[index];
        }
      });
      return recipe;
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

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 600,
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
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // game.reset();
                    if (!widget.game.muteSound) {
                      FlameAudio.play('press.wav',
                          volume: widget.game.soundVolume);
                    }
                    widget.game.overlays.remove('Inventory');
                    widget.game.overlays.add('Crafting');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'CRAFTING',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: blackTextColor,
                        fontFamily: "kodemono"),
                  ),
                ),
              ),
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
                      onPressed: matchCraft(
                                  widget.game.craftItems, itemSelect) !=
                              ''
                          ? () {
                              List<CollectableItems> removalIndex = [];
                              List.generate(itemSelect.length, (index) {
                                if (itemSelect[index]) {
                                  removalIndex
                                      .add(widget.game.craftItems[index]);
                                }
                              });
                              String perks = matchCraft(
                                  widget.game.craftItems, itemSelect);
                              removeInventoryItem(removalIndex);
                              if (!widget.game.muteSound) {
                                FlameAudio.play('weld.wav',
                                    volume: widget.game.soundVolume);
                              }
                              if (perks == 'scuba' &&
                                  !widget.game.player.perks.contains('scuba')) {
                                widget.game.armor.addArmor(25);
                                widget.game.player.perks.add('scuba');
                              } else if (perks == 'armor' &&
                                  !widget.game.player.perks.contains('armor')) {
                                widget.game.armor.addArmor(75);
                                widget.game.player.perks.add('armor');
                              } else if (perks == 'large bag' &&
                                  !widget.game.player.perks
                                      .contains('large bag')) {
                                widget.game.inventory_limit = 25;
                                widget.game.player.perks.add('large bag');
                              } else {
                                widget.game.player.perks.add(perks);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: whiteTextColor,
                          disabledBackgroundColor: Colors.grey),
                      child: const Text(
                        'CRAFT',
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
                      onPressed: !anyTrash(widget.game.craftItems, itemSelect)
                          ? () {
                              if (!widget.game.muteSound) {
                                FlameAudio.play('press.wav',
                                    volume: widget.game.soundVolume);
                              }
                              List<CollectableItems> removalIndex = [];
                              List.generate(itemSelect.length, (index) {
                                if (itemSelect[index]) {
                                  removalIndex
                                      .add(widget.game.craftItems[index]);
                                  if (widget.game.craftItems[index].name ==
                                      'health_large') {
                                    widget.game.health.addHealth(30);
                                  }
                                  if (widget.game.craftItems[index].name ==
                                      'health_small') {
                                    widget.game.health.addHealth(10);
                                  }
                                  if (widget.game.craftItems[index].name ==
                                      'armor_large') {
                                    widget.game.armor.addArmor(30);
                                  }
                                  if (widget.game.craftItems[index].name ==
                                      'armor_med') {
                                    widget.game.armor.addArmor(20);
                                  }
                                  if (widget.game.craftItems[index].name ==
                                      'armor_small') {
                                    widget.game.armor.addArmor(10);
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
                        'USE',
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
                        widget.game.overlays.remove('Inventory');
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
