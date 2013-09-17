//
//  KGLLight.m
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLLight.h"

@implementation KGLLight

- (void)loadUniformsForLight:(int)i into:(KGLShader *)shader {
  NSString *uniformName = [NSString stringWithFormat:@"LightSource[%d].position", i];
  glUniform4fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.eyePosition.v);
 
  uniformName = [NSString stringWithFormat:@"LightSource[%d].halfVector", i];
  glUniform4fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.eyeHalfVector.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].ambient", i];
  glUniform4fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.ambient.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].diffuse", i];
  glUniform4fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.diffuse.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].specular", i];
  glUniform4fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.specular.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].attenuation0", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.attenuation.x);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].attenuation1", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.attenuation.y);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].attenuation2", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.attenuation.z);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotDirection", i];
  glUniform3fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.eyeSpotDirection.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotRadius", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotRadius);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotCosCutoff", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotCosCutoff);
    
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotTightness", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotTightness);

}
@end
