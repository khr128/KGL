//
//  KGLDemo3DView.h
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KGLScene, KGLReferenceFrame, KGLDemoCylinder, Camera;
@class KGLDemoDocument;
@interface KGLDemo3DView : NSOpenGLView {
  GLuint viewWidth;
  GLuint viewHeight;
  KGLScene *scene;
  
  IBOutlet KGLDemoDocument *doc;
  Camera *camera;
  
  KGLReferenceFrame *mainFrame, *frame2;
  KGLDemoCylinder *cylinder1;
}

@end
