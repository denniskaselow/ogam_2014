part of client;

class MouseClickEventListenerSystem extends VoidEntitySystem {
  MovementSystem ms;
  CanvasElement canvas;
  Point<double> offset;
  var handleEvent = false;
  MouseClickEventListenerSystem(this.canvas);

  void initialize() {
    var mmListener = canvas.onMouseMove.listen((event) {
      offset = event.offset;
      handleEvent = true;
    });
    mmListener.pause();
    canvas.onMouseDown.listen((event) {
      offset = event.offset;
      handleEvent = true;
      mmListener.resume();
    });
    canvas.onMouseUp.listen((_) => mmListener.pause());
  }

  void processSystem() {
    handleEvent = false;
    ms.updateDiff(offset);
  }

  bool checkProcessing() => handleEvent;
}

class MouseMoveEventListeningSystem extends VoidEntitySystem {
  CanvasElement canvas;
  Point<double> offset;
  var handleEvent = false;
  MouseMoveEventListeningSystem(this.canvas) : super();

  void initialize() {
    var mmListener = canvas.onMouseMove.listen((event) {
      offset = event.offset;
      handleEvent = true;
    });
  }

  void processSystem() {
    handleEvent = false;
    MousePositionRenderingSystem.pos = offset;
  }

  bool checkProcessing() => handleEvent;
}