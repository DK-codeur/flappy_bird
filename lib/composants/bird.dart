

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flappy_bird/flappy_game.dart';

const double GRAVITY = 0.25;
const double BIRD_HEIGHT = 35;
const double BIRD_WIDTH = 50;

class Bird {

  Rect birdRect;
  Sprite birdSprite;
  List<Sprite> sprites;
  int spriteIndex = 0;
  Timer timer;

  double birdMovement = 0;
  bool isJumping = false;

  final FlappyGame game;

  Bird({this.game}) {
    // birdSprite = Sprite("midflap.png");
    sprites = [Sprite("downflap.png"), Sprite("midflap.png"), Sprite("upflap.png")];

    timer = Timer(0.08, repeat: true, callback: () {
      spriteIndex += 1;
    });

    timer.start();

    birdRect = Rect.fromLTWH(50, game.screenSize.height/2, BIRD_WIDTH, BIRD_HEIGHT);
  }

  //** update
  void update(double t) {
    timer.update(t);

    if (isJumping == true) {
      birdMovement = -4;
      isJumping = false;
    } else {
      birdMovement = birdMovement + GRAVITY;
    }

    birdRect =  birdRect.translate(0, birdMovement);

  }

  //** render
  void render(Canvas canvas) {
    if (spriteIndex ==3 ) {
      spriteIndex = 0;
    }

    birdSprite = sprites[spriteIndex];

    //save canvas state
    canvas.save();

    //deplace l'origine du canvas
    canvas.translate(50 + (BIRD_WIDTH/2), birdRect.bottom - (BIRD_HEIGHT/2)); //35: bird Height, 50 (birdRect Left) 50/2 (birdRect Width)

    //appliquer la rotation
    canvas.rotate(birdMovement * 0.04);

    //affiche le bird
    birdSprite.renderRect(canvas, Rect.fromLTWH(0, 0, BIRD_WIDTH, BIRD_HEIGHT)); 

    //restore l'etat à son origine
    canvas.restore();

  }

  void onTap() {
    isJumping = true;
  }
}