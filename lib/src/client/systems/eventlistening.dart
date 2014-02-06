part of client;

class MouseClickEventListenerSystem extends VoidEntitySystem {
  MovementSystem ms;
  CanvasElement canvas;
  Point offset;
  bool handleEvent = false;
  Queue<int> foobar;
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