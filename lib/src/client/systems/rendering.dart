part of client;

class RenderingSystem extends EntityProcessingSystem {
  final attrVertexPosition = "aVertexPosition";
  final cameraPosition = "uCameraPosition";
  final colorVariable = "uColor";

  double aspect;
  ComponentMapper<Transform> tm;
  TagManager tagMaanger;
  RenderingContext gl;
  CanvasElement canvas;
  Program program;
  RenderingSystem(this.canvas, this.gl, this.program) : super(Aspect.getAspectForAllOf([Transform]));

  void begin() {
    aspect = canvas.width / canvas.height;
    gl.useProgram(program);
    var camera = tagMaanger.getEntity('CAMERA');
    var pos = tm.get(camera).pos;
    UniformLocation uCameraPosition = gl.getUniformLocation(program, cameraPosition);
    gl.uniform3fv(uCameraPosition, new Float32List.fromList([-pos.x, -pos.y * aspect, 0.0]));
  }

  void processEntity(Entity entity) {
    var p = tm.get(entity).pos;

    Float32List vertices = new Float32List.fromList(
        [
         p.x+0.5, aspect * (p.y+0.5), p.x-0.5, aspect * (p.y+0.5), p.x+0.5, aspect * (p.y-0.5), // Triangle 1
         p.x-0.5, aspect * (p.y+0.5), p.x+0.5, aspect * (p.y-0.5), p.x-0.5, aspect * (p.y-0.5), // Triangle 2
        ]);

    Buffer squareBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, squareBuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, vertices, RenderingContext.STATIC_DRAW);

    int itemSize = 2;
    int numItems = vertices.length ~/ itemSize;


    UniformLocation uColor = gl.getUniformLocation(program, colorVariable);
    gl.uniform4fv(uColor, new Float32List.fromList([0.0, 0.0, 0.0, 1.0]));

    int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, itemSize, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, numItems);
  }
}

class MousePositionRenderingSystem extends EntityProcessingSystem {
  final attrVertexPosition = "aVertexPosition";
  final cameraPosition = "uCameraPosition";
  final colorVariable = "uColor";

  ComponentMapper<Transform> tm;
  static var pos = const Point<double>(0.0, 0.0);
  CanvasElement canvas;
  RenderingContext gl;
  Program program;
  double aspect;

  MousePositionRenderingSystem(this.canvas, this.gl, this.program) : super(Aspect.getAspectForAllOf([Camera, Transform]));

  void begin() {
    aspect = canvas.width / canvas.height;
    gl.useProgram(program);
  }

  void processEntity(Entity entity) {
    var p = tm.get(entity).pos;
    var h = canvas.height % 64 != 0 ? 1 - (canvas.height / 64) % 1 : 0;
    p += new Point((GRID_SIZE / 2 + pos.x) ~/ GRID_SIZE - canvas.width / 64, (-GRID_SIZE / 2 -pos.y) ~/ GRID_SIZE + canvas.height / 64 + h);

    Float32List vertices = new Float32List.fromList(
        [
         p.x+0.5, aspect * (p.y+0.5), p.x-0.5, aspect * (p.y+0.5), p.x+0.5, aspect * (p.y-0.5), // Triangle 1
         p.x-0.5, aspect * (p.y+0.5), p.x+0.5, aspect * (p.y-0.5), p.x-0.5, aspect * (p.y-0.5), // Triangle 2
        ]);

    Buffer squareBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, squareBuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, vertices, RenderingContext.STATIC_DRAW);

    int itemSize = 2;
    int numItems = vertices.length ~/ itemSize;

    UniformLocation uColor = gl.getUniformLocation(program, colorVariable);
    gl.uniform4fv(uColor, new Float32List.fromList([0.0, 0.0, 0.5, 1.0]));

    int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, itemSize, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, numItems);
  }

//  void processEntity(Entity entity) {
//    var t = tm.get(entity);
//
//    ctx..fillStyle = 'blue'
//       ..fillRect((GRID_SIZE / 2 + pos.x + t.pos.x * GRID_SIZE - canvas.width / 2) ~/ GRID_SIZE * GRID_SIZE, (GRID_SIZE / 2 + pos.y + t.pos.y * GRID_SIZE - canvas.height / 2) ~/ GRID_SIZE * GRID_SIZE, GRID_SIZE, GRID_SIZE);
//  }
}

class CanvasCleaningSystem3D extends VoidEntitySystem {
  CanvasElement canvas;
  RenderingContext gl;
  String fillStyle;

  CanvasCleaningSystem3D(CanvasElement canvas) : canvas = canvas,
                                                 gl = canvas.getContext3d();

  void processSystem() {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(1.0, 1.0, 1.0, 1.0);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);
  }
}