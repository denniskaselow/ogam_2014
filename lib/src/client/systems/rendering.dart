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
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  CameraPositioningSystem(this.ctx, this.buffer) : super(Aspect.getAspectForAllOf([Camera, Transform]));

  void begin() {
    ctx.setTransform(1, 0, 0, 1, 400, 300);
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