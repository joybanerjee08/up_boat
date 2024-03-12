import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:up_boat/characters/disappear.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class Trash extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Trash({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  late String item_type = '';
  final double stepTime = 0.05;
  final List<String> TrashList = [
    "Bottle1",
    "Bottle2",
    "Bottle3",
    "Bottle4",
    "Bottle5",
    "Bowl1",
    "Bowl2",
    "Box1",
    "Can1",
    "Can2",
    "Can3",
    "Can4",
    "Cereal",
    "Chips",
    "Cup1",
    "Cup2",
    "Cup3",
    "Cup4",
    "Drink",
    "Plate1",
    "Plate2",
    "Tire1",
    "Tire2",
    "Toffee1",
    "Toffee2"
  ];
  final hitbox = CustomHitbox(
    offsetX: 2,
    offsetY: 2,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    priority = 4;

    size = Vector2.all(16);
    final _random = new Random();
    item_type = TrashList[_random.nextInt(TrashList.length)];

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */

    add(RectangleHitbox(collisionType: CollisionType.passive));

    sprite = Sprite(game.images.fromCache('Items/Trash/$item_type.png'));
    // animation = SpriteAnimation.fromFrameData(
    //   game.images.fromCache('Items/Trash/$item_type.png'),
    //   SpriteAnimationData.sequenced(
    //     amount: 1,
    //     stepTime: stepTime,
    //     textureSize: Vector2(32, 32),
    //   ),
    // );

    add(MoveEffect.by(
        Vector2(0, -3),
        EffectController(
            duration: 1,
            curve: Curves.bounceInOut,
            reverseDuration: 1,
            infinite: true)));

    add(RotateEffect.to(
        2,
        EffectController(
            duration: 15,
            curve: Curves.linear,
            reverseDuration: 15,
            infinite: true)));

    add(ColorEffect(
        Color.fromRGBO(220, 250, 51, 1),
        opacityTo: 0.2,
        EffectController(duration: 0.01, curve: Curves.linear)));
    return super.onLoad();
  }

  bool addToBag() {
    if (gameRef.craftItems.fold(
            0, (previousValue, element) => previousValue + element.count) <
        gameRef.inventory_limit) {
      if (gameRef.inventoryContains(item_type)) {
        gameRef.craftItems[gameRef.inventoryIndex(item_type)].count += 1;
      } else {
        gameRef.craftItems.add(CollectableItems("$item_type", 1, 'Trash'));
      }
      return true;
    }
    return false;
  }

  void collidedWithPlayer() async {
    if (!collected) {
      if (addToBag()) {
        collected = true;

        if (!game.muteSound) {
          FlameAudio.play('zip.wav', volume: game.soundVolume);
        }

        // animation = SpriteAnimation.fromFrameData(
        //   game.images.fromCache('Items/Fruits/Collected.png'),
        //   SpriteAnimationData.sequenced(
        //     amount: 6,
        //     stepTime: stepTime,
        //     textureSize: Vector2.all(32),
        //     loop: false,
        //   ),
        // );

        // await animationTicker?.completed;
        sprite = null;
        add(disappear());
        Future.delayed(Duration(milliseconds: 300), () => removeFromParent());
      }
    }
  }
}
