import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class JellyFish extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String jelly_fish;
  JellyFish({
    this.jelly_fish = 'small',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 4;

    size = jelly_fish == 'large'
        ? Vector2(20, 40)
        : jelly_fish == 'medium'
            ? Vector2(16, 32)
            : Vector2.all(16);

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */

    add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Jelly Fish/$jelly_fish.png'),
      SpriteAnimationData.sequenced(
        amount: 45,
        stepTime: stepTime,
        textureSize: jelly_fish == 'large'
            ? Vector2(98, 147)
            : jelly_fish == 'medium'
                ? Vector2(72, 113)
                : Vector2(65, 43),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    gameRef.health.reduceHealth(1);
  }
}
