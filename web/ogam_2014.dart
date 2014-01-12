import 'package:ogam_2014/client.dart';

@MirrorsUsed(targets: const [CanvasCleaningSystem, FpsRenderingSystem,
                             RenderingSystem, MovementSystem,
                             MouseClickEventListenerSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('ogam_2014', 'canvas', 800, 600);

  void createEntities() {
    addEntity([new Transform(100, 100), new MoveToMouseClickPosition()]);
  }

  List<EntitySystem> getSystems() {
    return [
            new MouseClickEventListenerSystem(canvas),
            new MovementSystem(),
            new CanvasCleaningSystem(canvas),
            new RenderingSystem(ctx),
            new FpsRenderingSystem(ctx)
    ];
  }

  Future onInit() {
  }

  Future onInitDone() {
  }

  World createWorld() => new World();
}

