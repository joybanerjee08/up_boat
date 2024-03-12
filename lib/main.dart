import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:up_boat/overlay/choose_level.dart';
import 'package:up_boat/overlay/crafting.dart';
import 'package:up_boat/overlay/dialog_menu.dart';
import 'package:up_boat/overlay/story_dialog.dart';
import 'package:up_boat/overlay/end_level.dart';
import 'package:up_boat/overlay/inventory_menu.dart';
import 'package:up_boat/overlay/pause_menu.dart';
import 'package:up_boat/overlay/scoreboard.dart';
import 'package:up_boat/overlay/settings_menu.dart';
import 'package:up_boat/overlay/start_menu.dart';
import 'package:up_boat/overlay/story_item_dialog.dart';
import 'package:up_boat/overlay/thankyou.dart';
import 'package:up_boat/overlay/tutorial.dart';
import 'package:up_boat/up_boat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    GameWidget<PixelAdventure>.controlled(
      gameFactory: PixelAdventure.new,
      overlayBuilderMap: {
        'Start': (_, game) => MainMenu(game: game),
        'Inventory': (_, game) => InventoryMenu(game: game),
        'End Level': (_, game) => EndLevel(game: game),
        'Pause': (_, game) => PauseMenu(game: game),
        'Dialog': (_, game) => LevelDialog(game: game),
        'Story': (_, game) => StoryDialog(game: game),
        'Level': (_, game) => ChooseLevel(game: game),
        'Settings': (_, game) => SettingsMenu(game: game),
        'Score': (_, game) => Scoreboard(game: game),
        'Tutorial': (_, game) => Tutorial(game: game),
        'Crafting': (_, game) => Crafting(game: game),
        'StoryItem': (_, game) => StoryItemDialog(game: game),
        'Thank You': (_, game) => ThankyouDialog(game: game),
      },
      initialActiveOverlays: const ['Start'],
    ),
  );
}
