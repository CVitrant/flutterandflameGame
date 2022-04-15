import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player-sprite.png');
    position = gameRef.size / 2;
    width = 80;
    height = 130;
    anchor = Anchor.center;
    priority = 100;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    player = Player();
    add(player);
    add(MyParallaxComponent());
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }
}

class MyParallaxComponent extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('background.png'),
      ],
      baseVelocity: Vector2(0, -80),
      velocityMultiplierDelta: Vector2(1.0, 1.8),
      repeat: ImageRepeat.repeat,
    );
  }
}

class Laser extends SpriteComponent {
  final double _speed = 200;

  Laser({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  });

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, -1) * _speed * dt;

    if (position.y < 0) {
      remove(this);
    }
  }
}
