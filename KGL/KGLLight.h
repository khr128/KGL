//
//  KGLLight.h
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "KGLShader.h"

@interface KGLLight : NSObject
@property (strong) NSString *uuid;

@property (assign) GLKVector4 worldPosition;
@property (assign) GLKVector4 eyePosition;
@property (assign) GLKVector4 worldHalfVector;
@property (assign) GLKVector4 eyeHalfVector;
@property (assign) GLKVector4 ambient;
@property (assign) GLKVector4 diffuse;
@property (assign) GLKVector4 specular;
@property (assign) GLfloat shininess;

@property (assign) GLKVector3 attenuation;

@property (assign) GLKVector3 worldSpotDirection;
@property (assign) GLKVector3 eyeSpotDirection;
@property (assign) GLfloat spotExponent;
@property (assign) GLfloat spotCosCutoff;
@property (assign) GLfloat spotCutoff;


- (void)loadUniformsForLight:(int)i into:(KGLShader *)shader;

@end
