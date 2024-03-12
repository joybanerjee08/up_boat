import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:up_boat/HUD/armor.dart';
import 'package:up_boat/HUD/health.dart';
import 'package:up_boat/HUD/inventory_button.dart';
import 'package:up_boat/HUD/money.dart';
import 'package:up_boat/HUD/oxygen.dart';
import 'package:up_boat/HUD/timer.dart';
import 'package:up_boat/characters/player.dart';
import 'package:up_boat/components/level.dart';
import 'package:up_boat/components/utils.dart';

class CollectableItems {
  String name;
  int count;
  String type;
  CollectableItems(this.name, this.count, this.type);
}

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasQuadTreeCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => Color(0xFF64FDE3);
  late CameraComponent cam;
  Player player = Player(character: 'Swimmer');
  late JoystickComponent joystick;
  bool showControls = false;
  double soundVolume = 0.5;
  double musicVolume = 0.5;
  bool muteSound = false;
  List<String> levelNames = ['Level 1', 'Level 2'];
  int currentLevelIndex = 0;
  List<CollectableItems> craftItems = [];
  int inventory_limit = 10;
  ArmorBar armor = ArmorBar();
  HealthBar health = HealthBar();
  OxygenBar oxygen = OxygenBar();
  MoneyCount money = MoneyCount();
  late Level currentLevel;
  bool gamePaused = true;
  List<String> finishedLevels = [];
  String currentDialog = "";
  List<String> levelNameDialog = [
    "LEVEL 1 : A ROCKY START",
    "LEVEL 2 : I SEE TEETH"
  ];
  List<String> stories = [
    "Just as the scientists of the past predicted, oceans have risen, submering many of the bustling towns and cities. With this, all the trash have been mixed with the ocean too. You're a marine scavenger, and you make your livelihood by collecting stuff from the ocean and selling them for recycling at the Redpod. Sometimes you find gold and sometimes you find sharks, your life goes on...",
    "Another day in ocean, today you explore an underwater forest with many hidden valuable items. But be careful, hiding amongst the forest is also something very sinister ! Good Luck."
  ];
  double secondsElapsed = 0;
  bool gameNotStarted = true;
  late List<Map<int, List<String>>> allScores;

  Map<List<String>, String> recipeTable = {
    ["blade", "rubber_sheet"]: "fins",
    ["fiber", "rubber_sheet"]: "scuba",
    ["mask", "rubber_sheet", "cannister"]: "oxygen mask",
    ["cannister", "blade", "motor", "metal", "battery", "wire"]: "jet",
    ["fiber", "metal", "pipe", "rubber_sheet"]: "armor",
    ["fiber", "rubber_sheet", "metal"]: "large bag",
    ["battery", "wire", "Bulb", "pipe"]: "torch"
  };

  bool inventoryContains(String name) {
    return craftItems.any((element) => element.name == name);
  }

  int inventoryCount() {
    return craftItems.fold(
        0, (previousValue, element) => previousValue + element.count);
  }

  int inventoryIndex(String name) {
    int index = -1;
    for (int i = 0; i < craftItems.length; i++) {
      if (craftItems[i].name == name) {
        index = i;
        break;
      }
    }
    return index;
  }

  void resetLevel() {
    removeAll([cam, currentLevel]);
    _loadLevel();
    player.collidedwithEnemy();
    craftItems = [];
  }

  late AudioPlayer backgroundMusic;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    await FlameAudio.audioCache.loadAll([
      'press.wav',
      'zip.wav',
      'shock.wav',
      'weld.wav',
      'breath.wav',
      'small_hurt.wav',
      'big_hurt.wav'
    ]);
    // debugMode = true;

    backgroundMusic =
        await FlameAudio.playLongAudio('game_menu.mp3', volume: musicVolume);
    await backgroundMusic.setReleaseMode(ReleaseMode.loop);
    await backgroundMusic.setVolume(musicVolume);

    initializeCollisionDetection(
        mapDimensions: const Rect.fromLTWH(0, 0, 1024, 1024),
        minimumDistance: 10,
        maxObjects: 100);

    finishedLevels = await loadLevels();

    _loadLevel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    if (muteSound) {
      backgroundMusic.setVolume(0);
    } else {
      backgroundMusic.setVolume(musicVolume);
    }
    super.update(dt);
  }

  void playClick() {
    if (!muteSound) {
      FlameAudio.play('press.wav', volume: soundVolume);
    }
  }

  void changeBGM() async {
    if (currentLevelIndex == 0) {
      await backgroundMusic.stop();
      await backgroundMusic.release();
      backgroundMusic = await FlameAudio.playLongAudio('rocky_start.mp3',
          volume: musicVolume);
      await backgroundMusic.setReleaseMode(ReleaseMode.loop);
      await backgroundMusic.setVolume(musicVolume);
    } else if (currentLevelIndex == 1) {
      await backgroundMusic.stop();
      await backgroundMusic.release();
      backgroundMusic = await FlameAudio.playLongAudio('kelp_forest.mp3',
          volume: musicVolume);
      await backgroundMusic.setReleaseMode(ReleaseMode.loop);
      await backgroundMusic.setVolume(musicVolume);
    } else {
      await backgroundMusic.stop();
      await backgroundMusic.release();
      backgroundMusic =
          await FlameAudio.playLongAudio('game_menu.mp3', volume: musicVolume);
      await backgroundMusic.setReleaseMode(ReleaseMode.loop);
      await backgroundMusic.setVolume(musicVolume);
    }
  }

  void resetBGM() async {
    await backgroundMusic.stop();
    await backgroundMusic.release();
    backgroundMusic =
        await FlameAudio.playLongAudio('game_menu.mp3', volume: musicVolume);
    await backgroundMusic.setReleaseMode(ReleaseMode.loop);
    await backgroundMusic.setVolume(musicVolume);
  }

  void onGameIdle() {
    collisionDetection.broadphase.tree.optimize();
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void triggerDialog(String dialog) {
    currentDialog = dialog;
    overlays.add('StoryItem');
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      overlays.add('Dialog');
      resetLevel();
      changeBGM();
    } else {
      gameNotStarted = true;
      gamePaused = true;
      overlays.add('Thank You');
      currentLevelIndex = 0;
      resetLevel();
      resetBGM();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      currentLevel = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: currentLevel,
        width: 480,
        height: 240,
      );
      cam.follow(player.playCam, snap: true);
      cam.viewfinder.anchor = Anchor.center;

      cam.viewport.add(InventoryButton());
      cam.viewport.add(armor);
      cam.viewport.add(health);
      cam.viewport.add(oxygen);
      cam.viewport.add(money);
      cam.viewport.add(GlobalTimer());

      addAll([cam, currentLevel]);
    });
  }
}
