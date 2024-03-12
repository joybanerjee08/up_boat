import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:up_boat/up_boat.dart';

class Rock extends SpriteComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final rock_type;
  Rock({
    this.rock_type = "Small",
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final List<String> smallRock = [
    "rock1.png",
    "rock2.png",
    "rock3.png",
    "rock4.png",
    "rock5.png"
  ];
  final List<String> largeRock = [
    "large_rock1.png",
    "large_rock2.png",
    "large_rock3.png",
    "large_rock4.png",
    "large_rock5.png",
    "large_rock6.png"
  ];

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 10;

    final _random = new Random();
    if (rock_type == 'Small') {
      String rock_type = "";
      rock_type = smallRock[_random.nextInt(smallRock.length)];
      size = Vector2.all(16);

      sprite = Sprite(game.images.fromCache('Background/$rock_type'));
      if (_random.nextBool()) {
        flipHorizontallyAroundCenter();
      }
    } else {
      String rock_type = "";
      rock_type = largeRock[_random.nextInt(largeRock.length)];
      size = Vector2.all(48);

      sprite = Sprite(game.images.fromCache('Background/$rock_type'));
      if (_random.nextBool()) {
        flipHorizontallyAroundCenter();
      }
    }
    return super.onLoad();
  }
}
