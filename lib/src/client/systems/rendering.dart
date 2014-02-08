part of client;

class RenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  CanvasRenderingContext2D ctx;
  RenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform]));

  void processEntity(Entity entity) {
    var p = tm.get(entity).pos;
    ctx.fillStyle = 'black';
    ctx.fillRect(p.x * GRID_SIZE, p.y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
  }
}

class CameraPositioningSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  CameraPositioningSystem(CanvasElement canvas, this.buffer) : ctx = canvas.context2D,
                                                               canvas = canvas,
                                                               super(Aspect.getAspectForAllOf([Camera, Transform]));

  void begin() {
    ctx.setTransform(1, 0, 0, 1, canvas.width / 2, canvas.height / 2);
  }

  void processEntity(Entity entity) {
    var t = tm.get(entity);

    ctx..translate(-t.pos.x * GRID_SIZE - GRID_SIZE / 2, -t.pos.y * GRID_SIZE - GRID_SIZE / 2)
       ..drawImage(buffer, 0, 0);
  }

  void end() {
    ctx.setTransform(1, 0, 0, 1, 0, 0);
  }
}

class MousePositionRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  static var pos = const Point<double>(0.0, 0.0);
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  MousePositionRenderingSystem(this.canvas, this.ctx) : super(Aspect.getAspectForAllOf([Camera, Transform]));

  void processEntity(Entity entity) {
    var t = tm.get(entity);

    ctx..fillStyle = 'blue'
       ..fillRect((GRID_SIZE / 2 + pos.x + t.pos.x * GRID_SIZE - canvas.width / 2) ~/ GRID_SIZE * GRID_SIZE, (GRID_SIZE / 2 + pos.y + t.pos.y * GRID_SIZE - canvas.height / 2) ~/ GRID_SIZE * GRID_SIZE, GRID_SIZE, GRID_SIZE);
  }
}