import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/characters/player.dart';
import 'package:up_boat/up_boat.dart';

class Checkpoint extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    add(RectangleHitbox(
      position: Vector2(28, 26),
      size: Vector2(22, 22),
      collisionType: CollisionType.passive,
    ));

    sprite = Sprite(game.images.fromCache('Background/redpod.png'));
    add(MoveEffect.by(
        Vector2(0, -1),
        EffectController(
            duration: 1.5,
            curve: Curves.linear,
            reverseDuration: 1.5,
            infinite: true)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    gameRef.onGameIdle();
  }
}
