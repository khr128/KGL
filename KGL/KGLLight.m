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
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].constantAttenuation", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.constantAttenuation);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].linearAttenuation", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.linearAttenuation);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].quadraticAttenuation", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.quadraticAttenuation);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotDirection", i];
  glUniform3fv(glGetUniformLocation(shader.program, [uniformName UTF8String]), 1, self.eyeSpotDirection.v);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotCutoff", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotCutoff);
  
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotCosCutoff", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotCosCutoff);
    
  uniformName = [NSString stringWithFormat:@"LightSource[%d].spotExponent", i];
  glUniform1f(glGetUniformLocation(shader.program, [uniformName UTF8String]), self.spotExponent);

}
@end
