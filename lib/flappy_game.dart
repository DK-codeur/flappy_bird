
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flame/time.dart';
import 'package:flappy_bird/composants/background.dart';
import 'package:flappy_bird/composants/base.dart';
import 'package:flappy_bird/composants/pipes.dart';

class FlappyGame extends Game {
  Size screenSize;
  Background background;
  // Base base;
  List<Base> baseList;
  // Pipes pipes;
  List<Pipes> pipesList = [];
  Timer timer;

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

    timer.start();
  }

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

  }

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


}