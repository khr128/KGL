//
//  RSIndexedTriangle.h
//  RaySmart
//
//  Created by khr on 9/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTesselate.h"

@interface KGLIndexedTriangle : NSObject<KGLTesselate>
@property (assign) GLuint i1;
@property (assign) GLuint i2;
@property (assign) GLuint i3;
@property (strong) NSMutableArray *vertices;

- (id)initWithI1:(GLuint)i1 i2:(GLuint)i2 i3:(GLuint)i3 andVertices:(NSMutableArray *)vertices;
@end
