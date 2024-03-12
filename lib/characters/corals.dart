import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:up_boat/up_boat.dart';

class Corals extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String coral_type;
  Corals({
    this.coral_type = 'Elkhorn',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final List<String> elkhorns = [
    "red_elkhorn.png",
    "elkhorn.png",
    "blue_elkhorn.png",
    "yellow_elkhorn.png"
  ];
  final List<String> pipes = [
    "red_coral.png",
    "pipe_coral.png",
    "yellow_coral.png"
  ];
  final List<String> brains = ["blue_brain.png", "brain_coral.png"];

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 0;
    // size = Vector2.all(32);

    final _random = new Random();
    if (coral_type == 'Elkhorn') {
      String coral_type = "";
      coral_type = elkhorns[_random.nextInt(elkhorns.length)];
      // size = Vector2.all(16);

      sprite = Sprite(game.images.fromCache('Background/$coral_type'));
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
    } else if (coral_type == 'Pipe') {
      String coral_type = "";
      coral_type = pipes[_random.nextInt(pipes.length)];
      // size = Vector2.all(16);

      sprite = Sprite(game.images.fromCache('Background/$coral_type'));
      add(MoveEffect.by(
          Vector2(-1, 0),
          EffectController(
              duration: 1.5,
              curve: Curves.bounceInOut,
              reverseDuration: 1.5,
              infinite: true)));
      if (_random.nextBool()) {
        flipHorizontallyAroundCenter();
      }
    } else {
      String coral_type = "";
      coral_type = brains[_random.nextInt(brains.length)];
      // size = Vector2.all(16);

      sprite = Sprite(game.images.fromCache('Background/$coral_type'));
      if (_random.nextBool()) {
        flipHorizontallyAroundCenter();
      }
    }
    return super.onLoad();
  }
}
