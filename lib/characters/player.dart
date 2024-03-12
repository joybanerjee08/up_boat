import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:up_boat/characters/consumable.dart';
import 'package:up_boat/characters/craft.dart';
import 'package:up_boat/characters/fish.dart';
import 'package:up_boat/characters/jelly_fish.dart';
import 'package:up_boat/characters/large_crab.dart';
import 'package:up_boat/characters/money.dart';
import 'package:up_boat/characters/puffer_fish.dart';
import 'package:up_boat/characters/sea_urchin.dart';
import 'package:up_boat/characters/sellable.dart';
import 'package:up_boat/characters/shark.dart';
import 'package:up_boat/characters/small_crab.dart';
import 'package:up_boat/characters/stone_fish.dart';
import 'package:up_boat/characters/story_item.dart';
import 'package:up_boat/characters/trash.dart';
import 'package:up_boat/components/checkpoint.dart';
import 'package:up_boat/components/collision_block.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/components/utils.dart';
import 'package:up_boat/up_boat.dart';

enum PlayerState {
  idle,
  swimming,
  switching,
  hit,
  appearing,
  disappearing,
  scubaidle,
  scubaswimming,
  scubaswitching,
  scubahit,
  finidle,
  finswimming,
  finswitching,
  finhit,
  finscubaidle,
  finscubaswimming,
  finscubaswitching,
  finscubahit
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({
    position,
    this.character = 'Swimmer',
  }) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation swimmingAnimation;
  late final SpriteAnimation switchingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  late final SpriteAnimation scubaidleAnimation;
  late final SpriteAnimation scubaswimmingAnimation;
  late final SpriteAnimation scubaswitchingAnimation;
  late final SpriteAnimation scubahitAnimation;

  late final SpriteAnimation finidleAnimation;
  late final SpriteAnimation finswimmingAnimation;
  late final SpriteAnimation finswitchingAnimation;
  late final SpriteAnimation finhitAnimation;

  late final SpriteAnimation finscubaidleAnimation;
  late final SpriteAnimation finscubaswimmingAnimation;
  late final SpriteAnimation finscubaswitchingAnimation;
  late final SpriteAnimation finscubahitAnimation;

  final double _gravity = 0;
  final double _jumpForce = 100;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  Vector2 previousPosition = Vector2.zero();
  bool isOnGround = false;
  bool flipped = false; //false=right
  bool isOnRoof = false;
  bool leftBlock = false;
  bool rightBlock = false;
  bool swimUpward = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  PositionComponent playCam = PositionComponent(position: Vector2.zero());
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double oxygenTimer = 5;
  double TimerCounter = 0;
  double accumulatedTime = 0;
  bool stunned = false;
  bool hurt = false;

  List<String> perks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;
    priority = 5;

    autoResize = true;
    size = Vector2.all(32);

    startingPosition = Vector2(position.x, position.y);
    playCam.position = startingPosition;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  void moveCam() {
    if (playCam.position.x > position.x &&
        (playCam.position.x - position.x).abs() > 50) {
      playCam.position.x = position.x + 49;
    }
    if (playCam.position.x < position.x &&
        (playCam.position.x - position.x).abs() > 50) {
      playCam.position.x = position.x - 49;
    }
    if (playCam.position.y < position.y &&
        (playCam.position.y - position.y).abs() > 50) {
      playCam.position.y = position.y - 49;
    }
    if (playCam.position.y > position.y &&
        (playCam.position.y - position.y).abs() > 50) {
      playCam.position.y = position.y + 49;
    }
  }

