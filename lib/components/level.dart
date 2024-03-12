import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:up_boat/characters/consumable.dart';
import 'package:up_boat/characters/corals.dart';
import 'package:up_boat/characters/craft.dart';
import 'package:up_boat/characters/fish.dart';
import 'package:up_boat/characters/grass.dart';
import 'package:up_boat/characters/kelp.dart';
import 'package:up_boat/characters/large_crab.dart';
import 'package:up_boat/characters/money.dart';
import 'package:up_boat/characters/plant.dart';
import 'package:up_boat/characters/puffer_fish.dart';
import 'package:up_boat/characters/rocks.dart';
import 'package:up_boat/characters/sea_urchin.dart';
import 'package:up_boat/characters/sellable.dart';
import 'package:up_boat/characters/small_crab.dart';
import 'package:up_boat/characters/stone_fish.dart';
import 'package:up_boat/characters/story_item.dart';
import 'package:up_boat/characters/trash.dart';
import 'package:up_boat/components/background_tile.dart';
import 'package:up_boat/characters/jelly_fish.dart';
import 'package:up_boat/characters/shark.dart';
import 'package:up_boat/components/checkpoint.dart';
import 'package:up_boat/components/collision_block.dart';
import 'package:up_boat/characters/player.dart';
import 'package:up_boat/up_boat.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32),
        atlasMaxX: 1024, atlasMaxY: 1024);

    final image =
        await game.images.fromCache('Background/Underwater Background.png');
    final bg = SpriteComponent(
        sprite: Sprite(
      image,
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(
          32.0 * level.tileMap.map.height, 32.0 * level.tileMap.map.width),
    ));

    add(bg);

    add(level);

    // _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
      );
      add(backgroundTile);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Consumable':
            final consume = Consumable(
              consume_type: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(consume);
            break;
          case 'Trash':
            final trash = Trash(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(trash);
            break;
          case 'Sellable':
            final sellable = Sellable(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(sellable);
            break;
          case 'Money':
            final money = Money(
              money_type: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(money);
            break;
          case 'Story':
            final money = StoryItem(
              story_type: spawnPoint.name,
              story_dialog: spawnPoint.properties.has('dialog')
                  ? spawnPoint.properties.byName['dialog']!.value.toString()
                  : "",
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(money);
            break;
          case 'Craft':
            final craft = Craft(
              item_type: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(craft);
            break;
          case 'Grass':
            final grass = Grass(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(grass);
            break;
          case 'Plant':
            final plant = Plant(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(plant);
            break;
          case 'Jelly Fish':
            final jellyfish = JellyFish(
              jelly_fish: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(jellyfish);
            break;
          case 'Urchin':
            final urchin = SeaUrchin(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(urchin);
            break;
          case 'Crab':
            final crab = spawnPoint.name == 'large'
                ? LargeCrab(
                    position: Vector2(spawnPoint.x, spawnPoint.y),
                    size: Vector2(spawnPoint.width, spawnPoint.height),
                  )
                : SmallCrab(
                    position: Vector2(spawnPoint.x, spawnPoint.y),
                    size: Vector2(spawnPoint.width, spawnPoint.height),
                    offNeg: 3,
                    offPos: 4);
            add(crab);
            break;
          case 'Rock':
            final rock = Rock(
              rock_type: spawnPoint.name,
              position: Vector2(
                  spawnPoint.x - (spawnPoint.name == 'Small' ? 12 : 40),
                  spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(rock);
            break;
          case 'Coral':
            final coral = Corals(
              coral_type: spawnPoint.name,
              position: Vector2(spawnPoint.x - 32, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(coral);
            break;
          case 'Kelp':
            final kelp = Kelp(
              placement: spawnPoint.name,
              position: Vector2(spawnPoint.x - 50, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(kelp);
            for (int i = 0; i < 7; i++) {
              add(Kelp(
                placement: spawnPoint.name,
                position: Vector2(spawnPoint.x - 50, spawnPoint.y - 150 * i),
                size: Vector2(spawnPoint.width, spawnPoint.height),
              ));
            }
          case 'Fish':
            final fishes = Fish(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
                offNeg: 3,
                offPos: 4);
            add(fishes);
            break;
          case 'Bad Fish':
            final bad_fishes = spawnPoint.name == 'stone'
                ? StoneFish(
                    position: Vector2(spawnPoint.x, spawnPoint.y),
                    size: Vector2(spawnPoint.width, spawnPoint.height),
                    offNeg: 3,
                    offPos: 4)
                : PufferFish(
                    position: Vector2(spawnPoint.x, spawnPoint.y),
                    size: Vector2(spawnPoint.width, spawnPoint.height),
                    offNeg: 3,
                    offPos: 4);
            add(bad_fishes);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Shark':
            final shark = Shark(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: 7,
              offPos: 10,
            );
            add(shark);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Ground':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Border':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
