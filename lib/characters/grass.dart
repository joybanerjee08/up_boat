import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/up_boat.dart';

class Grass extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Grass({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final List<String> seagrass = [
    "Sea Grass 1.png",
    "sea grass.png",
  ];

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 0;
    // size = Vector2.all(32);

    final _random = new Random();
    String seagrass_type = "";
    seagrass_type = seagrass[_random.nextInt(seagrass.length)];
    // size = Vector2.all(16);

    sprite = Sprite(game.images.fromCache('Background/$seagrass_type'));
    if (_random.nextBool()) {
      flipHorizontallyAroundCenter();
    }
    add(MoveEffect.by(
        Vector2(-1, 0),
        EffectController(
            duration: 1.5,
            curve: Curves.bounceInOut,
            reverseDuration: 1.5,
            infinite: true)));
    return super.onLoad();
  }
}
