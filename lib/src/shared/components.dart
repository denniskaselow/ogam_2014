part of shared;


class Transform extends Component {
  Point<double> pos;
  Transform(num x, num y) {
    pos = new Point<double>(x.toDouble(), y.toDouble());
  }
}

class MoveToMouseClickPosition extends Component {}
class Camera extends Component {}