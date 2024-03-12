import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:up_boat/up_boat.dart';

class OxygenBar extends SpriteComponent with HasGameRef<PixelAdventure> {
  OxygenBar();

  final margin = 8;
  final buttonSize = 25;

  int oxygen = 100;

  void setOxygen(int x) {
    oxygen = x;
  }

  void addOxygen(int x) {
    if (oxygen + x < 100) {
      oxygen += x;
    } else {
      oxygen = 100;
    }
  }

  void reduceOxygen(int x) {
    if (oxygen - x > 0) {
      oxygen -= x;
    } else {
      oxygen = 0;
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
    size = Vector2.all(20);
    sprite = Sprite(game.images.fromCache('HUD/oxygen.png'));
    position = Vector2(
      margin.toDouble() + 6 * buttonSize,
      margin.toDouble(),
    );

    text = TextComponent(
        text: "$oxygen%",
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
    text.text = "$oxygen%";
    super.update(dt);
  }
}
