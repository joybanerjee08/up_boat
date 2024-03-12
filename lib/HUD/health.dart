import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/rendering.dart';
import 'package:up_boat/up_boat.dart';

class HealthBar extends SpriteComponent with HasGameRef<PixelAdventure> {
  HealthBar();

  final margin = 8;
  final buttonSize = 10;
  int health = 100;

  void setHealth(int x) {
    health = x;
  }

  void addHealth(int x) {
    if (health + x < 100) {
      health += x;
    } else {
      health = 100;
    }
  }

  void reduceHealth(int x) {
    if (game.armor.armor > 0) {
      game.armor.reduceArmor(x);
    } else {
      if (x > 10) {
        if (!game.muteSound) {
          FlameAudio.play('big_hurt.wav', volume: game.soundVolume);
        }
      } else if (x > 2) {
        if (!game.muteSound) {
          FlameAudio.play('small_hurt.wav', volume: game.soundVolume);
        }
      } else {
        if (!game.muteSound) {
          FlameAudio.play('shock.wav', volume: game.soundVolume);
        }
      }
      if (health - x > 0) {
        health -= x;
      } else {
        health = 0;
      }
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
    sprite = Sprite(game.images.fromCache('HUD/health.png'));
    position = Vector2(
      margin.toDouble() + 2 * buttonSize + 10,
      margin.toDouble(),
    );
    text = TextComponent(
        text: "$health%",
        textRenderer: regular,
        position: Vector2(buttonSize / 2 + 15, 0)
        // position: Vector2(margin.toDouble() + 2 * buttonSize,
        //     margin.toDouble() + buttonSize - 10),
        );

    add(text);
    priority = 10;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    text.text = "$health%";
    super.update(dt);
  }
}
