import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:up_boat/up_boat.dart';

class ArmorBar extends SpriteComponent with HasGameRef<PixelAdventure> {
  ArmorBar();

  final margin = 8;
  final buttonSize = 25;

  int armor = 0;

  void setArmor(int x) {
    armor = x;
  }

  void addArmor(int x) {
    if (armor + x < 100) {
      armor += x;
    } else {
      armor = 100;
    }
  }

  void reduceArmor(int x) {
    if (armor - x > 0) {
      armor -= x;
    } else {
      armor = 0;
    }
  }

  final regular = TextPaint(
    style: TextStyle(
      fontSize: 16.0,
      fontFamily: "kodemono",
      color: BasicPalette.black.color,
    ),
  );

  late TextComponent text;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(20, 20);
    sprite = Sprite(game.images.fromCache('HUD/armor.png'));
    position = Vector2(
      margin.toDouble() + 4 * buttonSize,
      margin.toDouble(),
    );

    text = TextComponent(
        text: "$armor%",
        textRenderer: regular,
        position: Vector2(buttonSize / 2 + 10, 0)
        // position: Vector2(margin.toDouble() + 2 * buttonSize,
        //     margin.toDouble() + buttonSize - 10),
        );

    add(text);

    priority = 10;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    text.text = "$armor%";
    super.update(dt);
  }
}
