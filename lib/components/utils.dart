import 'package:flutter_secure_storage/flutter_secure_storage.dart';

bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = playerY;

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

bool checkCollisionX(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerWidth = hitbox.width;

  final blockX = block.x;
  final blockWidth = block.width;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;

  // print(playerX > blockX);
  // print(fixedX < blockX + blockWidth && fixedX + playerWidth > blockX);

  return (fixedX < blockX + blockWidth && fixedX + playerWidth > blockX);
}

bool checkCollisionY(player, block) {
  final playerY = player.position.y;
  final playerHeight = player.height;

  final blockY = block.y;
  final blockHeight = block.height;

  final fixedY = playerY;

  print(blockY);
  print(blockY - blockHeight);
  print(blockY + blockHeight);

  // print(playerY + playerHeight > blockY)
  print(fixedY < blockY + blockHeight && playerY + playerHeight > blockY);

  return (fixedY < blockY + blockHeight && playerY + playerHeight > blockY);
}

void deleteAll() {
  final storage = new FlutterSecureStorage();
  storage.deleteAll();
}

void saveScore(
    String score, String time, List<String> perks, int levelIndex) async {
  final storage = new FlutterSecureStorage();
  DateTime now = DateTime.now();
  String level = "";
  if (levelIndex == 0) {
    level = "A ROCKY START";
  } else if (levelIndex == 1) {
    level = "I SEE TEETH";
  }
  storage.containsKey(key: "score_$level").then((exists) {
    if (exists) {
      storage.read(key: "score_$level").then((value) {
        if (value == null) {
          value =
              score + "|" + time + "|" + now.toString() + "|" + perks.join('-');
        } else {
          value += "," +
              score +
              "|" +
              time +
              "|" +
              now.toString() +
              "|" +
              perks.join('-');
        }
        storage.write(key: "score_$level", value: value);
      });
    } else {
      String value = score + "|" + time + "|" + perks.join('-');
      storage.write(key: "score_$level", value: value);
    }
  });
}

Future<List<String>> loadPerks(int levelIndex) async {
  List<String> perks = [];
  String level = "";
  if (levelIndex == 0) {
    level = "A ROCKY START";
  } else if (levelIndex == 1) {
    level = "I SEE TEETH";
  }
  final storage = new FlutterSecureStorage();
  if (await storage.containsKey(key: "score_$level")) {
    String? all_scores = await storage.read(key: "score_$level");
    if (all_scores != null) {
      String savedperks = all_scores.split(',').last.split('|').last;
      if (savedperks.isNotEmpty) {
        perks = savedperks.split('-');
      }
    }
  }
  return perks;
}

Future<List<Map<int, List<String>>>> getAllScores() async {
  final storage = new FlutterSecureStorage();
  List<Map<int, List<String>>> allScores = [];
  Map<String, String> allData = await storage.readAll();
  List.generate(allData.length, (index) {
    allScores.add({
      index + 1: [
        allData.keys.toList()[index].split('_').last,
        allData.values.toList()[index].split('|')[0],
        allData.values.toList()[index].split('|')[1]
      ]
    });
  });
  return allScores;
}

Future<List<String>> loadLevels() async {
  final storage = new FlutterSecureStorage();
  List<String> completedLevels = [];
  List<String> levels = (await storage.readAll()).keys.toList();
  levels.forEach((element) {
    if (element.toLowerCase().contains('rock') &&
        !completedLevels.contains("A ROCKY START")) {
      completedLevels.add("A ROCKY START");
    } else if (element.toLowerCase().contains('teeth') &&
        !completedLevels.contains("I SEE TEETH")) {
      completedLevels.add("I SEE TEETH");
    }
  });
  return completedLevels;
}
