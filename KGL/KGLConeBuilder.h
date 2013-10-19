//
//  RSConeBuilder.h
//  RaySmart
//
//  Created by khr on 10/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLIndexedObjectBuilder.h"

@class KGLParameterizedVertex, KGLVector3;
@interface KGLConeBuilder : KGLIndexedObjectBuilder {
  float L;
  KGLVector3 *l;
  float r1, dr;
}

- (id)initWithP1:(KGLVector3 *)p1 r1:(float)radius1 p2:(KGLVector3 *)p2 r2:(float)radius2;
- (KGLVector3 *)affineTransform:(KGLVector3 *)v;
- (KGLVector3 *)inverseAffineTransform:(KGLVector3 *)v;
@end
