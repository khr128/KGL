//
//  RSConeBuilder.m
//  RaySmart
//
//  Created by khr on 10/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLConeBuilder.h"
#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"
#import "KGLIndexedQuad.h"

#define PI 3.14159265359
#define TPI 2*PI
#define TINY 1.e-8

enum {
  kZSectors = 18,
  kPhiSectors = 36,
};


@implementation KGLConeBuilder
- (id)initWithP1:(KGLVector3 *)p1 r1:(float)radius1 p2:(KGLVector3 *)p2 r2:(float)radius2 {
  self = [super init];
  if (self) {
    r1 = radius1;
    dr = radius2 - radius1;
    
    l = [p2 subtract:p1];
    L = [l norm];
    l = [l divideByScalar:L];
    
    KGLVector3 * (^cartesianTransform)(KGLParameterizedVertex *);
    cartesianTransform = ^(KGLParameterizedVertex *v) {
      float rz = [self r:v.p3];
      return [self affineTransform:[[KGLVector3 alloc] initWithX:rz*cosf(v.p2)
                                        y:rz*sinf(v.p2)
                                        z:v.p3]];
    };
    
    KGLVector3 * (^inverseCartesianTransform)(KGLVector3 *);
    inverseCartesianTransform = ^(KGLVector3 *v) {
      KGLVector3 *r = [self inverseAffineTransform:v];
      float phi = atan2f(r.y, r.x);
      return [[KGLVector3 alloc] initWithX:1
                                        y:phi>0 ? phi : phi+TPI
                                        z:r.z];
    };

    int vertexCount = (kZSectors + 1)*(kPhiSectors + 1);
    self.vertices = [[NSMutableArray alloc] initWithCapacity:vertexCount];
    for (int i=0; i < vertexCount; ++i) {
      [self.vertices addObject:[NSNull null]];
    }
    float zDelta = 1.0 / kZSectors;
    float phiDelta = TPI / kPhiSectors;
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(kZSectors+1, globalQ, ^(size_t zi){
      for (int ph = 0; ph <= kPhiSectors; ++ph) {
        [self.vertices replaceObjectAtIndex:zi*(kPhiSectors+1)+ph withObject:[[KGLParameterizedVertex alloc]
                                                                          initWithP1:1
                                                                          p2:ph*phiDelta
                                                                          p3:zi*zDelta
                                                                          s:((GLfloat)ph)/kPhiSectors
                                                                          t:((GLfloat)zi)/kZSectors
                                                                          cartesianTransform:cartesianTransform
                                                                          inverseCartesianTransform:inverseCartesianTransform]];
      
      }
    });
    
    int elementCount = kZSectors*kPhiSectors;
    self.tesselationElements = [[NSMutableArray alloc] initWithCapacity:elementCount];
    for (int i=0; i < elementCount; ++i) {
      [self.tesselationElements addObject:[NSNull null]];
    }

    dispatch_apply(kZSectors, globalQ, ^(size_t zi){
      for (int ph=0; ph < kPhiSectors; ++ph) {
        [self.tesselationElements replaceObjectAtIndex:zi*kPhiSectors+ph
                                            withObject:[[KGLIndexedQuad alloc] initWithI1:(GLuint)(zi*(kPhiSectors+1)+ph)
                                                                                      i2:(GLuint)(zi*(kPhiSectors+1)+ph+1)
                                                                                      i3:(GLuint)((zi+1)*(kPhiSectors+1)+ph+1)
                                                                                      i4:(GLuint)((zi+1)*(kPhiSectors+1)+ph)
                                                                             andVertices:self.vertices]];
      }
    });
  }
  return self;
}

- (float)r:(float)z {
  return r1 + z*dr;
}

- (KGLVector3 *)affineTransform:(KGLVector3 *)r {
  KGLVector3 *transformedVector;
  if (1 + l.z > TINY) {
    float nr = (r.x*l.y-r.y*l.x)/(1+l.z);
    transformedVector =  [[KGLVector3 alloc] initWithX:r.x*l.z + L*l.x*r.z + nr*l.y
                                                    y:r.y*l.z + L*l.y*r.z - nr*l.x
                                                    z:L*r.z*l.z - r.x*l.x - r.y*l.y];
  } else {
    transformedVector = [[KGLVector3 alloc] initWithX:r.x y:r.y z:-L*r.z];
  }
  return transformedVector;
}

- (KGLVector3 *)inverseAffineTransform:(KGLVector3 *)r {
  KGLVector3 *transformedVector;
  if (1 + l.z > TINY) {
  float nr = (r.x*l.y-r.y*l.x)/(1+l.z);
  transformedVector = [[KGLVector3 alloc] initWithX:r.x*l.z + nr*l.y - l.x*r.z
                                    y:r.y*l.z - nr*l.x - l.y*r.z
                                    z:[l dot:r]/L];
  } else {
    transformedVector = [[KGLVector3 alloc] initWithX:r.x y:r.y z:-r.z/L];
  }
  return transformedVector;
}
@end
