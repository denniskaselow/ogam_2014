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
  CanvasElement buffer;

  Game() : super.noAssets('ogam_2014', 'canvas', 800, 600) {
    canvas.requestFullscreen();
    buffer = new CanvasElement(width: canvas.width, height: canvas.height);
  }

  void createEntities() {
    addEntity([new Transform(100, 100), new MoveToMouseClickPosition(), new Camera()]);
    addEntity([new Transform(10, 10)]);
    addEntity([new Transform(500, 500)]);
    addEntity([new Transform(10, 500)]);
    addEntity([new Transform(500, 10)]);
  }

  List<EntitySystem> getSystems() {
    return [
            new MouseClickEventListenerSystem(canvas),
            new MovementSystem(),
            new CanvasCleaningSystem(canvas),
            new CanvasCleaningSystem(buffer),
            new RenderingSystem(buffer.context2D),
            new CameraPositioningSystem(canvas, buffer),
            new FpsRenderingSystem(ctx),
    ];
  }

  Future onInit() {}
  Future onInitDone() {}

  void handleResize(int width, int height) {
    buffer.width = width;
    buffer.height = height;
    MovementSystem.center = new Point(width ~/ 2, height ~/ 2);
  }

  World createWorld() => new World();
}

