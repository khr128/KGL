//
//  RSSphereBuilder.m
//  RaySmart
//
//  Created by khr on 9/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLSphereBuilder.h"
#import "KGLVector3.h"
#import "KGLParameterizedVertex.h"
#import "KGLIndexedQuad.h"
#import "KGLIndexedTriangle.h"

enum {
  kThetaSectors = 18,
  kPhiSectors = 36,
};

#define PI 3.14159265359
#define SMALL_THETA  PI/180
#define TPI 2*PI

@implementation KGLSphereBuilder
@synthesize computesNormals = _computesNormals;

- (int)vertexCount {
  int vertexCount = 2 + (kPhiSectors + 1)*(kThetaSectors - 1);
  return vertexCount;
}

- (void)computeVertices:(float)r {
  KGLVector3 * (^cartesianTransform)(KGLParameterizedVertex *);
  cartesianTransform = ^(KGLParameterizedVertex *v) {
    return [[KGLVector3 alloc] initWithX:v.p1*sinf(v.p2)*cosf(v.p3)
                                      y:v.p1*sinf(v.p2)*sinf(v.p3)
                                      z:v.p1*cosf(v.p2)];
  };
  KGLVector3 * (^inverseCartesianTransform)(KGLVector3 *);
  inverseCartesianTransform = ^(KGLVector3 *v) {
    float phi = atan2f(v.y, v.x);
    return [[KGLVector3 alloc] initWithX:r
                                      y:acosf(v.z/[v norm])
                                      z:phi>0 ? phi : phi+TPI];
  };
  
  int vertexCount = [self vertexCount];
  self.vertices = [[NSMutableArray alloc] initWithCapacity:vertexCount];
  for (int i=0; i < vertexCount; ++i) {
    [self.vertices addObject:[NSNull null]];
  }
  [self.vertices replaceObjectAtIndex:0 withObject:[[KGLParameterizedVertex alloc] initWithP1:r
                                                                                          p2:0
                                                                                          p3:0
                                                                                           s:0
                                                                                           t:0
                                                                          cartesianTransform:cartesianTransform
                                                                   inverseCartesianTransform:inverseCartesianTransform]];
  
  [self.vertices replaceObjectAtIndex:vertexCount-1 withObject:[[KGLParameterizedVertex alloc] initWithP1:r
                                                                                                      p2:PI
                                                                                                      p3:0
                                                                                                       s:1
                                                                                                       t:1
                                                                                      cartesianTransform:cartesianTransform
                                                                               inverseCartesianTransform:inverseCartesianTransform]];
  
  float thetaDelta = (PI - 2*SMALL_THETA) / (kThetaSectors - 2);
  float phiDelta = TPI / kPhiSectors;
  
  dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_apply(kThetaSectors-1, globalQ, ^(size_t th){
    for (int ph = 0; ph <= kPhiSectors; ++ph) {
      GLfloat theta = SMALL_THETA + th*thetaDelta;
      [self.vertices replaceObjectAtIndex:1+th*(kPhiSectors+1)+ph withObject:[[KGLParameterizedVertex alloc]
                                                                          initWithP1:r
                                                                          p2:theta
                                                                          p3:ph*phiDelta
                                                                          s:((GLfloat)ph)/kPhiSectors
                                                                          t:theta/PI
                                                                          cartesianTransform:cartesianTransform
                                                                          inverseCartesianTransform:inverseCartesianTransform]];
      
    }
  });
}

- (id)initWithRadius:(float)r {
  self = [super init];
  if (self) {
    _computesNormals = YES;
    [self computeVertices:r];
    
    int elementCount = kThetaSectors*kPhiSectors;
    self.tesselationElements = [[NSMutableArray alloc] initWithCapacity:elementCount];
    for (int i=0; i < elementCount; ++i) {
      [self.tesselationElements addObject:[NSNull null]];
    }
    
    //Top cap
    for (int ph=0; ph < kPhiSectors; ++ph) {
      [self.tesselationElements replaceObjectAtIndex:ph
                                          withObject:[[KGLIndexedTriangle alloc] initWithI1:0
                                                                                        i2:ph+1
                                                                                        i3:ph+2
                                                                               andVertices:self.vertices]];
    }
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(kThetaSectors-2, globalQ, ^(size_t th){
      for (int ph=0; ph < kPhiSectors; ++ph) {
        [self.tesselationElements replaceObjectAtIndex:(th+1)*kPhiSectors+ph
                                            withObject:[[KGLIndexedQuad alloc] initWithI1:(GLuint)(1+th*(kPhiSectors+1)+ph)
                                                                                      i2:(GLuint)(1+(th+1)*(kPhiSectors+1)+ph)
                                                                                      i3:(GLuint)(2+(th+1)*(kPhiSectors+1)+ph)
                                                                                      i4:(GLuint)(2+th*(kPhiSectors+1)+ph)
                                                                             andVertices:self.vertices]];
      }
    });
    
    //Bottom cap
    int vertexCount = [self vertexCount];
    for (int ph=0; ph < kPhiSectors; ++ph) {
      [self.tesselationElements replaceObjectAtIndex:elementCount-kPhiSectors+ph
                                          withObject:[[KGLIndexedTriangle alloc] initWithI1:vertexCount-kPhiSectors+ph-2
                                                                                        i2:vertexCount-1
                                                                                        i3:vertexCount-kPhiSectors+ph-1
                                                                               andVertices:self.vertices]];
    }
  }
  return self;
}

-(GLfloat *)toNormals {
  GLfloat *array = malloc(3*self.vertices.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLParameterizedVertex *vertex in self.vertices) {
    const GLfloat * const vertexArray = [[[vertex vector3] normalize] toFloats];
    memcpy(offset, vertexArray, 3*sizeof(GLfloat));
    offset += 3;
  }
  return array;
}

@end
