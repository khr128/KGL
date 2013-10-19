//
//  RSBoxBuilder.h
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLObjectBuilder.h"

@class KGLVector3;
@interface KGLBoxBuilder : KGLObjectBuilder
@property (assign) float handedness;

- (id)initWithCorner:(KGLVector3 *)oppositeCorner;
@end
