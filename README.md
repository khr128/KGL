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
