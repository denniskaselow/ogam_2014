part of shared;


class MovementSystem extends EntityProcessingSystem {
  static const noDiff = const Point<double>(0.0, 0.0);
  static var center;

  Point<double> diff = noDiff;
  ComponentMapper<Transform> tm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Transform, MoveToMouseClickPosition]));

  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var sx = FastMath.signum(diff.x);
    var sy = FastMath.signum(diff.y);
    var change = new Point(sx * min(world.delta / 8 / GRID_SIZE, diff.x.abs()), sy * min(world.delta / 8 / GRID_SIZE, diff.y.abs()));
    t.pos += change;
    diff -= change;
  }

  void updateDiff(Point<double> pos) {
    var temp = new Point(pos.x - center.x, pos.y - center.y);
    temp = new Point(temp.x + FastMath.signum(temp.x) * GRID_SIZE/2, temp.y + FastMath.signum(temp.y) * GRID_SIZE/2);
    diff = new Point(temp.x ~/ GRID_SIZE + diff.x % 1, -(temp.y ~/ GRID_SIZE) + diff.y % 1);
  }

  bool checkProcessing() => noDiff != diff;
}
