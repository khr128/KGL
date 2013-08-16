//
//  KGLScene.h
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGLShader.h"
#import "KGLLights.h"
#import "KGLCamera.h"
#import "KGLObject.h"


@interface KGLScene : KGLObject

@property (strong) KGLShader *shader;
@property (strong) KGLLights *lights;
@property (strong) KGLCamera *camera;

- (void)addShaderVertex:(NSString *)vertexShaderFile fragment:(NSString *)fragmentShaderFile
         withAttributes:(NSArray *)attributes andUniforms:(NSArray *)uniforms;
- (void)loadLights;
- (void)computeLightsEyeCoordinates;

- (void) setModelTransformUniformsWith:(GLKMatrix4)objectModelMatrix;
@end
