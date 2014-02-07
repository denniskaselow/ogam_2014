part of client;

class RenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  CanvasRenderingContext2D ctx;
  RenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform]));

  void processEntity(Entity entity) {
    var p = tm.get(entity).pos;
    ctx.fillStyle = 'black';
    ctx.fillRect(p.x, p.y, 5, 5);
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
    ctx.setTransform(1, 0, 0, 1, canvas.width ~/ 2, canvas.height ~/ 2);
  }

  void processEntity(Entity entity) {
    var t = tm.get(entity);

    ctx.translate(-t.pos.x, -t.pos.y);
    ctx.drawImage(buffer, 0, 0);
  }

  void end() {
    ctx.setTransform(1, 0, 0, 1, 0, 0);
  }

}