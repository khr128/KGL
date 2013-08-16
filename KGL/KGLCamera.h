//
//  KGLCamera.h
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface KGLCamera : NSObject {
  GLKMatrix4 projectionMatrix;
  GLKMatrix4 viewMatrix;
}

@property (readonly) GLKVector3 viewDir;

- (void)setProjectionFov:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;
- (void)setViewEye:(GLKVector3)eye center:(GLKVector3)center up:(GLKVector3)up;

- (GLKMatrix4)modelViewWith:(GLKMatrix4)modelMatrix;
- (GLKMatrix4)modelViewProjectionWith:(GLKMatrix4)modelViewMatrix;

- (GLKVector4)worldPosToEye:(GLKVector4)worldPos;
- (GLKVector4)worldVecToEye:(GLKVector4)worldVec;
- (GLKVector3)worldVec3ToEye3:(GLKVector3)worldVec3;
@end
