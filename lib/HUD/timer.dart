import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:up_boat/up_boat.dart';

class GlobalTimer extends TimerComponent with HasGameRef<PixelAdventure> {
  GlobalTimer() : super(period: 0.0);

  final margin = 8;
  final buttonSize = 25;

  final regular = TextPaint(
    style: TextStyle(
      fontSize: 16.0,
      fontFamily: "kodemono",
      color: BasicPalette.black.color,
    ),
  );

  late TextComponent text;

  @override
  FutureOr<void> onLoad() {
    text = TextComponent(
        text: "0 : 00",
        textRenderer: regular,
        key: key,
        position: Vector2(
          margin.toDouble() + 15 * buttonSize,
          margin.toDouble(),
        ));

    add(text);
    // Svg.load('GUI/9.svg').then((svg) {
    //   final size = Vector2.all(100);
    //   add(SvgComponent(svg: svg, size: size));
    // });

    priority = 10;
    return super.onLoad();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  void update(double dt) {
    text.text = formattedTime(timeInSecond: game.secondsElapsed.toInt());
    super.update(dt);
  }
}
