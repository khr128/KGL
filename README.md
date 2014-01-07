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
* Build and add 3D object geometry (vertex buffers) to a reference frame
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

Add the following code in `prepareOpenGL` method after you have defined camera:

    [scene.lights addPointLightAt:GLKVector4Make(0.15, -10, -10, 1)
                      attenuation:GLKVector3Make(1.0, 0.1, 0.1)
                          ambient:GLKVector4Make(0.0, 0.0, 0.0, 1)
                          diffuse:GLKVector4Make(1.0, 0.0, 0.0, 1)
                         specular:GLKVector4Make(1, 1, 1, 1)];
    [scene computeLightsEyeCoordinates];

This adds a point light in world coordinates and recomputes this light coordinates to the eye coordinates (i.e. camera is
at the origin of the eye reference frame). It is possible to add directional and spot lights using `KGL` framework too. The
method `computeLightsEyeCoordinates` must be called every time the camera position is updated to ensure correct lighting.

#### Building and adding 3D geometry

`KGL` framework provides a base class `KGLBuiltObject` that assists in assembling all necessary vertex, normal and texture
data using 3D object builders (also provided by the `KGL` framework). To use these facilities simply derive your own class
from `KGLBuiltObject`:

*KGLDemoCylinder.h*

    #import <KGL/KGLBuiltObject.h>

    @class KGLVector3;
    @interface KGLDemoCylinder : KGLBuiltObject
    - (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2;
    @end

The initializer `initWithRadius:p1:p2:` will generate a cylinder with a given radius along the straight line connecting
points `p1` and `p2` with the cylinder ends perpendicular to this line. We implement the cylinder with `KGLConeBuilder`,
which generates the required shape when the radii at both ends are the same.

*KGLDemoCylinder.h*

    #import "KGLDemoCylinder.h"
    #import <KGL/KGLConeBuilder.h>
    #import <KGL/KGLVector3.h>
    #import <KGL/KGLUUID.h>
    #import <KGL/KGLShaderAttribute.h>

    @implementation KGLDemoCylinder

    - (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2 {
      self = [super init];
      if (self) {
        KGLConeBuilder *coneBuilder = [[KGLConeBuilder alloc] initWithP1:p1
                                                                      r1:radius
                                                                      p2:p2
                                                                      r2:radius
                                                               closeEnd1:YES closeEnd2:YES];
        coneBuilder.tesselationLevel = ^{
          return (NSUInteger)0;
        };
        __weak typeof(self) self_ = self;
        self.customTemplate = ^{
          [self_ appearance];
          [self_ translationX:p1.x y:p1.y z:p1.z];
        };
        [self createIndexedDrawable:coneBuilder];
        self.uuid = [KGLUUID generate];
      }
      return self;
    }

    - (void)appearance {
      self.shaderAttributes = [[NSMutableDictionary alloc]
                               initWithObjectsAndKeys:
                               [[KGLShaderAttribute alloc] initWithComponentCount:3
                                                                             type:GL_FLOAT
                                                                       normalized:GL_FALSE
                                                                           stride:0
                                                                     bufferOffset:0],
                               @"inPosition",
                               [[KGLShaderAttribute alloc] initWithComponentCount:3
                                                                             type:GL_FLOAT
                                                                       normalized:GL_FALSE
                                                                           stride:0
                                                                     bufferOffset:[self.data vertexSize]],
                               @"normal",
                               nil];
      
      material = [[KGLMaterial alloc] initWithEmissive:GLKVector4Make(0.0, 0.0, 0.0, 1.0)
                                               ambient:GLKVector4Make(1.0, 1.0, 1.0, 1.0)
                                               diffuse:GLKVector4Make(1, 1, 1, 1.0)
                                              specular:GLKVector4Make(0.75, 0.75, 0.75, 1.0)
                                             shininess:12.0];
    }

    @end




#### Render scene

After everything is properly set up, scene rendering is easy. Just send `render` message to the `scene` object.
Here is the final `drawRect` method in `KGLDemo3DView` class

    - (void)drawRect:(NSRect)dirtyRect
    {
      [super drawRect:dirtyRect];
      [[self openGLContext] makeCurrentContext];
      CGLLockContext([[self openGLContext] CGLContextObj]);
      
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
      
      glViewport(0, 0, viewWidth, viewHeight);
      
      [scene render];
      
      CGLFlushDrawable([[self openGLContext] CGLContextObj]);
      CGLUnlockContext([[self openGLContext] CGLContextObj]);
    }

## Using camera

Subscribe to notifications from the camera control panel (provided by the `KControlPanels` framework):

*KDemo3DView.m*

    - (void)addObservers {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self selector:@selector(handleCameraChange:) name:KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION object:nil];
    }

    - (void)prepareOpenGL {
      ...
      [self addObservers];
    }

And update the view in the event handler

    - (void)handleCameraChange:(NSNotification *) note {
      camera = note.object;
      [self defineProjection];
      [scene computeLightsEyeCoordinates];
      [self setNeedsDisplay:YES];
    }

Since its possible that the camera position has changed, we should always recompute lights' coordinates in the eye reference 
frame.

