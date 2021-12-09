
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flame/time.dart';
import 'package:flappy_bird/composants/background.dart';
import 'package:flappy_bird/composants/base.dart';
import 'package:flappy_bird/composants/bird.dart';
import 'package:flappy_bird/composants/game_over_screen.dart';
import 'package:flappy_bird/composants/pipes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlappyGame extends Game with TapDetector {
  Size screenSize;
  Background background;
  // Base base;
  List<Base> baseList;
  // Pipes pipes;
  List<Pipes> pipesList = [];
  Timer timer;
  Bird bird;
  GameOverScreen gameOver;

  bool isPlaying = false;

  int score = 0;
  TextConfig scoreText;
  int highScore = 0;

  SharedPreferences prefs;

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

    gameOver = GameOverScreen(game: this, score: score);

    //textConfig
    scoreText = TextConfig(
      fontSize: 45, 
      fontFamily: "flappyFont",
      color: Colors.white
    );
  }


  //** render
  @override 
  void render(Canvas canvas) {
    background.render(canvas);

    if (isPlaying == true) {
      // pipes.render(canvas);
      pipesList.forEach((Pipes pipes) { 
        pipes.render(canvas);
      });

       //afficher le bird
        bird.render(canvas);

        //affiche le score
        scoreText.render(
          canvas, 
          score.toString(), 
          Position(screenSize.width/2, screenSize.height/8,),
          anchor: Anchor.center
        );

    } else {
      gameOver.render(canvas);
    }

    

    // base.render(canvas);
    baseList.forEach((Base base) { 
      base.render(canvas);
    });

   

  }

  //** update
  @override
  void update(double t) {

    if (isPlaying == true) {
      timer.update(t);

      //deplacement des tubes
      // pipes.update(t);
      pipesList.forEach((Pipes pipes) { 
        pipes.update(t);
      });

      //supprime les pipe non visible
      pipesList.removeWhere((Pipes pipes) => pipes.isVisible == false);

      bird.update(t);

      updateScore();

      gameOverFunct();

    } 

    // base.update(t);
    baseList.forEach((Base base) {
      base.update(t);
    });

    baseList.removeWhere((Base base) => base.isVisible == false);

    if (baseList.length < 2) {
      createBase();
    }

   

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
    bird.onTap();
    if (isPlaying == true) {
      super.onTap();
    } else {
      pipesList.clear();
      isPlaying = true;
      timer.start();
    }
  }

  void gameOverFunct() {
    //check si le bird a toucher les tubes
    pipesList.forEach((Pipes pipes) { 
      if (pipes.hasCollided(bird.birdRect)) {
        Flame.audio.play("hit.wav");
        reset();
      }
    });

    //collisio avec le sol
    baseList.forEach((Base base) {
      if (base.hasCollided(bird.birdRect)) {
        Flame.audio.play("hit.wav");
        reset();
      }
    });

    //collision avec le haut de l'ecran
    if (bird.birdRect.top <= 0) {
      Flame.audio.play("hit.wav");
      reset();
    }
  }

  void reset() {
    isPlaying = false;
    timer.stop();
    bird = Bird(game: this);
    gameOver = GameOverScreen(game: this, score: score);
    score = 0;
  }

  void updateScore() {
    pipesList.forEach((Pipes pipes) { 
      if (pipes.canUpdateScrore == true) {
        
        if (bird.birdRect.right >= pipes.topPipeBodyRect.left + pipes.topPipeBodyRect.width/2) {
          score++;
          Flame.audio.play("point.wav");
          pipes.canUpdateScrore = false;

          //update le meilleur score
          if(score > highScore) {
            saveHightScore();
          }
          
        }
      }
    });
  }

  void saveHightScore() async {
    highScore = score;
    prefs = await SharedPreferences.getInstance();
    prefs.setInt("hightScore", highScore);
  }


}