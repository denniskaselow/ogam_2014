import 'package:ogam_2014/client.dart';

@MirrorsUsed(targets: const [CanvasCleaningSystem, FpsRenderingSystem,
                             RenderingSystem, MovementSystem,
                             MouseClickEventListenerSystem,
                             MouseMoveEventListeningSystem,
                             MousePositionRenderingSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {
  Program program;

  Game() : super.noAssets('ogam_2014', 'canvas', 1024, 576, webgl: true);

  void createEntities() {
    var entity = addEntity([new Transform(TILES_X ~/ 2, TILES_Y ~/ 2), new MoveToMouseClickPosition(), new Camera()]);
    TagManager tm = world.getManager(TagManager);
    tm.register(entity, 'CAMERA');
    addEntity([new Transform(1, 1)]);
    addEntity([new Transform(TILES_X - 2, TILES_Y - 2)]);
    addEntity([new Transform(1, TILES_Y - 2)]);
    addEntity([new Transform(TILES_X - 2, 1)]);
  }

  List<EntitySystem> getSystems() {
    MovementSystem.center = new Point(canvas.width / 2, canvas.height / 2);
    return [
            new MouseClickEventListenerSystem(canvas),
            new MouseMoveEventListeningSystem(canvas),
            new MovementSystem(),
            new CanvasCleaningSystem3D(canvas),
            new RenderingSystem(canvas, ctx, program),
            new MousePositionRenderingSystem(canvas, ctx, program),
//            new FpsRenderingSystem(ctx),
    ];
  }

  Future onInit() {
    world.addManager(new TagManager());
    initProgram();
  }

  void initProgram() {
    var gl = ctx;
    var attrVertexPosition = "aVertexPosition";
    var cameraPosition = "uCameraPosition";
    var colorVariable = "uColor";
    String vertex = """
attribute vec2 $attrVertexPosition;
uniform vec3 $cameraPosition;
  
void main() {
  mat4 world = mat4(vec4(1, 0, 0, 0),
                    vec4(0, 1, 0, 0),
                    vec4(0, 0, 1, 0),
                    vec4(0, 0, 0, 1));
  mat4 view = mat4( vec4(1, 0, 0, 0),
                    vec4(0, 1, 0, 0),
                    vec4(0, 0, 1, 0),
                    vec4($cameraPosition, ${canvas.width / 64}));
  mat4 projection = mat4(vec4(1, 0, 0, 0),
                         vec4(0, 1, 0, 0),
                         vec4(0, 0, 1, 0),
                         vec4(0, 0, 0, 1));
  mat4 worldViewProjection = world * view * projection;
  gl_Position = worldViewProjection * vec4($attrVertexPosition, 0, 1.0);
}
    """;

    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vertex);
    gl.compileShader(vs);

    String fragment = """
#ifdef GL_ES
precision highp float;
#endif
  
uniform vec4 $colorVariable;
  
void main() {
  gl_FragColor = $colorVariable;
}
    """;

    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fragment);
    gl.compileShader(fs);

    program = gl.createProgram();
    gl.attachShader(program, vs);
    gl.attachShader(program, fs);
    gl.linkProgram(program);

    if (!gl.getShaderParameter(vs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(vs));
    }

    if (!gl.getShaderParameter(fs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(fs));
    }

    if (!gl.getProgramParameter(program, RenderingContext.LINK_STATUS)) {
      print(gl.getProgramInfoLog(program));
    }
  }

  Future onInitDone() {}

  void handleResize(int width, int height) {
    MovementSystem.center = new Point(width / 2, height / 2);
    initProgram();
    var system = world.getSystem(RenderingSystem) as RenderingSystem;
    system.program = program;
    system = world.getSystem(MousePositionRenderingSystem) as MousePositionRenderingSystem;
    system.program = program;
  }

  World createWorld() => new World();
}

