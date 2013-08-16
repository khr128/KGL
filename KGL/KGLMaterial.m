//
//  KGLMaterial.m
//  GLfixed
//
//  Created by khr on 8/6/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLMaterial.h"

@implementation KGLMaterial

- (id)initWithEmissive:(GLKVector4)emissive_i
               ambient:(GLKVector4)ambient_i
               diffuse:(GLKVector4)diffuse_i
              specular:(GLKVector4)specular_i
             shininess:(GLfloat)shininess_i
{
  self = [super init];
  if (self) {
    emissive = emissive_i;
    ambient = ambient_i;
    diffuse = diffuse_i;
    specular = specular_i;
    shininess = shininess_i;
  }
  return self;
}

- (void)loadUniformsInto:(KGLShader *)shader {
  glUniform4fv(glGetUniformLocation(shader.program, "Material.emissive"), 1, emissive.v);
  glUniform4fv(glGetUniformLocation(shader.program, "Material.ambient"), 1, ambient.v);
  glUniform4fv(glGetUniformLocation(shader.program, "Material.diffuse"), 1, diffuse.v);
  glUniform4fv(glGetUniformLocation(shader.program, "Material.specular"), 1, specular.v);
  glUniform1f(glGetUniformLocation(shader.program, "Material.shininess"), shininess);
}
@end
