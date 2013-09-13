//
//  KGLTransformation.m
//  GLfixed
//
//  Created by khr on 8/16/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLObject.h"
#import <GLKit/GLKit.h>

@implementation KGLObject
@synthesize modelMatrix, localModelMatrix, children, parent, scene;

-(id)init {
  self = [super init];
  if (self) {
    localModelMatrix = GLKMatrix4Identity;
    children = [[NSMutableArray alloc] init];
  }
  return self;
}

-(void)translateByX:(float)x y:(float)y z:(float)z {
  localModelMatrix.m30 += x;
  localModelMatrix.m31 += y;
  localModelMatrix.m32 += z;
}

-(void)translationX:(float)x y:(float)y z:(float)z {
  localModelMatrix.m30 = x;
  localModelMatrix.m31 = y;
  localModelMatrix.m32 = z;
}

-(void)addChild:(id<KGLRender,KGLModelingHierarchy>)child {
}

- (void)render {
  for (id<KGLRender> child in children) {
    [child render];
  }
}
@end
