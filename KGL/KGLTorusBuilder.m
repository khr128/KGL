//
//  RSTorusBuilder.m
//  RaySmart
//
//  Created by khr on 10/1/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTorusBuilder.h"
#import "KGLVector3.h"
#import "KGLParameterizedVertex.h"
#import "KGLIndexedQuad.h"

#define PI 3.14159265359
#define TPI 2*PI

enum {
  kThetaSectors = 18,
  kPhiSectors = 36,
};

@implementation KGLTorusBuilder
@synthesize computesNormals = _computesNormals;

- (id)initWithLargeRadius:(float)R andSmallRadius:(float)r {
  self = [super init];
  if (self) {
    _computesNormals = YES;

    KGLVector3 * (^cartesianTransform)(KGLParameterizedVertex *);
    cartesianTransform = ^(KGLParameterizedVertex *v) {
      float Rr = R + r*cosf(v.p2);
      return [[KGLVector3 alloc] initWithX:Rr*cosf(v.p3)
                                        y:Rr*sinf(v.p3)
                                        z:r*sinf(v.p2)];
    };
    
    float (^theta)(float, float);
    theta = ^(float rhomR, float z) {
      float rs = sqrtf(rhomR*rhomR + z*z);
      float retval = asinf(z/rs);
      
      if (rhomR < 0) {
          retval = PI - retval;
      } else {
        if (z < 0) {
          retval += TPI;
        }
      }
      
      return retval;
    };
    
    KGLVector3 * (^inverseCartesianTransform)(KGLVector3 *);
    inverseCartesianTransform = ^(KGLVector3 *v) {
      float phi = atan2f(v.y, v.x);
      float rhomR = sqrtf(v.x*v.x + v.y*v.y) - R;
      return [[KGLVector3 alloc] initWithX:R
                                        y:theta(rhomR, v.z)
                                        z:phi>0 ? phi : phi+TPI];
    };
    
    int vertexCount = (kPhiSectors+1)*(kThetaSectors+1);
    self.vertices = [[NSMutableArray alloc] initWithCapacity:vertexCount];
    for (int i=0; i < vertexCount; ++i) {
      [self.vertices addObject:[NSNull null]];
    }
    
    float thetaDelta = TPI / kThetaSectors;
    float phiDelta = TPI / kPhiSectors;
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(kPhiSectors+1, globalQ, ^(size_t ph){
      for (int th = 0; th <= kThetaSectors; ++th) {
        [self.vertices replaceObjectAtIndex:ph*(kThetaSectors+1)+th withObject:[[KGLParameterizedVertex alloc] initWithP1:R
                                                                                                                  p2:th*thetaDelta
                                                                                                                  p3:ph*phiDelta
                                                                                                                   s:((GLfloat)th)/kThetaSectors
                                                                                                                   t:((GLfloat)ph)/kPhiSectors
                                                                                                  cartesianTransform:cartesianTransform
                                                                                           inverseCartesianTransform:inverseCartesianTransform]];
        
      }
    });
    
    int elementCount = kThetaSectors*kPhiSectors;
    self.tesselationElements = [[NSMutableArray alloc] initWithCapacity:elementCount];
    for (int i=0; i < elementCount; ++i) {
      [self.tesselationElements addObject:[NSNull null]];
    }
    
    dispatch_apply(kPhiSectors, globalQ, ^(size_t ph){
      for (int th=0; th < kThetaSectors; ++th) {
        [self.tesselationElements replaceObjectAtIndex:ph*kThetaSectors+th
                                            withObject:[[KGLIndexedQuad alloc] initWithI1:(GLuint)(ph*(kThetaSectors+1)+th)
                                                                                      i2:(GLuint)((ph+1)*(kThetaSectors+1)+th)
                                                                                      i3:(GLuint)((ph+1)*(kThetaSectors+1)+th+1)
                                                                                      i4:(GLuint)(ph*(kThetaSectors+1)+th+1)
                                                                             andVertices:self.vertices]];
      }
    });
  }
  return self;
}

-(GLfloat *)toNormals {
  GLfloat *array = malloc(3*self.vertices.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLParameterizedVertex *vertex in self.vertices) {
    KGLVector3 *centerLine = [[KGLVector3 alloc] initWithX:vertex.p1*cosf(vertex.p3) y:vertex.p1*sinf(vertex.p3) z:0];
    const GLfloat * const vertexArray = [[[[vertex vector3] subtract:centerLine] normalize] toFloats];
    memcpy(offset, vertexArray, 3*sizeof(GLfloat));
    offset += 3;
  }
  return array;
}

@end
