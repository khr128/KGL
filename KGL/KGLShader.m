//
//  KGLShader.m
//  GLfixed
//
//  Created by khr on 8/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLShader.h"

@interface KGLShader(Private)
- (void)logShaderCompilation:(GLuint)shader filename:(NSString *)filename;
- (void)loadAndCompileShader:(GLuint)shader fromFile:(NSString *)filename;
- (void)logProgramCompilation:(GLuint)program op:(NSString *)op;
@end

@implementation KGLShader
@synthesize program = _program, vertexShaderFile, fragmentShaderFile, attributes, uniforms;

-(void)build {  
  GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
  GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
  
  [self loadAndCompileShader:vertexShader fromFile:self.vertexShaderFile];
  [self loadAndCompileShader:fragmentShader fromFile:self.fragmentShaderFile];

  _program = glCreateProgram();
  
  GLuint i = 1;
  for(NSString *attributeName in self.attributes) {
    glBindAttribLocation(_program, i++, [attributeName UTF8String]);
  }
  
  glAttachShader(_program, vertexShader);
  glAttachShader(_program, fragmentShader);
  
  glDeleteShader(vertexShader);
  glDeleteShader(fragmentShader);
  
  glLinkProgram(_program);
  [self logProgramCompilation:_program op:@"link"];
  
  glValidateProgram(_program);
  [self logProgramCompilation:_program op:@"validate"];
  
  for (NSString *uniform in self.uniforms) {
    GLint uniformIndex = glGetUniformLocation(_program, [uniform UTF8String]);
    if (uniformIndex < 0) {
      NSLog(@"No %@ uniform in shader", uniform);
    }
  }
}

- (void)loadAndCompileShader:(GLuint)shader fromFile:(NSString *)filename {
  NSString *filePathName = nil;
  NSArray *components = [filename componentsSeparatedByString:@"."];
  filePathName = [[NSBundle mainBundle] pathForResource:[components objectAtIndex:0] ofType:[components objectAtIndex:1]];
  NSString *source;
  NSError *error;
  source = [[NSString alloc] initWithContentsOfFile:filePathName encoding:NSUTF8StringEncoding error:&error];
  
  const char *csource = [source UTF8String];
  glShaderSource(shader, 1, (const GLchar **) &csource, NULL);
  glCompileShader(shader);
  
  GLint logLength;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
  
  [self logShaderCompilation:shader filename:filename];
}

- (void)logShaderCompilation:(GLuint)shader filename:(NSString *)filename {
  GLint logLength;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
  
	if (logLength > 0) {
    GLchar *log = (GLchar*) malloc(logLength);
    glGetShaderInfoLog(shader, logLength, &logLength, log);
    NSLog(@"%@ Shader compile log:%s\n", filename, log);
    free(log);
  }
}

- (void)logProgramCompilation:(GLuint)program op:(NSString *)op{
  GLint logLength;
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(program, logLength, &logLength, log);
    NSLog(@"Program %@ log:\n%s\n", op, log);
    free(log);
  }
}
@end
