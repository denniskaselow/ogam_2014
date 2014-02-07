part of shared;


class MovementSystem extends EntityProcessingSystem {
  static const noDiff = const Point(0.0, 0.0);
  static var center = const Point(400.0, 300.0);

  Point diff = noDiff;
  ComponentMapper<Transform> tm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Transform, MoveToMouseClickPosition]));

  void processEntity(Entity entity) {
    var t = tm.get(entity);

    var sx = FastMath.signum(diff.x);
    var sy = FastMath.signum(diff.y);
    var change = new Point(sx * min(world.delta / 8, diff.x.abs()), sy * min(world.delta / 8, diff.y.abs()));
    t.pos += change;
    diff -= change;
  }

  void updateDiff(Point pos) {
    diff = pos - center;
  }

  bool checkProcessing() => noDiff != diff;
}
