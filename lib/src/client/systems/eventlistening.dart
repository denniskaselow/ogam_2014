part of client;

class MouseClickEventListenerSystem extends VoidEntitySystem {
  MovementSystem ms;
  CanvasElement canvas;
  Point offset;
  bool handleEvent = false;
  MouseClickEventListenerSystem(this.canvas);

  void initialize() {
    canvas.onClick.listen((event) {
      offset = event.offset;
      handleEvent = true;
    });
  }

  void processSystem() {
    handleEvent = false;
    ms.pos = offset;
  }

  bool checkProcessing() => handleEvent;
}