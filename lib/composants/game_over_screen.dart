

import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flappy_bird/flappy_game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOverScreen{

  Rect messageRect;
  Sprite messageSprite;
  final int score;
  int highScore;

  TextConfig scoreTextconfig;
  TextConfig highScoreTextconfig;
  TextConfig authorTextconfig;

  final FlappyGame game;

  GameOverScreen({this.game, this.score}) {
    messageSprite = Sprite("message.png");
    messageRect = Rect.fromCenter(
      center: Offset(game.screenSize.width/2, game.screenSize.height/2), 
      width: 276, 
      height: 400
    );

    highScore = 0;

    scoreTextconfig = TextConfig(
      fontFamily: "flappyFont",
      fontSize: 35,
      color: Colors.white
    );

    highScoreTextconfig = TextConfig(
      fontFamily: "flappyFont",
      fontSize: 35,
      color: Colors.amber
    );

    authorTextconfig = TextConfig(
      fontSize: 15,
      color: Colors.white
    );

    getHightScore();
  }

  void update(double t) {}

  void render(Canvas canvas) {
    messageSprite.renderRect(canvas, messageRect);

    //afficher score
    scoreTextconfig.render(
      canvas, 
      "SCORE: $score", 
      Position(game.screenSize.width/2, game.screenSize.height / 10),
      anchor: Anchor.center
    );

    //afficher meilleur score
    highScoreTextconfig.render(
      canvas, 
      "HIGHT SCORE: $highScore", 
      Position(game.screenSize.width/2, game.screenSize.height / 6),
      anchor: Anchor.center
    );

    authorTextconfig.render(
      canvas, 
      "*by DK-codeur*", 
      Position(game.screenSize.width/2, game.screenSize.height - 150),
      anchor: Anchor.center
    );
    
  }

  void getHightScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt("hightScore") ?? 0;
  }
}