import 'package:ogam_2014/client.dart';

@MirrorsUsed(targets: const [CanvasCleaningSystem, FpsRenderingSystem,
                             RenderingSystem, MovementSystem,
                             MouseClickEventListenerSystem,
                             MouseMoveEventListeningSystem,
                             MousePositionRenderingSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {
  CanvasElement buffer;

  Game() : super.noAssets('ogam_2014', 'canvas', 1024, 576) {
    canvas.requestFullscreen();
    buffer = new CanvasElement(width: GRID_SIZE * TILES_X, height: GRID_SIZE * TILES_Y);
  }

  void createEntities() {
    addEntity([new Transform(TILES_X ~/ 2, TILES_Y ~/ 2), new MoveToMouseClickPosition(), new Camera()]);
    addEntity([new Transform(1, 1)]);
    addEntity([new Transform(TILES_X - 2, TILES_Y - 2)]);
    addEntity([new Transform(1, TILES_Y - 2)]);
    addEntity([new Transform(TILES_X - 2, 1)]);
  }

  List<EntitySystem> getSystems() {
    MovementSystem.center = new Point(canvas.width / 2, canvas.height / 2);
    return [
            new MouseClickEventListenerSystem(canvas),
            new MouseMoveEventListeningSystem(canvas),
            new MovementSystem(),
            new CanvasCleaningSystem(canvas, fillStyle: 'black'),
            new CanvasCleaningSystem(buffer),
            new RenderingSystem(buffer.context2D),
            new MousePositionRenderingSystem(canvas, buffer.context2D),
            new CameraPositioningSystem(canvas, buffer),
            new FpsRenderingSystem(ctx),
    ];
  }

  Future onInit() {}
  Future onInitDone() {}

  void handleResize(int width, int height) {
    MovementSystem.center = new Point(width / 2, height / 2);
  }

  World createWorld() => new World();
}

