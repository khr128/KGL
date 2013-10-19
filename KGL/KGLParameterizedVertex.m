//
//  RSVertex.m
//  RaySmart
//
//  Created by khr on 9/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"

@implementation KGLParameterizedVertex

- (id)initWithP1:(float)p1 p2:(float)p2 p3:(float)p3
           cartesianTransform:(KGLVector3 * (^)(KGLParameterizedVertex *))ct
    inverseCartesianTransform:(KGLVector3 * (^)(KGLVector3 *))ict {
  return self = [self initWithP1:p1 p2:p2 p3:p3 s:0 t:0 cartesianTransform:ct inverseCartesianTransform:ict];
}

- (id)initWithP1:(float)p1 p2:(float)p2 p3:(float)p3 s:(float)s t:(float)t
cartesianTransform:(KGLVector3 * (^)(KGLParameterizedVertex *))ct
inverseCartesianTransform:(KGLVector3 * (^)(KGLVector3 *))ict {
  self = [super init];
  if (self) {
    self.p1 = p1;
    self.p2 = p2;
    self.p3 = p3;
    self.s = s;
    self.t = t;
    cartesianTransform = ct;
    inverseCartesianTransform = ict;
  }
  return self;
}


- (KGLVector3 *)vector3 {
  return cartesianTransform(self);
}

- (KGLParameterizedVertex *)midPointWith:(KGLParameterizedVertex *)v {
  KGLVector3 *midpoint = [[[self vector3] add:[v vector3]] divideByScalar:2];
  KGLVector3 *params = inverseCartesianTransform(midpoint);
  return [[KGLParameterizedVertex alloc] initWithP1:params.x p2:params.y p3:params.z
                                                 s:(self.s + v.s)/2
                                                 t:(self.t + v.t)/2
                                cartesianTransform:cartesianTransform
                         inverseCartesianTransform:inverseCartesianTransform];

}

- (KGLParameterizedVertex *)midPointWith:(KGLParameterizedVertex *)v1 and:(KGLParameterizedVertex *)v2 {
  KGLVector3 *midpoint = [[[[self vector3] add:[v1 vector3]] add:[v2 vector3]] divideByScalar:3];
  KGLVector3 *params = inverseCartesianTransform(midpoint);
  return [[KGLParameterizedVertex alloc] initWithP1:params.x p2:params.y p3:params.z
                                                 s:(self.s + v1.s + v2.s)/3
                                                 t:(self.t + v1.t + v2.t)/3
                                cartesianTransform:cartesianTransform
                         inverseCartesianTransform:inverseCartesianTransform];
}

@end
