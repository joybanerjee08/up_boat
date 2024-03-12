import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/characters/disappear.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class Sellable extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Sellable({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  late String item_type = '';
  final double stepTime = 0.05;
  final List<String> SellableList = [
    "analog_watch",
    "bracelet1",
    "bracelet3",
    "bracelet4",
    "bracelet5",
    "bracelet6",
    "bracelet7",
    "braclet2",
    "chip",
    "ear1",
    "ear2",
    "ear3",
    "ear4",
    "ear5",
    "ear6",
    "ear7",
    "glasses",
    "necklace1",
    "necklace2",
    "necklace3",
    "necklace4",
    "necklace5",
    "necklace6",
    "necklace7",
    "necklace8",
    "oil",
    "phone",
    "player",
    "ring1",
    "ring10",
    "ring2",
    "ring3",
    "ring4",
    "ring5",
    "ring6",
    "ring7",
    "ring8",
    "ring9",
    "solar",
    "thumb_drive",
    "watch"
  ];
  final hitbox = CustomHitbox(
    offsetX: 4,
    offsetY: 4,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 4;

    size = Vector2.all(16);
    final _random = new Random();
    item_type = SellableList[_random.nextInt(SellableList.length)];

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */

    add(RectangleHitbox(collisionType: CollisionType.passive));
    sprite = Sprite(game.images.fromCache('Items/Sellable/$item_type.png'));
    // animation = SpriteAnimation.fromFrameData(
    //   game.images.fromCache('Items/Sellable/$item_type.png'),
    //   SpriteAnimationData.sequenced(
    //     amount: 1,
    //     stepTime: stepTime,
    //     textureSize: Vector2(32, 32),
    //   ),
    // );
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
      if (gameRef.inventoryContains(item_type)) {
        gameRef.craftItems[gameRef.inventoryIndex(item_type)].count += 1;
      } else {
        gameRef.craftItems.add(CollectableItems("$item_type", 1, 'Sellable'));
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
