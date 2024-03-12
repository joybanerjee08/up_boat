import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class LargeCrab extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  LargeCrab({
    position,
    size,
    this.offNeg = 0,
    this.offPos = 0,
  }) : super(
          position: position,
          size: size,
        );

  late String fish_type = '';
  final double stepTime = 0.1;
  static const tileSize = 32;

  final hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 48,
    height: 32,
  );
  bool collected = false;
  int moveSpeed = 0;
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
    size = Vector2(48, 32);

    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    // add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Large Crab/crab_large.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: stepTime,
        textureSize: Vector2(296, 139),
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
    gameRef.health.reduceHealth(100);

    moveSpeed = 0;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Large Crab/crab_large_attack.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: stepTime,
        textureSize: Vector2(271, 122),
        loop: true,
      ),
    );

    // await animationTicker?.completed;

    Future.delayed(Duration(seconds: 2), () {
      moveSpeed = 30;
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Enemies/Large Crab/crab_large.png'),
        SpriteAnimationData.sequenced(
          amount: 15,
          stepTime: stepTime,
          textureSize: Vector2(296, 139),
        ),
      );
    });
  }
}
