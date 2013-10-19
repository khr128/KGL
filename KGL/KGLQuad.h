//
//  RSQuad.h
//  RaySmart
//
//  Created by khr on 9/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTesselate.h"

@class KGLParameterizedVertex;

@interface KGLQuad : NSObject<KGLTesselate>

@property (strong) KGLParameterizedVertex *p1;
@property (strong) KGLParameterizedVertex *p2;
@property (strong) KGLParameterizedVertex *p3;
@property (strong) KGLParameterizedVertex *p4;

- (id)initWithP1:(KGLParameterizedVertex *)pt1 p2:(KGLParameterizedVertex *)pt2 p3:(KGLParameterizedVertex *)pt3 p4:(KGLParameterizedVertex *)pt4;

@end
