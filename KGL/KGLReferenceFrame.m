//
//  KGLReferenceFrame.m
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLReferenceFrame.h"

@implementation KGLReferenceFrame
- (void)render {
  self.modelMatrix = GLKMatrix4Multiply(self.parent.modelMatrix, self.localModelMatrix);
  [super render];
}

- (void) addChild:(id<KGLRender,KGLModelingHierarchy>)child {
  child.scene = self.scene;
  child.parent = self;
  [self.children addObject:child];
}
@end
