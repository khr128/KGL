//
//  KGL.m
//  KGL
//
//  Created by khr on 10/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGL.h"
#import <GLKit/GLKit.h>

@implementation KGL

+ (void)logVersionsAndCapabilities {
  const char *verstr = (const char *) glGetString(GL_VERSION);
  NSLog(@"OpenGL version: %s", verstr);
  
  const char *verstrSL = (const char *) glGetString(GL_SHADING_LANGUAGE_VERSION);
  NSLog(@"Shading language version: %s", verstrSL);
  
  GLint maxTextureSize;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  NSLog(@"Max texture size: %d", maxTextureSize);
}

@end
