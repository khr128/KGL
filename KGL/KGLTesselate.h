//
//  RSTesselate.h
//  RaySmart
//
//  Created by khr on 9/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KGLTesselate <NSObject>
- (NSArray *)tesselateWithLevel:(NSInteger)level;
@property (readonly) BOOL computesNormals;

@optional
@property (strong) NSUInteger (^tesselationLevel)();
- (GLfloat *)toFloats;
- (GLfloat *)toNormals;
- (GLfloat *)toTexCoords;
- (GLushort *)toIndices;
- (int)vertexCount;
@end
