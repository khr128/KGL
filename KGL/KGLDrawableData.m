//
//  KGLDrawableData.m
//  GLfixed
//
//  Created by khr on 8/6/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawableData.h"

@implementation KGLDrawableData
@synthesize vertices=_vertices, vertexSize;

- (id)init {
  self = [super init];
  if (self) {
    if ([NSOpenGLContext currentContext]) {
      glGenVertexArrays(1, &vao);
      [self bindVertexArray];
    }
  }
  return self;
}

-(void)loadVertices:(const GLfloat *)array  size:(GLuint)size {
  free((void *)_vertices);
  vertexSize = size;
  _vertices = malloc(size);
  memcpy(_vertices, array, size);
  
  if ([NSOpenGLContext currentContext]) {
    glGenBuffers(1, &posBufferName);
    glBindBuffer(GL_ARRAY_BUFFER, posBufferName);
    glBufferData(GL_ARRAY_BUFFER, vertexSize, _vertices, GL_STATIC_DRAW);
  }
}

- (GLKVector3)normalFor:(int)baseIndex v1Index:(int)v1Index v2Index:(int)v2Index {
  GLKVector3 v1 = GLKVector3Make(_vertices[v1Index] - _vertices[baseIndex],
                                 _vertices[v1Index + 1] - _vertices[baseIndex + 1],
                                 _vertices[v1Index + 2] - _vertices[baseIndex + 2]);
  GLKVector3 v2 = GLKVector3Make(_vertices[v2Index] - _vertices[baseIndex],
                                 _vertices[v2Index + 1] - _vertices[baseIndex + 1],
                                 _vertices[v2Index + 2] - _vertices[baseIndex + 2]);
  return GLKVector3Normalize(GLKVector3CrossProduct(v1, v2));
}

-(void)createNormals {
  GLfloat *p = realloc(_vertices, 2*vertexSize);
  if (p) {
    _vertices = p;
    [self bindArrayBuffer];
  } else {
    NSLog(@"KGLDrawableData::createNormals failed to allocate memory for normals");
  }
}

- (void)bindVertexArray {
    glBindVertexArray(vao);
}

- (void)bindArrayBuffer {
  if ([NSOpenGLContext currentContext]) {
    [self bindVertexArray];
    glBindBuffer(GL_ARRAY_BUFFER, posBufferName);
    glBufferData(GL_ARRAY_BUFFER, 2*vertexSize, _vertices, GL_STATIC_DRAW);
  }
}

- (int)vertexCount {
  return self.vertexSize / (3*sizeof(GLfloat));
}

- (GLfloat *)normals {
  return self.vertices + 3*[self vertexCount];
}

- (void)draw {
  glBindVertexArray(vao);
}

- (void)dealloc
{
  free(_vertices);
}

@end
