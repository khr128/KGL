//
//  KGLDemo3DView.m
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDemo3DView.h"
#import <KGL/KGL.h>
#import <KGL/KGLScene.h>
#import <KGL/KGLReferenceFrame.h>
#import <KGL/KGLVector3.h>
#import "KGLDemoCylinder.h"
#import <KControlPanels/Camera.h>
#import <KControlPanels/Point3d.h>
#import "KGLDemoDocument.h"

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
  
  scene = [[KGLScene alloc] init];
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
  
  mainFrame = [[KGLReferenceFrame alloc] init];
  frame2 = [[KGLReferenceFrame alloc] init];
  
  [scene addChild:mainFrame];
  [mainFrame addChild:frame2];
  
  cylinder1 = [[KGLDemoCylinder alloc] initWithRadius:0.5
                                                   p1:[[KGLVector3 alloc] initWithX:0 y:0 z:0]
                                                   p2:[[KGLVector3 alloc] initWithX:6 y:0 z:0]];
  
  [mainFrame addChild:cylinder1];
  
  [self defineCamera];
  
  //  [scene.lights addDirectionalLightAt:GLKVector4Make(0, -1, -1, 0)
  //                              ambient:GLKVector4Make(1.0, 0.0, 0.0, 1)
  //                              diffuse:GLKVector4Make(1.0, 0.0, 0.0, 1)
  //                             specular:GLKVector4Make(0.0, 0.0, 0.0, 1)];
  
  [scene.lights addPointLightAt:GLKVector4Make(0.15, -10, -10, 1)
                    attenuation:GLKVector3Make(1.0, 0.1, 0.1)
                        ambient:GLKVector4Make(0.0, 0.0, 0.0, 1)
                        diffuse:GLKVector4Make(1.0, 0.0, 0.0, 1)
                       specular:GLKVector4Make(1, 1, 1, 1)];
  
  //  [scene.lights addSpotLightAt:GLKVector4Make(0, -1, -3, 1)
  //                   attenuation:GLKVector3Make(1, 0, 0)
  //                 spotDirection:GLKVector3Make(1, -2, -3)
  //             spotRadiusDegrees:30
  //             spotCutoffDegrees:33
  //                 spotTightness:0.0
  //                       ambient:GLKVector4Make(0.0, 0.0, 0.0, 1)
  //                       diffuse:GLKVector4Make(0, 0, 0, 1)
  //                      specular:GLKVector4Make(0, 0, 0, 1)];
  
  [scene computeLightsEyeCoordinates];
  
  // Depth test will always be enabled
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_MULTISAMPLE);
  
  glEnable(GL_CULL_FACE);
  
  // Always use this clear color
  glClearColor(0.5f, 0.4f, 0.5f, 1.0f);
  
  [self addObservers];
}

- (void)addObservers{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(handleCameraChange:) name:KCONTROLPANELS_CAMERA_CHANGED_NOTIFICATION object:nil];
}

- (void)handleCameraChange:(NSNotification *) note {
  camera = note.object;
  [self defineProjection];
  [scene computeLightsEyeCoordinates];
  [self setNeedsDisplay:YES];
}

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

- (void)defineProjection {
  [self defineCamera];
  
  [scene.camera setProjectionFov:GLKMathDegreesToRadians([camera.angle floatValue])
                          aspect:(GLfloat)viewWidth / (GLfloat)viewHeight
                           nearZ:[camera.nearZ floatValue]
                            farZ:[camera.farZ floatValue]
   ];
}

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

- (void)reshape {
  [super reshape];
  
  CGLLockContext([[self openGLContext] CGLContextObj]);
  
  NSRect viewRectPoints = [self bounds];
  viewWidth = viewRectPoints.size.width;
  viewHeight = viewRectPoints.size.height;
  
  [self defineProjection];
  
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
  
  camera = [doc fetchOrCreateCamera];
}

@end
