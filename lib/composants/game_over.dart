

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flappy_bird/flappy_game.dart';

class GameOver {

  Rect messageRect;
  Sprite messageSprite;

  final FlappyGame game;

  GameOver({this.game}) {
    messageSprite = Sprite("message.png");
    messageRect = Rect.fromCenter(
      center: Offset(game.screenSize.width/2, game.screenSize.height/2), 
      width: 276, 
      height: 400
    );
  }

  void update(double t) {}

  void render(Canvas canvas) {
    messageSprite.renderRect(canvas, messageRect);
  }
}