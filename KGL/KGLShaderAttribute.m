//
//  KGLShaderAttribute.m
//  GLfixed
//
//  Created by khr on 8/5/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLShaderAttribute.h"

@implementation KGLShaderAttribute
@synthesize  componentCount = _componentCount;
@synthesize  type = _type;
@synthesize normalized = _normalized;
@synthesize stride = _stride;
@synthesize bufferOffset = _bufferOffset;

- (id)initWithComponentCount:(GLint)componentCount
              type:(GLenum)type
        normalized:(GLboolean)normalized
            stride:(GLsizei)stride
      bufferOffset:(GLuint)bufferOffset
{
  self = [super init];
  if (self) {
    _componentCount = componentCount;
    _type = type;
    _normalized = normalized;
    _stride = stride;
    _bufferOffset = bufferOffset;
  }
  return self;
}
@end