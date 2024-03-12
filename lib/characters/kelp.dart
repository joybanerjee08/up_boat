import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/up_boat.dart';

class Kelp extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String placement;
  Kelp({
    this.placement = 'Back',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 10;
    if (placement == 'Back') {
      priority = 1;
    }

    size = Vector2(48 * 2, 96 * 2);
    position.y -= 84 * 2;

    sprite = Sprite(game.images.fromCache('Background/Sea Kelp.png'));
    add(MoveEffect.by(
        Vector2(-1, 0),
        EffectController(
            duration: 1,
            curve: Curves.bounceInOut,
            reverseDuration: 1,
            infinite: true)));
    return super.onLoad();
  }
}
