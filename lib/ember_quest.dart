import 'dart:developer';

import 'package:ember_quest_game/actors/ember.dart';
import 'package:ember_quest_game/actors/water_enemy.dart';
import 'package:ember_quest_game/managers/segment_manager.dart';
import 'package:ember_quest_game/objects/gound_block.dart';
import 'package:ember_quest_game/objects/platform_block.dart';
import 'package:ember_quest_game/objects/start.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class EmberQuestGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  EmberQuestGame();
  late EmberPlayer _ember;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);
    initalizeGame();
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    // xPositionOffset is the starting offset
    for (var block in segments[segmentIndex]) {
      switch (block.type) {
        case GroundBlock:
          add(GroundBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case PlatformBlock:
          add(PlatformBlock(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case Star:
          add(Star(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        case WaterEnemy:
          add(WaterEnemy(gridPosition: block.gridPosition, xOffset: xPositionOffset));
          break;
        default:
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void initalizeGame() {
    // 10 block in a segment * 64 pixels each block = 640 pixels each segment
    // game size = canvasSize
    final segmentsToLoad = (size.x / 640).ceil();
    log('$segmentsToLoad');
    //
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i < segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }
    _ember = EmberPlayer(position: Vector2(128, canvasSize.y - 128));
    add(_ember);
  }
}
