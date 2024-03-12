import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class Fish extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  Fish({
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

  final List<String> FishList = ["fish 1", "fish 2"];
  final hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 32,
    height: 16,
  );
  bool collected = false;
  int moveSpeed = 50;
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
    size = Vector2(32, 16);

    final _random = new Random();
    fish_type = FishList[_random.nextInt(FishList.length)];

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
      game.images.fromCache('Background/$fish_type.png'),
      SpriteAnimationData.sequenced(
        amount: 13,
        stepTime: stepTime,
        textureSize:
            fish_type == 'fish 1' ? Vector2(118, 96) : Vector2(115, 68),
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

  void collidedWithPlayer() {
    moveSpeed = 100;
    Future.delayed(Duration(seconds: 3), () {
      moveSpeed = 50;
    });
  }
}
