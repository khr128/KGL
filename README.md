# KGLDemo application

## Initial setup

### Required frameworks

Add *OpenGL.framework* that is provided by Xcode, *KGL.framework* that you can get from
[my KGL GitHub repository](https://github.com/khr128/KGL), and *KControlPanels.framework* from
[the KControlPanels GitHub repository](https://github.com/khr128/KControlPanels).


### OpenGL view

Add an NSOpenGLView subclass and set it up with the following boileplate code

*KGLDemo3DView.h*

    #import <Cocoa/Cocoa.h>
    @interface KGLDemo3DView : NSOpenGLView {
      GLuint viewWidth;
      GLuint viewHeight;
    }
    @end

*KGLDemo3DView.m*

    #import "KGLDemo3DView.h"
    #import <KGL/KGL.h>
    #import "KGL/KGLScene.h"

    @implementation KGLDemo3DView
    - (id)initWithFrame:(NSRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code here.
        }
        return self;
    }

    - (void)prepareOpenGL {
      // Depth test will always be enabled
      glEnable(GL_DEPTH_TEST);
      glEnable(GL_MULTISAMPLE);
      
      glEnable(GL_CULL_FACE);
      
      // Always use this clear color
      glClearColor(0.5f, 0.4f, 0.5f, 1.0f);
    }

    - (void)drawRect:(NSRect)dirtyRect
    {
      [super drawRect:dirtyRect];
      [[self openGLContext] makeCurrentContext];
      CGLLockContext([[self openGLContext] CGLContextObj]);
      
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
      
      glViewport(0, 0, viewWidth, viewHeight);
      
      CGLFlushDrawable([[self openGLContext] CGLContextObj]);
      CGLUnlockContext([[self openGLContext] CGLContextObj]);
    }

    - (void)reshape {
    [super reshape];
    
    CGLLockContext([[self openGLContext] CGLContextObj]);
    
    NSRect viewRectPoints = [self bounds];
    viewWidth = viewRectPoints.size.width;
    viewHeight = viewRectPoints.size.height;
    
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
    }


    - (void)renewGState
    {
    // Called whenever graphics state updated (such as window resize)
    
    // OpenGL rendering is not synchronous with other rendering on the OSX.
    // Therefore, call disableScreenUpdatesUntilFlush so the window server
    // doesn't render non-OpenGL content in the window asynchronously from
    // OpenGL content, which could cause flickering.  (non-OpenGL content
    // includes the title bar and drawing done by the app with other APIs)
    [[self window] disableScreenUpdatesUntilFlush];
    
    [super renewGState];
    }

    - (void) awakeFromNib
    {
    NSOpenGLPixelFormatAttribute attrs[] =
    {
      NSOpenGLPFADoubleBuffer,
      NSOpenGLPFADepthSize, 24,
      NSOpenGLPFAMultisample,
      NSOpenGLPFASampleBuffers, (NSOpenGLPixelFormatAttribute)1,
      NSOpenGLPFASamples, (NSOpenGLPixelFormatAttribute)4,
      // Must specify the 3.2 Core Profile to use OpenGL 3.2
      NSOpenGLPFAOpenGLProfile,
      NSOpenGLProfileVersion3_2Core,
      0
    };
    
    NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    if (!pf)
    {
      NSLog(@"No OpenGL pixel format");
    }
    
    NSOpenGLContext* context = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
    
    #if defined(DEBUG)
      // When we're using a CoreProfile context, crash if we call a legacy OpenGL function
      // This will make it much more obvious where and when such a function call is made so
      // that we can remove such calls.
      // Without this we'd simply get GL_INVALID_OPERATION error for calling legacy functions
      // but it would be more difficult to see where that function was called.
      CGLEnable([context CGLContextObj], kCGLCECrashOnRemovedFunctions);
    #endif
    
    [self setPixelFormat:pf];
    
    [self setOpenGLContext:context];
    
    #if SUPPORT_RETINA_RESOLUTION
      // Opt-In to Retina resolution
      [self setWantsBestResolutionOpenGLSurface:YES];
    #endif // SUPPORT_RETINA_RESOLUTION
    
  }
  @end


### Camera Control Panel

Add camera control panel as described [here](https://github.com/khr128/KControlPanels). Make sure that all
required Object Controller connections and bindings are set.


## Adding Scene object and shaders

### Scene
Scene object is central in KGL. It keeps information about shaders, camera, lights, and all renderable objects.

Add object of class `KGLScene` to your view and initialize it in the `prepareOpenGL()` method.

*KDemo3DView.h*

    @class KGLScene;
    @interface KGLDemo3DView : NSOpenGLView {
      GLuint viewWidth;
      GLuint viewHeight;
      KGLScene *scene;
    }

*KDemo3DView.m*

    - (void)prepareOpenGL {
      scene = [[KGLScene alloc] init];

### Compile and build shader program

Add the following code to the `prepareOpenGL()` method immediately after the scene initialization.

    [scene addShaderVertex:@"shader.vsh" fragment:@"shader.fsh"
            withAttributes:[[NSArray alloc] initWithObjects:@"inPosition", @"normal", @"texCoords", nil]
               andUniforms:[[NSArray alloc] initWithObjects:
                            @"modelViewProjectionMatrix",
                            @"modelViewMatrix",
                            @"normalMatrix",
                            @"Material.emissive",
                            @"Material.ambient",
                            @"Material.diffuse",
                            @"Material.specular",
                            @"Material.shininess",
                            @"NumEnabledLights",
                            nil]
     ];

Make sure that you copy  *shader.vsh* and *shader.fsh* into your app's bundle
(KGLDemo.xcodeproj -> Build Phases -> Copy Bundle Resourses). The names of the shader uniform variables are used verbatim
inside the KGL framework, so they must be typed exactly as shown above, and they must be used in *shader.vsh* (see project for
shader examples).

*shader.vsh*

    ...
    struct material {
      vec4 emissive;
      vec4 ambient;
      vec4 diffuse;
      vec4 specular;
      float shininess;
    };
    uniform mat4 modelViewProjectionMatrix;
    uniform mat4 modelViewMatrix;
    uniform mat3 normalMatrix;
    uniform material Material;
    uniform int NumEnabledLights;
    ...

Shader attributes can have any valid name, make sure you use them in your shaders with the same names.

*shader.vsh*

    ...
    in vec4 inPosition;
    in vec3 normal;
    in vec2 texCoords;
    ...

As you build the shader program you might get the following warning in the Xcode console

    2013-12-22 08:47:05.775 KGLDemo[644:303] Program validate log:
    Validation Failed: No vertex array object bound.

This is OK, if this is the only problem with your shader compilation. Vertex array objects will be bound when
renderable objects will be added to the scene (see below).


## Adding reference frames and renderable 3D objects

After shader program is built and linked successfully you can start adding objects to your scene. The scene is a tree with
reference frames as nodes and renderable objects as leaves. Your one and only `KGLScene *scene` object is the root of the
rendering tree. 

### Reference frames
Reference frames are invisible, but they define positions and orientation of all 3D objects and nested reference frames
that are their direct children.

*KDemo3DView.h*

    @class KGLScene, KGLReferenceFrame;
    @interface KGLDemo3DView : NSOpenGLView {
      GLuint viewWidth;
      GLuint viewHeight;
      KGLScene *scene;
      KGLReferenceFrame *mainFrame, *frame2;
    }

*KDemo3DView.m*

    ...
    mainFrame = [[KGLReferenceFrame alloc] init];
    frame2 = [[KGLReferenceFrame alloc] init];
    
    [scene addChild:mainFrame];
    [mainFrame addChild:frame2];
    ...

It is important to build your tree by adding child frames from the root down, because a reference to the `scene` object
must be properly inherited by all objects in the tree. The scene holds information about shaders, camera, lights, etc 
which is needed for correct rendering of all the objects in the tree.

### 3D Objects

To render 3D objects, derive your object classes from `KGLDrawable` and add instances of these classes to reference frames.
`KGLDrawable` encapsulates information about shader attributes, drawable geometry, material and texture used to render an
object. In this demo we will use `KGLBuiltObject` class which is a subclass of `KGLDrawable`. `KGLDrawable` allows to create
common 3D geometrical shapes like box, sphere, cone, and torus.

In order to show objects in the view several conditions must be met:

* Set viewport
* Define camera and view matrix
* Set projection matrix
* Add lights and compute their positions in eye coordinates
* Render scene

#### Setting viewport

We already set viewport to full window extent in the `drawRect:` method

    glViewport(0, 0, viewWidth, viewHeight);
The values of `viewWidth` and `viewHeight` were obtained in the `reshape()` method

    NSRect viewRectPoints = [self bounds];
    viewWidth = viewRectPoints.size.width;
    viewHeight = viewRectPoints.size.height;

#### Defining camera and view matrix

Add method `defineCamera` to `KDemoView` class

    - (void)defineCamera {
      Point3d *cameraLocation = (Point3d *)camera.location;
      GLKVector3 eye = GLKVector3Make([cameraLocation.x floatValue],
                                      [cameraLocation.y floatValue],
                                      [cameraLocation.z floatValue]);
      
      Point3d *cameraLookAt = (Point3d *)camera.lookAt;
      GLKVector3 center = GLKVector3Make([cameraLookAt.x floatValue],
                                         [cameraLookAt.y floatValue],
                                         [cameraLookAt.z floatValue]);
      Point3d *cameraUp = (Point3d *)camera.up;
      GLKVector3 up = GLKVector3Make([cameraUp.x floatValue],
                                     [cameraUp.y floatValue],
                                     [cameraUp.z floatValue]);
      
      [scene.camera setViewEye:eye center:center up:up];
    }
This code is mostly self-explanatory. We get camera's location, look-at, and up vectors from the `Camera` Core Data entity
which is provided by the `KControlPanels` framework. Sending `setViewEye:center:up:` to the scene's camera (defined by `KGL` framework)
defines the view matrix that is used in subsequent rendering.

#### Setting projection matrix

Add method `defineProjection` to `KDemoView` class

    - (void)defineProjection {
      [self defineCamera];
      
      [scene.camera setProjectionFov:GLKMathDegreesToRadians([camera.angle floatValue])
                              aspect:(GLfloat)viewWidth / (GLfloat)viewHeight
                               nearZ:[camera.nearZ floatValue]
                                farZ:[camera.farZ floatValue]
       ];
    }
This code create a projection matrix that is used to render 3D scene onto our 2D viewport with correct aspect ratio.
The projection is perspective with the field of view in radians, near clipping plane and far clipping plane obtained from
the `Camera` Core Data entity which is provided by the `KControlPanels` framework. Sending `setProjectionFov:aspect:nearZ:farZ`
to the scene's camera (defined by the `KGL` framework) defines the projection matrix used in the subsequent rendering.

We need a separate method `defineCamera` because in `prepareOpenGL` method we want to add lights and compute their positions
in eye coordinates (see below). A view matrix is required for that, but the projection matrix can not be set because
viewport dimensions are not defined yet.

The `defineProjection` method is called when the viewport is resized and when we handle camera parameters changes.

#### Adding lights


