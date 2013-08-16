//
//  KGLDrawableDataIndexed.m
//  GLfixed
//
//  Created by khr on 8/9/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawableDataIndexed.h"
#import "GLKAverageNormal.h"

@implementation KGLDrawableDataIndexed

-(void)loadIndices:(const GLushort *)array  size:(GLuint)size {
  free((void *)indices);
  indexSize = size;
  indices = malloc(size);
  memcpy(indices, array, size);
  
  if ([NSOpenGLContext currentContext]) {
    GLuint ebo;
    glGenBuffers(1, &ebo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexSize, indices, GL_STATIC_DRAW);
  }
}

- (GLKVector3)computeNormal:(int)vertex face:(int)face {
  int baseIndex = 3*indices[3*face + vertex];
  int v1Index = 3*indices[3*face + (vertex+1)%3];
  int v2Index = 3*indices[3*face + (vertex+2)%3];
  return [self normalFor:baseIndex v1Index:v1Index v2Index:v2Index];
}

-(void)createNormals {
  [super createNormals];
  
  int vertexCount = [self vertexCount];
  
  NSMutableArray * averageNormals = [[NSMutableArray alloc] init];
  for (int i=0; i<vertexCount; ++i) {
    [averageNormals addObject:[[GLKAverageNormal alloc]init]];
  }
  
  int faceCount = indexSize / (3*sizeof(GLushort));
  
  for (int face=0; face < faceCount; ++face) {
    for (int vertex=0; vertex < 3; ++vertex) {
      GLKVector3 n = [self computeNormal:vertex face:face];
      GLKAverageNormal* an = [averageNormals objectAtIndex:indices[3*face + vertex]];
      [an add:n];
    }
  }
  
  GLfloat *normals = [self normals];
  
  for (int i=0; i<vertexCount; ++i) {
    GLKAverageNormal* an = [averageNormals objectAtIndex:i];
    GLKVector3 n = [an normal];
    for (int ni=0; ni<3; ++ni) {
      *(normals+3*i+ni) = n.v[ni];
    }
  }
}

- (void)draw {
  [super draw];
  glDrawElements(GL_TRIANGLES, indexSize / sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}

- (void)dealloc{
  free(indices);
}

@end
