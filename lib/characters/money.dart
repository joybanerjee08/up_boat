import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/characters/disappear.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class Money extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String money_type;
  Money({
    this.money_type = 'coin',
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

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */

    add(RectangleHitbox(collisionType: CollisionType.passive));
    // animation = SpriteAnimation.fromFrameData(
    //   game.images.fromCache('Items/Money/$money_type.png'),
    //   SpriteAnimationData.sequenced(
    //     amount: 1,
    //     stepTime: stepTime,
    //     textureSize: Vector2(32, 32),
    //   ),
    // );
    sprite = Sprite(game.images.fromCache('Items/Money/$money_type.png'));
    add(MoveEffect.by(
        Vector2(0, 2),
        EffectController(
            duration: 1,
            curve: Curves.bounceInOut,
            reverseDuration: 1,
            infinite: true)));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;

      if (!game.muteSound) {
        FlameAudio.play('zip.wav', volume: game.soundVolume);
      }

      if (money_type == 'coin') {
        gameRef.money.addMoney(1);
      }
      if (money_type == 'some_coin') {
        gameRef.money.addMoney(3);
      }
      if (money_type == 'wallet') {
        gameRef.money.addMoney(10);
      }
      if (money_type == 'stack') {
        gameRef.money.addMoney(20);
      }
      if (money_type == 'bill') {
        gameRef.money.addMoney(2);
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
