import 'package:ember_quest_game/actors/water_enemy.dart';
import 'package:ember_quest_game/ember_quest.dart';
import 'package:ember_quest_game/objects/gound_block.dart';
import 'package:ember_quest_game/objects/platform_block.dart';
import 'package:ember_quest_game/objects/start.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<EmberQuestGame>, KeyboardHandler, CollisionCallbacks {
  EmberPlayer({required super.position}) : super(anchor: Anchor.center, size: Vector2.all(64));
  int horizontalDirection = 0;
  final double moveSpeed = 200;
  final Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  final Vector2 fromAbove = Vector2(0, -1);
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double terminalVelocity = 600;
  bool hasJump = false;
  bool hitByEnemy = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.12, textureSize: Vector2.all(16)),
    );
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    game.objectSpeed = 0;

    velocity.x = horizontalDirection * moveSpeed;
    velocity.y += gravity;

    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    if (hasJump) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJump = false;
    }
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    position += velocity * dt;
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection += -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection += 1;
    }
    hasJump = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();
        if (fromAbove.dot(collisionNormal) > .9) {
          isOnGround = true;
        }
        position += collisionNormal.scaled(separationDistance);
      }
    }
    if (other is Star) {
      other.removeFromParent();
    }
    if (other is WaterEnemy) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
    }
    add(OpacityEffect.fadeOut(EffectController(alternate: true, duration: 0.1, repeatCount: 6))
      ..onComplete = () {
        hitByEnemy = false;
      });
  }
}
