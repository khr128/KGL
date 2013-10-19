//
//  RSVertex.h
//  RaySmart
//
//  Created by khr on 9/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGLVector3;

@interface KGLParameterizedVertex : NSObject {
  KGLVector3 * (^cartesianTransform)(KGLParameterizedVertex *);
  KGLVector3 * (^inverseCartesianTransform)(KGLVector3 *);
}
@property (assign) float p1;
@property (assign) float p2;
@property (assign) float p3;
@property (assign) float s;
@property (assign) float t;

- (id)initWithP1:(float)p1 p2:(float)p2 p3:(float)p3 s:(float)s t:(float)t
cartesianTransform:(KGLVector3 * (^)(KGLParameterizedVertex *))ct
inverseCartesianTransform:(KGLVector3 * (^)(KGLVector3 *))ict;

- (id)initWithP1:(float)p1 p2:(float)p2 p3:(float)p3
cartesianTransform:(KGLVector3 * (^)(KGLParameterizedVertex *))ct
inverseCartesianTransform:(KGLVector3 * (^)(KGLVector3 *))ict;

- (KGLVector3 *)vector3;
- (KGLParameterizedVertex *)midPointWith:(KGLParameterizedVertex *)v;
- (KGLParameterizedVertex *)midPointWith:(KGLParameterizedVertex *)v1 and:(KGLParameterizedVertex *)v2;
@end
