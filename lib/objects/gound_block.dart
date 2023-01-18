import 'dart:math';

import 'package:ember_quest_game/ember_quest.dart';
import 'package:ember_quest_game/managers/segment_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GroundBlock extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 velocity = Vector2.zero();
  final Vector2 gridPosition;
  double xOffset;
  GroundBlock({required this.gridPosition, required this.xOffset})
      : super(size: Vector2(64, 64), anchor: Anchor.bottomLeft);

  final UniqueKey blockKey = UniqueKey();
  @override
  Future<void> onLoad() async {
    final groundImage = game.images.fromCache('ground.png');
    sprite = Sprite(groundImage);
    position = Vector2(size.x * gridPosition.x + xOffset, game.size.y - size.y * gridPosition.y);
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = blockKey;
      game.lastBlockXPosition = size.x + position.x;
    }
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) {
      removeFromParent();
      if (gridPosition.x == 0) {
        game.loadGameSegments(Random().nextInt(segments.length), game.lastBlockXPosition);
      }
    }
    if (gridPosition.x == 9) {
      if (game.lastBlockKey == blockKey) {
        game.lastBlockXPosition = position.x + size.x - 10;
      }
    }
    super.update(dt);
  }
}