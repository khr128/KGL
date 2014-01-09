//
//  KGLDrawable.m
//  GLfixed
//
//  Created by khr on 8/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawable.h"
#import "KGLShaderAttribute.h"
#import "KGLScene.h"
#import "KGLTexture.h"

@implementation KGLDrawable
@synthesize shaderAttributes, scene, shaderName, shader;

- (id) init {
  self = [super init];
  if (self) {
    self.shaderName = @"default";
  }
  return self;
}

- (void) setScene:(KGLScene *)sceneObject {
  scene = sceneObject;
  [self.data bindArrayBuffer];
  shader = [scene.shaders objectForKey:self.shaderName];
  for(NSString *attributeName in shader.attributes) {
    GLuint posAttribIndex = glGetAttribLocation(shader.program, [attributeName UTF8String]);
    KGLShaderAttribute *attribute = [shaderAttributes objectForKey:attributeName];
    [attribute enableVertexArray:posAttribIndex];
  }
}

- (void)render {
  [self.data bindArrayBuffer];

  glUseProgram(shader.program);
  
  [material loadUniformsInto:shader];
  [scene loadLightsInto:shader];
  
  GLKMatrix4 globalModelMatrix = GLKMatrix4Multiply(self.parent.modelMatrix, self.localModelMatrix);
  [scene setModelTransformUniformsIn:shader with:globalModelMatrix];
  
  glActiveTexture(GL_TEXTURE0);
  glUniform1i(glGetUniformLocation(shader.program, "tex"), 0);
  
  [self.texture bind];
  [self.data draw];
  [self.texture unbind];
}

@end
