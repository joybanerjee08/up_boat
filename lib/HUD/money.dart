import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:up_boat/up_boat.dart';

class MoneyCount extends SpriteComponent with HasGameRef<PixelAdventure> {
  MoneyCount();

  final margin = 8;
  final buttonSize = 25;

  int money = 0;

  void setMoney(int x) {
    money = x;
  }

  void addMoney(int x) {
    money += x;
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
    sprite = Sprite(game.images.fromCache('HUD/money.png'));
    position = Vector2(
      margin.toDouble() + 8.5 * buttonSize,
      margin.toDouble(),
    );

    text = TextComponent(
        text: "\$$money",
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
    text.text = "\$$money";
    super.update(dt);
  }
}
