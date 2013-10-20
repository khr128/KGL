//
//  KGLBuiltObject.m
//  RaySmart
//
//  Created by khr on 10/20/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLBuiltObject.h"
#import "KGLIndexedObjectBuilder.h"
#import "KGLDrawableDataIndexed.h"
#import "KGLDrawableDataArray.h"

@implementation KGLBuiltObject

- (void)createIndexedDrawable:(KGLIndexedObjectBuilder *)builder {
  [builder tesselateWithLevel:builder.tesselationLevel()];
  self.coords = [builder toFloats];
  self.indices = [builder toIndices];
  
  int coordCount = (int)builder.vertices.count*3;
  int indexCount = (int)builder.tesselation.count*3;
  self.data = [[KGLDrawableDataIndexed alloc] init];
  [self.data loadVertices:self.coords size:coordCount*sizeof(GLfloat)];
  [(KGLDrawableDataIndexed *)self.data loadIndices:self.indices size:indexCount*sizeof(GLushort)];
  
  if (builder.computesNormals) {
    self.normals = [builder toNormals];
    [self.data loadNormals:self.normals size:coordCount*sizeof(GLfloat)];
  } else {
    [self.data createNormals];
  }
  
  self.customTemplate();
}

- (void)createDrawable:(KGLObjectBuilder*)builder{
  [builder tesselateWithLevel:builder.tesselationLevel()];
  
  self.coords = [builder toFloats];
  
  int coordCount = (int)builder.tesselation.count*9;
  self.data = [[KGLDrawableDataArray alloc] init];
  [self.data loadVertices:self.coords size:coordCount*sizeof(GLfloat)];
  [self.data createNormals];
  
  self.customTemplate();
}

- (void)loadTextureCoordinatesFrom:(KGLObjectBuilder *)builder {
  self.texCoords = [builder toTexCoords];
  [self.data loadTextureCoords:self.texCoords size:(int)builder.tesselation.count*6*sizeof(GLfloat)];
}

- (void)loadTextureCoordinatesFromIndexed:(KGLIndexedObjectBuilder *)builder {
  self.texCoords = [builder toTexCoords];
  [self.data loadTextureCoords:self.texCoords size:(int)builder.vertices.count*2*sizeof(GLfloat)];
}

- (void)dealloc {
  free(self.coords);
  free(self.indices);
  free(self.texCoords);
  free(self.normals);
}

@end
