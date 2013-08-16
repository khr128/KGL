//
//  KGLDrawableDataArray.m
//  GLfixed
//
//  Created by khr on 8/9/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawableDataArray.h"

@implementation KGLDrawableDataArray

- (GLKVector3)computeNormal:(int)vertex face:(int)face {
  int baseIndex = 3*(3*face + vertex);
  int v1Index = 3*(3*face + (vertex+1)%3);
  int v2Index = 3*(3*face + (vertex+2)%3);
  return [self normalFor:baseIndex v1Index:v1Index v2Index:v2Index];
}

- (int)faceCount {
  return [self vertexCount] / 3;
}

-(void)createNormals {
  [super createNormals];
  
  GLfloat *normals = [self normals];
  int faceCount = [self faceCount];
  for (int face=0; face < faceCount; ++face) {
    for (int vertex=0; vertex < 3; ++vertex) {
      GLKVector3 n = [self computeNormal:vertex face:face];
      for (int ni=0; ni<3; ++ni) {
        *(normals+3*(3*face+vertex)+ni) = n.v[ni];
      }
    }
  }
}

- (void)draw {
  [super draw];
  glDrawArrays(GL_TRIANGLES, 0, [self vertexCount]);
}

@end
