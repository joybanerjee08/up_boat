import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/characters/player.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

class Shark extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  Shark({
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
    offsetX: 0,
    offsetY: 13,
    width: 30,
    height: 26,
  );
  bool collected = false;
  int moveSpeed = 30;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  bool touchWall = false;
  Vector2 previousPosition = Vector2.zero();
  bool flipped = false; //false = left
  late final Player player;
  Vector2 playerDirection = Vector2.zero();
  bool chasing = false;
  bool noCollision = false;
  double lastDirectionChange = 0;

  @override
  FutureOr<void> onLoad() {
    priority = 4;
    player = game.player;
    size = Vector2(90, 52);
    // debugMode = true;
    // anchor = Anchor.centerLeft;

    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    // flipHorizontallyAroundCenter();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Shark/idle.png'),
      SpriteAnimationData.sequenced(
        amount: 18,
        stepTime: stepTime,
        textureSize: Vector2(518, 243),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    noCollision = true;
    gameRef.player.collisionBlocks.forEach((block) {
      if (checkCollision(this, block)) {
        if (block.isPlatform) {
          noCollision = false;
          if (game.secondsElapsed - lastDirectionChange > 0.5) {
            moveDirection = -moveDirection;
            // checkCollisionX(this, block);
            lastDirectionChange = game.secondsElapsed;
          }
          // if (touchWall) flipHorizontallyAroundCenter();
        }
      }
    });

    // playerInRange();

    if (playerInRange()) {
      chasePlayer(dt);
      moveSpeed = 100;
    } else {
      moveSpeed = 30;
      if (noCollision) {
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
        // _moveHorizontally(dt);
      }
      position.x += moveDirection * moveSpeed * dt;
    }

    super.update(dt);
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

  bool playerInRange() {
    playerDirection = player.position - position;
    double hyp = sqrt(playerDirection.x * playerDirection.x +
        playerDirection.y * playerDirection.y);
    if (hyp < 100) {
      return true;
    }
    return false;
  }

  void chasePlayer(double dt) {
    //TODO : Add Wall Collision, turn x direction off if crash in x and vice versa
    playerDirection = player.position - position;
    double hyp = sqrt(playerDirection.x * playerDirection.x +
        playerDirection.y * playerDirection.y);
    playerDirection.x /= hyp;
    playerDirection.y /= hyp;
    // print("${playerDirection.x},${playerDirection.y}");
    if (playerDirection.x < 0) {
      if (flipped && game.secondsElapsed - lastDirectionChange > 1) {
        flipHorizontallyAroundCenter();
        flipped = false;
        lastDirectionChange = game.secondsElapsed;
      }
    } else if (playerDirection.x > 0) {
      if (!flipped && game.secondsElapsed - lastDirectionChange > 1) {
        flipHorizontallyAroundCenter();
        flipped = true;
        lastDirectionChange = game.secondsElapsed;
      }
    }

    double gap = 0;
    if (flipped && !player.flipped) {
      gap = -30;
    }
    if (!flipped && player.flipped) {
      gap = 30;
    }
    if (doOverlap([
      player.position.x + player.hitbox.offsetX,
      player.position.y + player.hitbox.offsetY + player.hitbox.height,
      player.position.x + player.hitbox.offsetX + player.hitbox.width,
      player.position.y + player.hitbox.offsetY
    ], [
      position.x + hitbox.offsetX + gap,
      position.y + hitbox.offsetY + hitbox.height,
      position.x + hitbox.offsetX + hitbox.width + gap,
      position.y + hitbox.offsetY
    ])) {
      game.player.hurtPlayer(this);
    }

    previousPosition = Vector2(position.x, position.y);
    if (noCollision) {
      position.x += playerDirection.x * moveSpeed * dt;
    }
    position.y += playerDirection.y * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
      // flipHorizontallyAroundCenter();
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
      // flipHorizontallyAroundCenter();
    }
    // position.x += moveDirection * moveSpeed * dt;
  }

  void collidedWithPlayer() async {
    gameRef.health.reduceHealth(100);
  }
}
