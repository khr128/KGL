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

@property (strong) NSMutableDictionary *shaders;
@property (strong) KGLLights *lights;
@property (strong) KGLCamera *camera;

- (void)addShaderVertex:(NSString *)vertexShaderFile
               fragment:(NSString *)fragmentShaderFile
         withAttributes:(NSArray *)attributes
            andUniforms:(NSArray *)uniforms;

- (void)addShaderNamed:(NSString *)shaderName
                vertex:(NSString *)vertexShaderFile
              fragment:(NSString *)fragmentShaderFile
        withAttributes:(NSArray *)attributes
           andUniforms:(NSArray *)uniforms;

- (void)loadLightsInto:(KGLShader *)shader;
- (void)computeLightsEyeCoordinates;

- (void) setModelTransformUniformsIn:(KGLShader *)shader with:(GLKMatrix4)objectModelMatrix;
@end
