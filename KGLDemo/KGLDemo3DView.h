//
//  KGLDemo3DView.h
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KGLScene;
@interface KGLDemo3DView : NSOpenGLView {
  GLuint viewWidth;
  GLuint viewHeight;
  KGLScene *scene;
}

@end
