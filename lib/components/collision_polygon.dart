import 'package:flame/components.dart';

class CollisionPolygon extends PolygonComponent {
  bool isPlatform;
  CollisionPolygon({
    vertices,
    this.isPlatform = false,
  }) : super(vertices) {
    // debugMode = true;
  }
}
