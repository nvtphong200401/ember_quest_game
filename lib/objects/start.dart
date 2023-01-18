import 'package:ember_quest_game/ember_quest.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Star extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 velocity = Vector2.zero();
  final Vector2 gridPosition;
  double xOffset;
  Star({required this.gridPosition, required this.xOffset})
      : super(anchor: Anchor.center, size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    final starImage = game.images.fromCache('star.png');
    sprite = Sprite(starImage);

    position = Vector2(gridPosition.x * size.x + xOffset, game.size.y - (gridPosition.y * size.y));
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
            duration: .75, reverseDuration: .5, infinite: true, curve: Curves.easeInOut)));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();
    super.update(dt);
  }
}
