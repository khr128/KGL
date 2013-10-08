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

@implementation KGLDrawable
@synthesize shaderAttributes, scene;

- (void) setScene:(KGLScene *)sceneObject {
  scene = sceneObject;
  [data bindArrayBuffer];
  for(NSString *attributeName in scene.shader.attributes) {
    GLuint posAttribIndex = glGetAttribLocation(scene.shader.program, [attributeName UTF8String]);
    KGLShaderAttribute *attribute = [shaderAttributes objectForKey:attributeName];
    [attribute enableVertexArray:posAttribIndex];
  }
}

- (void)render {
  [data bindArrayBuffer];

  glUseProgram(scene.shader.program);
  
  [material loadUniformsInto:scene.shader];
  [scene loadLights];
  
  GLKMatrix4 globalModelMatrix = GLKMatrix4Multiply(self.parent.modelMatrix, self.localModelMatrix);
  [scene setModelTransformUniformsWith:globalModelMatrix];
  
  [data draw];
}

@end
