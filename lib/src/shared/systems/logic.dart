part of shared;


class MovementSystem extends EntityProcessingSystem {
  Point pos;
  ComponentMapper<Transform> tm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Transform, MoveToMouseClickPosition]));

  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var diff = pos - t.pos;
    var sx = FastMath.signum(diff.x);
    var sy = FastMath.signum(diff.y);
    t.pos += new Point(sx * min(world.delta / 8, diff.x.abs()), sy * min(world.delta / 8, diff.y.abs()));
  }

  bool checkProcessing() => null != pos;
}
