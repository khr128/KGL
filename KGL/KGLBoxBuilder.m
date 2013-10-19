//
//  RSBoxBuilder.m
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLBoxBuilder.h"
#import "KGLQuad.h"
#import "KGLVector3.h"
#import "KGLParameterizedVertex.h"

@implementation KGLBoxBuilder

- (id)initWithCorner:(KGLVector3 *)oppositeCorner {
  self = [super init];
  if (self) {
    float dx = oppositeCorner.x;
    float dy = oppositeCorner.y;
    float dz = oppositeCorner.z;
    
    self.handedness = dx*dy*dz;

    float minD = MIN( ABS(dx), MIN(ABS(dy), ABS(dz)) );
    int nx, ny, nz;
    
    nx = abs(floorf(2*dx/minD+0.5));
    ny = abs(floorf(2*dy/minD+0.5));
    nz = abs(floorf(2*dz/minD+0.5));
    
    float ddx = dx/nx;
    float ddy = dy/ny;
    float ddz = dz/nz;
    
    int quadCount = 2*(nx*nz + ny*nz + nx*ny);
    self.tesselationElements = [[NSMutableArray alloc] initWithCapacity:quadCount];
    
    KGLVector3 * (^cartesianTransform)(KGLParameterizedVertex *);
    cartesianTransform = ^(KGLParameterizedVertex *v) {
      return [[KGLVector3 alloc] initWithX:v.p1 y:v.p2 z:v.p3];
    };
    KGLVector3 * (^inverseCartesianTransform)(KGLVector3 *);
    inverseCartesianTransform = ^(KGLVector3 *v) {
      return v;
    };
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, globalQ, ^{
      for (int iz=0; iz < nz; ++iz) {
        for (int ix=0; ix < nx; ++ix) {
          //First xz-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:0 p3:iz*ddz
                                                                              s:ix*ddx/dx
                                                                              t:iz*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:0 p3:iz*ddz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:iz*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
            
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:0 p3:(iz+1)*ddz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:(iz+1)*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:0 p3:(iz+1)*ddz
                                                                              s:ix*ddx/dx
                                                                              t:(iz+1)*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
          //Second xz-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:dy p3:iz*ddz
                                                                              s:ix*ddx/dx
                                                                              t:iz*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:dy p3:(iz+1)*ddz
                                                                              s:ix*ddx/dx
                                                                              t:(iz+1)*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:dy p3:(iz+1)*ddz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:(iz+1)*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:dy p3:iz*ddz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:iz*ddz/dz
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
        }
      }
    });
    
    dispatch_group_async(group, globalQ, ^{
      for (int iy=0; iy < ny; ++iy) {
        for (int ix=0; ix < nx; ++ix) {
          //First xy-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:iy*ddy p3:0
                                                                              s:ix*ddx/dx
                                                                              t:iy*ddy/dy
                                                              cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:(iy+1)*ddy p3:0
                                                                              s:ix*ddx/dx
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:(iy+1)*ddy p3:0
                                                                              s:(ix+1)*ddx/dx
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:iy*ddy p3:0
                                                                              s:(ix+1)*ddx/dx
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
          //Second xy-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:iy*ddy p3:dz
                                                                              s:ix*ddx/dx
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:iy*ddy p3:dz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:(ix+1)*ddx p2:(iy+1)*ddy p3:dz
                                                                              s:(ix+1)*ddx/dx
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:ix*ddx p2:(iy+1)*ddy p3:dz
                                                                              s:ix*ddx/dx
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
        }
      }
    });
    
    dispatch_group_async(group, globalQ, ^{
      for (int iz=0; iz < nz; ++iz) {
        for (int iy=0; iy < ny; ++iy) {
          //First yz-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:[[KGLParameterizedVertex alloc] initWithP1:0 p2:iy*ddy p3:iz*ddz
                                                                              s:iz*ddz/dz
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:0 p2:iy*ddy p3:(iz+1)*ddz
                                                                              s:(iz+1)*ddz/dz
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:0 p2:(iy+1)*ddy p3:(iz+1)*ddz
                                                                              s:(iz+1)*ddz/dz
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:0 p2:(iy+1)*ddy p3:iz*ddz
                                                                              s:iz*ddz/dz
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
          //Second yz-face
          [self.tesselationElements addObject:
           [[KGLQuad alloc] initWithP1:
            [[KGLParameterizedVertex alloc] initWithP1:dx p2:iy*ddy p3:iz*ddz
                                                    s:iz*ddz/dz
                                                    t:iy*ddy/dy
                                   cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p2:[[KGLParameterizedVertex alloc] initWithP1:dx p2:(iy+1)*ddy p3:iz*ddz
                                                                              s:iz*ddz/dz
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p3:[[KGLParameterizedVertex alloc] initWithP1:dx p2:(iy+1)*ddy p3:(iz+1)*ddz
                                                                              s:(iz+1)*ddz/dz
                                                                              t:(iy+1)*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]
                                   p4:[[KGLParameterizedVertex alloc] initWithP1:dx p2:iy*ddy p3:(iz+1)*ddz
                                                                              s:(iz+1)*ddz/dz
                                                                              t:iy*ddy/dy
                                                             cartesianTransform:cartesianTransform inverseCartesianTransform:inverseCartesianTransform]]];
        }
      }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
  }
  return self;
}

- (void)makeLefthanded:(GLfloat*)vertices count:(int)coordCount {
  float tmp;
  for (int i=0; i < coordCount; i += 9) {
    for(int j=0; j < 3; ++j) {
      tmp = vertices[i+j];
      vertices[i+j] = vertices[i+j+3];
      vertices[i+j+3] = tmp;
    }
  }
}

-(GLfloat *)toFloats {
  GLfloat *coords = [super toFloats];
  int coordCount = (int)self.tesselation.count*9;

  if (self.handedness < 0) {
    [self makeLefthanded:coords count:coordCount];
  }
  return coords;
}

@end
