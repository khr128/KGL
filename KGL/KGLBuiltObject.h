//
//  KGLBuiltObject.h
//  RaySmart
//
//  Created by khr on 10/20/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawable.h"

@class KGLIndexedObjectBuilder, KGLObjectBuilder;

@interface KGLBuiltObject : KGLDrawable

- (void)createIndexedDrawable: (KGLIndexedObjectBuilder*)builder;

@property (assign) GLfloat *coords;

@property (assign) GLushort *indices;

@property (assign) GLfloat *normals;

@property (strong) void (^customTemplate)();

- (void)createDrawable: (KGLObjectBuilder*)builder;

@property (assign) GLfloat *texCoords;

- (void)loadTextureCoordinatesFrom:(KGLObjectBuilder *)builder;
- (void)loadTextureCoordinatesFromIndexed:(KGLIndexedObjectBuilder *)builder;

@end
