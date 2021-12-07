

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flappy_bird/flappy_game.dart';

const double PIPE_WIDTH = 70;
const double PIP_HEAD_HEIGHT = 24;
const double SPACE_BETWEEN_PIPE = 180;

const double PIPE_MOVEMENT = 130;

class Pipes {

  Rect topPipeBodyRect;
  Rect topPipeHeadRect;  
  Sprite topPipeBodySprite;
  Sprite topPipeHeadSprite;

  Rect bottomPipeBodyRect;
  Rect bottomPipeHeadRect;
  Sprite bottomPipeBodySprite;
  Sprite bottomPipeHeadSprite;

  final FlappyGame game;

  Pipes({this.game}){
    //sprite du pipe haut
    topPipeBodySprite = Sprite("pipe_body.png");
    topPipeHeadSprite = Sprite("pipe_head.png");

    //sprite du pipe bas
    bottomPipeBodySprite = Sprite("pipe_body.png");
    bottomPipeHeadSprite = Sprite("pipe_head.png");

    double topPipeBodyHeight = 300;


    //RECT du pipe du haut
    topPipeBodyRect = Rect.fromLTWH(game.screenSize.width / 2, 0, PIPE_WIDTH, topPipeBodyHeight);
    topPipeHeadRect = Rect.fromLTWH(game.screenSize.width / 2, topPipeBodyHeight, PIPE_WIDTH + 2, PIP_HEAD_HEIGHT);

    //REct du pipe du bas
    bottomPipeHeadRect = Rect.fromLTWH(
      game.screenSize.width/2, 
      topPipeBodyHeight + PIP_HEAD_HEIGHT + SPACE_BETWEEN_PIPE, 
      PIPE_WIDTH + 2, 
      PIP_HEAD_HEIGHT
    );

    bottomPipeBodyRect = Rect.fromLTWH(
      game.screenSize.width /2, 
      topPipeBodyHeight + PIP_HEAD_HEIGHT + SPACE_BETWEEN_PIPE + PIP_HEAD_HEIGHT, 
      PIPE_WIDTH, 
      game.screenSize.height - (topPipeBodyHeight + PIP_HEAD_HEIGHT + SPACE_BETWEEN_PIPE + PIP_HEAD_HEIGHT)
    );
  }

  void update(double t) {
    topPipeBodyRect = topPipeBodyRect.translate(-t * PIPE_MOVEMENT, 0);
    topPipeHeadRect = topPipeHeadRect.translate(-t * PIPE_MOVEMENT, 0);

    bottomPipeHeadRect = bottomPipeHeadRect.translate(-t * PIPE_MOVEMENT, 0);
    bottomPipeBodyRect = bottomPipeBodyRect.translate(-t * PIPE_MOVEMENT, 0);
  }

  void render(Canvas canvas) {
    topPipeBodySprite.renderRect(canvas, topPipeBodyRect); //affiche le body du top pipe
    topPipeHeadSprite.renderRect(canvas, topPipeHeadRect);

    bottomPipeHeadSprite.renderRect(canvas, bottomPipeHeadRect);
    bottomPipeBodySprite.renderRect(canvas, bottomPipeBodyRect);
  }
}