import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class PufferFish extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  PufferFish({
    position,
    size,
    this.offNeg = 0,
    this.offPos = 0,
  }) : super(
          position: position,
          size: size,
        );

  late String fish_type = '';
  final double stepTime = 0.05;
  static const tileSize = 32;

  final hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 32,
    height: 16,
  );
  bool collected = false;
  static const moveSpeed = 50;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  bool touchWall = false;
  Vector2 previousPosition = Vector2.zero();
  bool flipped = false;

  @override
  FutureOr<void> onLoad() {
    priority = 4;
    // debugMode = true;
    size = Vector2(28, 14);

    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */
    add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Puffer Fish/puffer_fish.png'),
      SpriteAnimationData.sequenced(
        amount: 13,
        stepTime: stepTime,
        textureSize: Vector2(103, 56),
      ),
    );
    return super.onLoad();
  }

  bool playerInRange() {
    Vector2 playerDirection = game.player.position - position;
    double hyp = sqrt(playerDirection.x * playerDirection.x +
        playerDirection.y * playerDirection.y);
    if (hyp < 50) {
      return true;
    }
    return false;
  }

  bool doOverlap(List<double> rect1_ltrb, List<double> rect2_ltrb) {
    if (rect1_ltrb[0] < rect2_ltrb[2] &&
        rect1_ltrb[2] > rect2_ltrb[0] &&
        rect1_ltrb[1] > rect2_ltrb[3] &&
        rect1_ltrb[3] < rect2_ltrb[1]) {
      return true;
    }
    return false;
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

    if (playerInRange()) {
      double gap = 0;
      if (flipped && !game.player.flipped) {
        gap = -30;
      }
      if (!flipped && game.player.flipped) {
        gap = 30;
      }
      if (doOverlap([
        game.player.position.x + game.player.hitbox.offsetX,
        game.player.position.y +
            game.player.hitbox.offsetY +
            game.player.hitbox.height,
        game.player.position.x +
            game.player.hitbox.offsetX +
            game.player.hitbox.width,
        game.player.position.y + game.player.hitbox.offsetY
      ], [
        position.x + hitbox.offsetX + gap,
        position.y + hitbox.offsetY + hitbox.height,
        position.x + hitbox.offsetX + hitbox.width + gap,
        position.y + hitbox.offsetY
      ])) {
        game.player.hurtPlayer(this);
      }
    }

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

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
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
    gameRef.health.reduceHealth(5);

    size = Vector2(36, 24);

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Puffer Fish/puffed_puffer_fish.png'),
      SpriteAnimationData.sequenced(
        amount: 20,
        stepTime: stepTime,
        textureSize: Vector2(162, 118),
        loop: true,
      ),
    );

    // await animationTicker?.completed;

    Future.delayed(Duration(seconds: 2), () {
      size = Vector2(28, 14);
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Enemies/Puffer Fish/puffer_fish.png'),
        SpriteAnimationData.sequenced(
          amount: 13,
          stepTime: stepTime,
          textureSize: Vector2(103, 56),
        ),
      );
    });
  }
}
