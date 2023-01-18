import 'package:ember_quest_game/ember_quest.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class WaterEnemy extends SpriteAnimationComponent with HasGameRef<EmberQuestGame> {
  final Vector2 velocity = Vector2.zero();
  double xOffset;
  final Vector2 gridPosition;
  WaterEnemy({required this.gridPosition, required this.xOffset})
      : super(anchor: Anchor.bottomLeft, size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    final waterImage = game.images.fromCache('water_enemy.png');
    animation = SpriteAnimation.fromFrameData(waterImage,
        SpriteAnimationData.sequenced(amount: 2, stepTime: .7, textureSize: Vector2.all(16)));

    position = Vector2(gridPosition.x * size.x + xOffset, game.size.y - gridPosition.y * size.y);
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(MoveEffect.by(
        Vector2(-2 * size.x, 0), EffectController(duration: 3, alternate: true, infinite: true)));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();
    super.update(dt);
  }
}
