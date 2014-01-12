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