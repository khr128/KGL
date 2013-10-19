//
//  RSVector3.h
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLVector3 : NSObject

@property (assign) float x;
@property (assign) float y;
@property (assign) float z;

- (id)initWithX:(float)xi y:(float)yi z:(float)zi;
- (KGLVector3 *)add:(KGLVector3*)v;
- (KGLVector3 *)subtract:(KGLVector3*)v;
- (KGLVector3 *)divideByScalar:(float)c;
- (KGLVector3 *)divideBy:(KGLVector3 *)v;
- (KGLVector3 *)normalize;
- (float)dot:(KGLVector3 *)v;
- (float)norm;
- (GLfloat *)toFloats;
@end
