//
//  RSObjectBuilder.h
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTesselate.h"


@interface KGLObjectBuilder : NSObject <KGLTesselate>

@property (strong) NSMutableArray *tesselationElements;
@property (strong) NSMutableArray *tesselation;
@property (assign) GLfloat *textureCoords;

@end
