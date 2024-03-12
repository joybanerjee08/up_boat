import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:up_boat/up_boat.dart';

class InventoryButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  InventoryButton();

  final margin = 8;
  final buttonSize = 20.0;
  double previousTime = 0;

  @override
  FutureOr<void> onLoad() {
    previousTime = 0;
    size = Vector2(64, 64);
    sprite = Sprite(game.images.fromCache('HUD/inventory.png'));
    position = Vector2(
      margin.toDouble(),
      margin.toDouble(),
    );
    size = Vector2(buttonSize, buttonSize);
    priority = 10;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.inventoryCount() >= gameRef.inventory_limit) {
      if (gameRef.secondsElapsed - previousTime > 2) {
        add(ColorEffect(
          Color.fromRGBO(199, 26, 26, 0.494),
          opacityTo: 0.5, // Means, applies from 0% to 50% of the color
          EffectController(
              duration: 0.15, reverseDuration: 0.15, repeatCount: 10),
        ));
        previousTime = gameRef.secondsElapsed;
      }
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.overlays.add('Inventory');
    super.onTapDown(event);
  }
}
