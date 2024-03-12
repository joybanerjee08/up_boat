import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:up_boat/characters/disappear.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class Consumable extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String consume_type;
  Consumable({
    this.consume_type = 'oxygen_fill',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 2,
    offsetY: 2,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 4;

    size = Vector2.all(16);

    if (consume_type == 'oxygen_fill') {
      size = Vector2.all(32);
    }

    /*  add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */
    add(RectangleHitbox(collisionType: CollisionType.passive));
    sprite = Sprite(
      game.images.fromCache('Items/Consumable/$consume_type.png'),
    );
    add(MoveEffect.by(
        Vector2(0, 3),
        EffectController(
            duration: 1,
            curve: Curves.bounceInOut,
            reverseDuration: 1,
            infinite: true)));
    return super.onLoad();
  }

  bool addToBag() {
    if (gameRef.craftItems.fold(
            0, (previousValue, element) => previousValue + element.count) <
        gameRef.inventory_limit) {
      if (gameRef.inventoryContains(consume_type)) {
        gameRef.craftItems[gameRef.inventoryIndex(consume_type)].count += 1;
      } else {
        gameRef.craftItems
            .add(CollectableItems("$consume_type", 1, 'Consumable'));
      }
      return true;
    }
    return false;
  }

  void collidedWithPlayer() async {
    if (!collected) {
      if (consume_type == 'oxygen_fill') {
        gameRef.oxygen.addOxygen(25);
        collected = true;
      } else if (addToBag()) {
        collected = true;
      }
      if (collected) {
        if (consume_type == 'oxygen_fill') {
          if (!game.muteSound) {
            FlameAudio.play('breath.wav', volume: game.soundVolume);
          }
        } else {
          if (!game.muteSound) {
            FlameAudio.play('zip.wav', volume: game.soundVolume);
          }
        }
        sprite = null;
        add(disappear());
        Future.delayed(Duration(milliseconds: 300), () => removeFromParent());
      }
    }
  }
}
