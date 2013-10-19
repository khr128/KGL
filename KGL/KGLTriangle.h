//
//  RSTriangle.h
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "KGLTesselate.h"

@class KGLParameterizedVertex;
@interface KGLTriangle : NSObject <KGLTesselate>

@property (strong) KGLParameterizedVertex * p1;
@property (strong) KGLParameterizedVertex * p2;
@property (strong) KGLParameterizedVertex * p3;

- (id)initWithP1:(KGLParameterizedVertex *)pt1 p2:(KGLParameterizedVertex *)pt3 p3:(KGLParameterizedVertex *)pt3;
@end
