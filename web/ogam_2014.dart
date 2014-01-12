import 'package:ogam_2014/client.dart';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('ogam_2014', 'canvas', 800, 600);

  void createEntities() {
    // addEntity([Component1, Component2]);
  }

  List<EntitySystem> getSystems() {
    return [
            new CanvasCleaningSystem(canvas),
            new FpsRenderingSystem(ctx)
    ];
  }

  Future onInit() {
  }

  Future onInitDone() {
  }
}

