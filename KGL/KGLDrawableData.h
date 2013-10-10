//
//  KGLDrawableData.h
//  GLfixed
//
//  Created by khr on 8/6/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface KGLDrawableData : NSObject {
  GLuint vao;
  GLuint posBufferName;
}

@property (assign) GLfloat *vertices;
@property (readonly) GLuint vertexSize;
@property (readonly) GLuint textureCoordsSize;

-(void)loadVertices:(const GLfloat *)array  size:(GLuint)size;
-(void)loadNormals:(const GLfloat *)array  size:(GLuint)size;
-(void)createNormals;
-(void)loadTextureCoords:(const GLfloat *)array size:(GLuint)size;

- (GLKVector3)normalFor:(int)baseIndex v1Index:(int)v1Index v2Index:(int)v2Index;
- (int)vertexCount;

- (GLfloat*)normals;
- (GLfloat*)textureCoords;

- (void)bindVertexArray;
- (void)bindArrayBuffer;
- (void)draw;

@end
