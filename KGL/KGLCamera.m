//
//  KGLCamera.m
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLCamera.h"

@implementation KGLCamera

- (void)setProjectionFov:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
  projectionMatrix = GLKMatrix4MakePerspective(fovyRadians, aspect, nearZ, farZ);
}

- (void)setViewEye:(GLKVector3)eye center:(GLKVector3)center up:(GLKVector3)up {
  _viewDir = GLKVector3Subtract(center, eye);
  viewMatrix = GLKMatrix4MakeLookAt(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
}

- (GLKMatrix4)modelViewWith:(GLKMatrix4)modelMatrix {
  return GLKMatrix4Multiply(viewMatrix, modelMatrix);
}
- (GLKMatrix4)modelViewProjectionWith:(GLKMatrix4)modelViewMatrix {
  return GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
}

- (GLKVector4)worldPosToEye:(GLKVector4)worldPos {
  return GLKMatrix4MultiplyVector4(viewMatrix, worldPos);
}
- (GLKVector4)worldVecToEye:(GLKVector4)worldVec {
  return GLKVector4Subtract([self worldPosToEye:worldVec], [self worldPosToEye:GLKVector4Make(0, 0, 0, 0)]);
}
- (GLKVector3)worldVec3ToEye3:(GLKVector3)worldVec3 {
  return GLKMatrix3MultiplyVector3(GLKMatrix4GetMatrix3(viewMatrix), worldVec3);
}
@end
