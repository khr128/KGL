//
//  RSObjectBuilder.m
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLObjectBuilder.h"
#import "KGLTriangle.h"
#import "KGLIndexedTriangle.h"

@implementation KGLObjectBuilder
@synthesize computesNormals = _computesNormals;
@synthesize tesselationLevel;

- (id)init {
  self = [super init];
  if (self) {
    self.tesselation = [[NSMutableArray alloc] init];
    self.tesselationLevel = ^{ return (NSUInteger)0; };
    _computesNormals = NO;
  }
  return self;
}

- (NSArray *)tesselateWithLevel:(NSInteger)level {
  [self.tesselation removeAllObjects];
  for (id<KGLTesselate> element in self.tesselationElements) {
    [self.tesselation addObjectsFromArray:[element tesselateWithLevel:level]];
  }
  return self.tesselation;
}

- (GLfloat *)toFloats {
  GLfloat *array = malloc(9*self.tesselation.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLTriangle *triangle in self.tesselation) {
    const GLfloat * const triangleArray = [triangle toFloats];
    memcpy(offset, triangleArray, 9*sizeof(GLfloat));
    offset += 9;
  }
  return array;
}

- (GLushort *)toIndices {
  GLushort *array = malloc(3*self.tesselation.count*sizeof(GLuint));
  GLushort *offset = array;
  for (KGLIndexedTriangle *triangle in self.tesselation) {
    const GLushort * const triangleArray = [triangle toIndices];
    memcpy(offset, triangleArray, 3*sizeof(GLushort));
    offset += 3;
  }
  return array;
}

- (GLfloat *)toTexCoords {
  GLfloat *array = malloc(6*self.tesselation.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLTriangle *triangle in self.tesselation) {
    const GLfloat * const triangleArray = [triangle toTexCoords];
    memcpy(offset, triangleArray, 6*sizeof(GLfloat));
    offset += 6;
  }
  return array;
}

@end