  @override
  void update(double dt) {
    if (gameRef.gamePaused) {
      super.update(dt);
      return;
    }

    gameRef.secondsElapsed += dt;
    accumulatedTime += dt;
    TimerCounter += dt;
    if (TimerCounter >= oxygenTimer) {
      gameRef.oxygen.reduceOxygen(1);
      TimerCounter = 0;
    }
    if (gameRef.oxygen.oxygen == 0) {
      _respawn();
    }

    if (gameRef.health.health == 0) {
      _respawn();
    }

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        if (!stunned) {
          _updatePlayerMovement(fixedDeltaTime);
        } else {
          velocity = Vector2.zero();
        }
        _checkHorizontalCollisions();
        // _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
        moveCam();
        previousPosition = position;
      }
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      gameRef.gamePaused = true;
      gameRef.onGameIdle();
      gameRef.overlays.add('Pause');
    }

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    verticalMovement += isDownKeyPressed ? 1 : 0;
    verticalMovement += isUpKeyPressed ? -1 : 0;

    // swimUpward = keysPressed.contains(LogicalKeyboardKey.space);

    if (perks.contains('fins')) {
      // print("Speed buff");
      verticalMovement *= 1.5;
      horizontalMovement *= 1.5;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void hurtPlayer(dynamic other) {
    if (!hurt) {
      add(ColorEffect(
        Color.fromRGBO(255, 0, 0, 0.494),
        opacityTo: 0.5, // Means, applies from 0% to 50% of the color
        EffectController(
            duration: 0.15, reverseDuration: 0.15, repeatCount: 10),
      ));
      other.collidedWithPlayer();
      Future.delayed(Duration(seconds: 3), () => hurt = false);
      hurt = true;
    }
  }

  //@override
  //bool onComponentTypeCheck(PositionComponent other) {
  //  if (other is Fish) {
  //    return false;
  //  }
  //  return super.onComponentTypeCheck(other);
  //}

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is JellyFish) {
        if (checkCollision(this, other)) {
          other.collidedWithPlayer();
          stunned = true;
          add(ColorEffect(
            Color.fromRGBO(255, 255, 255, 0.498),
            opacityTo: 0.5, // Means, applies from 0% to 50% of the color
            EffectController(
                duration: 0.15, reverseDuration: 0.15, repeatCount: 10),
          ));
          Future.delayed(Duration(seconds: 3), () => stunned = false);
        }

        // if (game.craftItems.containsKey(other.fruit)) {
        //   game.craftItems[other.fruit] = game.craftItems[other.fruit]! + 1;
        // } else {
        //   game.craftItems[other.fruit] = 1;
        // }
      }
      // if (other is Saw) _respawn();
      if (other is Money) other.collidedWithPlayer();
      if (other is Sellable) other.collidedWithPlayer();
      if (other is Consumable) other.collidedWithPlayer();
      if (other is Trash) other.collidedWithPlayer();
      if (other is Craft) other.collidedWithPlayer();
      if (other is Fish) other.collidedWithPlayer();
      if (other is StoryItem) other.collidedWithPlayer();
      if (other is Shark) {
        hurtPlayer(other);
      }
      if (other is PufferFish) {
        hurtPlayer(other);
      }
      if (other is StoneFish) {
        hurtPlayer(other);
      }
      if (other is SeaUrchin) {
        hurtPlayer(other);
      }
      if (other is SmallCrab) {
        hurtPlayer(other);
      }
      if (other is LargeCrab) {
        hurtPlayer(other);
      }
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('idle', 25);
    swimmingAnimation = _spriteAnimation('swim', 17);
    switchingAnimation = _spriteAnimation('switch', 12);
    hitAnimation = _spriteAnimation('hurt', 12)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7);

    scubaidleAnimation = _spriteAnimation('scuba_idle', 25);
    scubaswimmingAnimation = _spriteAnimation('scuba_swim', 17);
    scubaswitchingAnimation = _spriteAnimation('scuba_switch', 12);
    scubahitAnimation = _spriteAnimation('scuba_hurt', 12)..loop = false;

    finidleAnimation = _spriteAnimation('fin_idle', 25);
    finswimmingAnimation = _spriteAnimation('fin_swim', 17);
    finswitchingAnimation = _spriteAnimation('fin_switch', 12);
    finhitAnimation = _spriteAnimation('fin_hurt', 12)..loop = false;

    finscubaidleAnimation = _spriteAnimation('fin_scuba_idle', 25);
    finscubaswimmingAnimation = _spriteAnimation('fin_scuba_swim', 17);
    finscubaswitchingAnimation = _spriteAnimation('fin_scuba_switch', 12);
    finscubahitAnimation = _spriteAnimation('fin_scuba_hurt', 12)..loop = false;

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.swimming: swimmingAnimation,
      PlayerState.switching: switchingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
      PlayerState.scubaidle: scubaidleAnimation,
      PlayerState.scubaswimming: scubaswimmingAnimation,
      PlayerState.scubaswitching: scubaswitchingAnimation,
      PlayerState.scubahit: scubahitAnimation,
      PlayerState.finidle: finidleAnimation,
      PlayerState.finswimming: finswimmingAnimation,
      PlayerState.finswitching: finswitchingAnimation,
      PlayerState.finhit: finhitAnimation,
      PlayerState.finscubaidle: finscubaidleAnimation,
      PlayerState.finscubaswimming: finscubaswimmingAnimation,
      PlayerState.finscubaswitching: finscubaswitchingAnimation,
      PlayerState.finscubahit: finscubahitAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  Vector2 getSpriteSize(String state) {
    Vector2 spriteSize = Vector2.zero();
    switch (state) {
      case 'idle':
        spriteSize = Vector2(197, 282);
        break;
      case 'hurt':
        spriteSize = Vector2(192, 288);
        break;
      case 'switch':
        spriteSize = Vector2(236, 277);
        break;
      case 'swim':
        spriteSize = Vector2(271, 200);
        break;
      case 'scuba_idle':
        spriteSize = Vector2(197, 282);
        break;
      case 'scuba_hurt':
        spriteSize = Vector2(192, 288);
        break;
      case 'scuba_switch':
        spriteSize = Vector2(236, 277);
        break;
      case 'scuba_swim':
        spriteSize = Vector2(271, 200);
        break;
      case 'fin_idle':
        spriteSize = Vector2(206, 295);
        break;
      case 'fin_hurt':
        spriteSize = Vector2(205, 301);
        break;
      case 'fin_switch':
        spriteSize = Vector2(246, 290);
        break;
      case 'fin_swim':
        spriteSize = Vector2(285, 210);
        break;
      case 'fin_scuba_idle':
        spriteSize = Vector2(206, 295);
        break;
      case 'fin_scuba_hurt':
        spriteSize = Vector2(205, 301);
        break;
      case 'fin_scuba_switch':
        spriteSize = Vector2(246, 290);
        break;
      case 'fin_scuba_swim':
        spriteSize = Vector2(285, 210);
        break;
      default:
        break;
    }
    return spriteSize;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime:
            state == 'hurt' || state == 'scuba_hurt' || state == 'fin_hurt'
                ? stepTime / 2
                : stepTime,
        // textureSize: state == 'idle' || state == 'scuba_idle'
        //     ? Vector2(197, 282)
        //     : state == 'hurt' || state == 'scuba_hurt'
        //         ? Vector2(192, 288)
        //         : state == 'switch' || state == 'scuba_switch'
        //             ? Vector2(236, 277)
        //             : Vector2(271, 200),
        textureSize: getSpriteSize(state),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = perks.contains('fins') && perks.contains('scuba')
        ? PlayerState.finscubaidle
        : perks.contains('fins')
            ? PlayerState.finidle
            : perks.contains('scuba')
                ? PlayerState.scubaidle
                : PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      flipped = !flipped;
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      flipped = !flipped;
    }
    // if (velocity.y > 0 && scale.y < 0) {
    //   flipVertically();
    // } else if (velocity.y < 0 && scale.y > 0) {
    //   flipVertically();
    // }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = perks.contains('fins') && perks.contains('scuba')
          ? PlayerState.finscubaswimming
          : perks.contains('fins')
              ? PlayerState.finswimming
              : perks.contains('scuba')
                  ? PlayerState.scubaswimming
                  : PlayerState.swimming;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (leftBlock && horizontalMovement == -1) {
      null;
    } else if (rightBlock && horizontalMovement == 1) {
      null;
    } else {
      velocity.x = horizontalMovement * moveSpeed;
    }
    if (isOnGround && verticalMovement == 1) {
      null;
    } else if (isOnRoof && verticalMovement == -1) {
      null;
    } else {
      velocity.y = verticalMovement * moveSpeed;
    }

    position += velocity * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            if (horizontalMovement > 1 || horizontalMovement < -1) {
              position.x = previousPosition.x - hitbox.offsetX / 4;
            } else {
              position.x = previousPosition.x - hitbox.offsetX / 6;
            }
            rightBlock = true;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            if (horizontalMovement > 1 || horizontalMovement < -1) {
              position.x = previousPosition.x + hitbox.offsetX / 4;
            } else {
              position.x = previousPosition.x + hitbox.offsetX / 6;
            }
            leftBlock = true;
            break;
          }
        } else {
          leftBlock = false;
          rightBlock = false;
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        // print(block.x);
        // print(position.x);
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            if (verticalMovement > 1 || verticalMovement < -1) {
              position.y = previousPosition.y - hitbox.offsetY / 1.6;
            } else {
              position.y = previousPosition.y - hitbox.offsetY / 2.2;
            }
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            if (verticalMovement > 1 || verticalMovement < -1) {
              position.y = previousPosition.y + hitbox.offsetY / 1.6;
            } else {
              position.y = previousPosition.y + hitbox.offsetY / 2.2;
            }
            isOnRoof = true;
            break;
          }
        } else {
          isOnGround = false;
          isOnRoof = false;
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            // isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            // position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() async {
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = perks.contains('fins') && perks.contains('scuba')
        ? PlayerState.finscubahit
        : perks.contains('fins')
            ? PlayerState.finhit
            : perks.contains('scuba')
                ? PlayerState.scubahit
                : PlayerState.hit;

    gameRef.health.health = 100;
    gameRef.oxygen.oxygen = 100;
    gameRef.craftItems = [];
    gameRef.money.money = 0;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    game.overlays.add("End Level");
  }

  void endLevel() async {
    reachedCheckpoint = true;
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeDuration, () {
      game.loadNextLevel();
    });
  }

  void collidedwithEnemy() {
    _respawn();
  }
}
