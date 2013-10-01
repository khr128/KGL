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
@synthesize uuid;
@synthesize modelMatrix, localModelMatrix, children, parent, scene;

- (id)init {
  self = [super init];
  if (self) {
    localModelMatrix = GLKMatrix4Identity;
    children = [[NSMutableArray alloc] init];
    self.scaleX = self.scaleY = self.scaleZ = 1;
  }
  return self;
}

- (void)translateByX:(float)x y:(float)y z:(float)z {
  localModelMatrix.m30 += x;
  localModelMatrix.m31 += y;
  localModelMatrix.m32 += z;
}

- (void)translationX:(float)x y:(float)y z:(float)z {
  localModelMatrix.m30 = x;
  localModelMatrix.m31 = y;
  localModelMatrix.m32 = z;
}

- (void)setLocalModelMatrix3:(GLKMatrix3)rm {
  localModelMatrix.m00 = rm.m00;
  localModelMatrix.m01 = rm.m01;
  localModelMatrix.m02 = rm.m02;
  localModelMatrix.m10 = rm.m10;
  localModelMatrix.m11 = rm.m11;
  localModelMatrix.m12 = rm.m12;
  localModelMatrix.m20 = rm.m20;
  localModelMatrix.m21 = rm.m21;
  localModelMatrix.m22 = rm.m22;
}

- (void)rotationX:(float)radiansX y:(float)radiansY z:(float)radiansZ {
  GLKMatrix3 rm = GLKMatrix3MakeXRotation(radiansX);
  rm = GLKMatrix3RotateY(rm, radiansY);
  rm = GLKMatrix3RotateZ(rm, radiansZ);
  rm = GLKMatrix3Multiply(rm, GLKMatrix3MakeScale(self.scaleX, self.scaleY, self.scaleZ));
  
  [self setLocalModelMatrix3:rm];
}

- (void)scaleX:(float)x y:(float)y z:(float)z {
  GLKMatrix3 rm = GLKMatrix3Multiply(GLKMatrix4GetMatrix3(localModelMatrix), GLKMatrix3MakeScale(x/self.scaleX, y/self.scaleY, z/self.scaleZ));
  [self setLocalModelMatrix3:rm];
  
  self.scaleX = x;
  self.scaleY = y;
  self.scaleZ = z;
}

- (void)render {
  for (id<KGLRender> child in children) {
    [child render];
  }
}
@end
