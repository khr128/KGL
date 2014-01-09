//
//  KGLScene.m
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLScene.h"
#import "KGLError.h"

@implementation KGLScene
@synthesize shaders, lights, camera;
- (id)init {
  self = [super init];
  if (self) {
    lights = [[KGLLights alloc] init];
    camera = [[KGLCamera alloc] init];
    shaders = [[NSMutableDictionary alloc] init];
    self.modelMatrix = GLKMatrix4Identity;
  }
  return self;
}

- (void) addChild:(id<KGLRender,KGLModelingHierarchy>)child {
  child.scene = self;
  child.parent = self;
  [self.children addObject:child];
}

- (void)addShaderVertex:(NSString *)vertexShaderFile fragment:(NSString *)fragmentShaderFile
         withAttributes:(NSArray *)attributes andUniforms:(NSArray *)uniforms
{
  [self addShaderNamed:@"default"
                vertex:vertexShaderFile
              fragment:fragmentShaderFile
        withAttributes:attributes
           andUniforms:uniforms];
}

- (void)addShaderNamed:(NSString *)shaderName
                vertex:(NSString *)vertexShaderFile
              fragment:(NSString *)fragmentShaderFile
        withAttributes:(NSArray *)attributes
           andUniforms:(NSArray *)uniforms
{
  KGLShader *shader = [[KGLShader alloc] init];
  shader.vertexShaderFile = vertexShaderFile;
  shader.fragmentShaderFile = fragmentShaderFile;
  
  shader.attributes = attributes;
  shader.uniforms = uniforms;
  
  [shader build];
  
  [shaders setObject:shader forKey:shaderName];
  
  [KGLError log];
}

- (void)loadLightsInto:(KGLShader *)shader {
  [lights loadUniformsInto:shader];
}

- (void)computeLightsEyeCoordinates {
  [lights computeEyeCoordsWith:camera];
}

- (void)setModelTransformUniformsIn:(KGLShader *)shader with:(GLKMatrix4)objectModelMatrix {
  GLKMatrix4 modelViewMatrix = [camera modelViewWith:objectModelMatrix]; //camera defines view matrix
  GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  GLKMatrix4 mvp = [camera modelViewProjectionWith:modelViewMatrix]; //camera defines projection matrix
  
  glUniformMatrix4fv(glGetUniformLocation(shader.program, "modelViewProjectionMatrix"), 1, GL_FALSE, mvp.m);
  glUniformMatrix4fv(glGetUniformLocation(shader.program, "modelViewMatrix"), 1, GL_FALSE, modelViewMatrix.m);
  glUniformMatrix3fv(glGetUniformLocation(shader.program, "normalMatrix"), 1, GL_FALSE, normalMatrix.m);
}

@end
