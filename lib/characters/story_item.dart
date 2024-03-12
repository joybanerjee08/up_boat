import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/characters/disappear.dart';
import 'package:up_boat/components/custom_hitbox.dart';
import 'package:up_boat/up_boat.dart';

class StoryItem extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String story_type;
  final String story_dialog;
  StoryItem({
    this.story_type = 'letter',
    this.story_dialog = '',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 2,
    offsetY: 2,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 4;

    size = Vector2.all(16);

    /* add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    ); */
    add(RectangleHitbox(collisionType: CollisionType.passive));
    sprite = Sprite(
      game.images.fromCache('Items/Story/$story_type.png'),
    );
    add(MoveEffect.by(
        Vector2(0, 3),
        EffectController(
            duration: 1,
            curve: Curves.bounceInOut,
            reverseDuration: 1,
            infinite: true)));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!game.muteSound) {
      FlameAudio.play('zip.wav', volume: game.soundVolume);
    }

    print(story_dialog);

    game.triggerDialog(story_dialog);
    sprite = null;
    add(disappear());
    Future.delayed(Duration(milliseconds: 300), () => removeFromParent());
  }
}
