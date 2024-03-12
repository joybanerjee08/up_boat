import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class StoneFish extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  StoneFish({
    position,
    size,
    this.offNeg = 0,
    this.offPos = 0,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  static const tileSize = 32;

  final hitbox = CustomHitbox(
    offsetX: 5,
    offsetY: 10,
    width: 40,
    height: 10,
  );
  bool collected = false;
  static const moveSpeed = 30;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  bool touchWall = false;
  Vector2 previousPosition = Vector2.zero();
  bool flipped = false;

  @override
  FutureOr<void> onLoad() {
    priority = 4;
    //debugMode = false;
    size = Vector2(48, 36);

    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY + 10),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    //add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Lion Fish/lion_fish.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: stepTime,
        textureSize: Vector2(211, 168),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _moveHorizontally(dt);
    gameRef.player.collisionBlocks.forEach((block) {
      if (checkCollision(this, block)) {
        if (block.isPlatform) {
          moveDirection = -1;
          // if (touchWall) flipHorizontallyAroundCenter();
        }
      }
    });

    if (position.x < previousPosition.x) {
      if (flipped) {
        flipHorizontallyAroundCenter();
        flipped = false;
      }
    } else if (position.x > previousPosition.x) {
      if (!flipped) {
        flipHorizontallyAroundCenter();
        flipped = true;
      }
    }
    previousPosition = Vector2(position.x, position.y);

    super.update(dt);
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
      // flipHorizontallyAroundCenter();
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
      // flipHorizontallyAroundCenter();
    }
    position.x += moveDirection * moveSpeed * dt;
  }

  void collidedWithPlayer() async {
    gameRef.health.reduceHealth(10);
  }
}
