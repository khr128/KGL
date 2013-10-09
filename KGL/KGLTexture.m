//
//  KGLTexture.m
//  KGL
//
//  Created by khr on 10/8/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTexture.h"

@implementation KGLTexture
@synthesize texName=_texName;

- (id)initWithBytes:(const GLubyte *)data width:(GLuint)w height:(GLuint)h {
  self = [super init];
  if (self) {
    glGenTextures(1, &_texName);
    [self bind];
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
  }
  return self;
}

- (void)bind {
  glBindTexture(GL_TEXTURE_2D, _texName);
}

- (void)unbind {
  glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)dealloc {
  glDeleteTextures(1, &_texName);
}
@end
