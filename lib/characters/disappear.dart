import 'package:flame/components.dart';
import 'package:up_boat/up_boat.dart';

class disappear extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure> {
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Collected.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
