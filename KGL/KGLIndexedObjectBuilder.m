//
//  RSIndexedObjectBuilder.m
//  RaySmart
//
//  Created by khr on 10/1/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLIndexedObjectBuilder.h"
#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"

@implementation KGLIndexedObjectBuilder

-(GLfloat *)toFloats {
  GLfloat *array = malloc(3*self.vertices.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLParameterizedVertex *vertex in self.vertices) {
    const GLfloat * const vertexArray = [[vertex vector3] toFloats];
    memcpy(offset, vertexArray, 3*sizeof(GLfloat));
    offset += 3;
  }
  return array;
}

-(GLfloat *)toTexCoords {
  GLfloat *array = malloc(6*self.vertices.count*sizeof(GLfloat));
  GLfloat *offset = array;
  for (KGLParameterizedVertex *vertex in self.vertices) {
    *offset = vertex.s;
    *(offset + 1) = vertex.t;
    offset += 2;
  }
  return array;
}

- (void)dealloc {
  free(self.textureCoords);
}

@end
