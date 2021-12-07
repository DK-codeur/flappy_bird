
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/time.dart';
import 'package:flappy_bird/composants/background.dart';
import 'package:flappy_bird/composants/base.dart';
import 'package:flappy_bird/composants/bird.dart';
import 'package:flappy_bird/composants/pipes.dart';

class FlappyGame extends Game with TapDetector {
  Size screenSize;
  Background background;
  // Base base;
  List<Base> baseList;
  // Pipes pipes;
  List<Pipes> pipesList = [];
  Timer timer;
  Bird bird;

  FlappyGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(game: this);
    createBase();
    // pipes = Pipes(game: this);
    timer = Timer(2, repeat: true, callback: (){
      Pipes newPipes = Pipes(game: this);
      pipesList.add(newPipes);

    });

    bird = Bird(game: this);

    timer.start();
  }


  //** render
  @override 
  void render(Canvas canvas) {
    background.render(canvas);

    // pipes.render(canvas);
    pipesList.forEach((Pipes pipes) { 
      pipes.render(canvas);
    });

    // base.render(canvas);
    baseList.forEach((Base base) { 
      base.render(canvas);
    });

    //afficher le bird
    bird.render(canvas);

  }

  //** update
  @override
  void update(double t) {
    timer.update(t);

    // base.update(t);
    baseList.forEach((Base base) {
      base.update(t);
    });

    baseList.removeWhere((Base base) => base.isVisible == false);

    if (baseList.length < 2) {
      createBase();
    }

    //deplacement des tubes
    // pipes.update(t);
    pipesList.forEach((Pipes pipes) { 
      pipes.update(t);
    });

    //supprime les pipe non visible
    pipesList.removeWhere((Pipes pipes) => pipes.isVisible == false);

    bird.update(t);

    gameOver();
  }

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
  }

  void createBase() {

    // base = Base(game: this);
    baseList = []; 
    Base firstBase = Base(game: this, leftPosition: 0);
    Base secondBase = Base(game: this, leftPosition: screenSize.width);

    baseList.add(firstBase);
    baseList.add(secondBase);
  }

  //** ontap
  @override
  void onTap() {
    print("#### onTap");
    bird.onTap();
    super.onTap();
  }

  void gameOver() {
    //check si le bird a toucher les tubes
    pipesList.forEach((Pipes pipes) { 
      if (pipes.hasCollided(bird.birdRect)) {
        print("##### Game over");
      }
    });

    //collisio avec le sol
    baseList.forEach((Base base) {
      if (base.hasCollided(bird.birdRect)) {
        print("##### a toucher le sol");
      }
    });

    //collision avec le haut de l'ecran
    if (bird.birdRect.top <= 0) {
      print("##### a toucher le haut");
    }
  }


}