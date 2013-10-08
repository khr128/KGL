//
//  KGLShaderAttribute.h
//  GLfixed
//
//  Created by khr on 8/5/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLShaderAttribute : NSObject
@property (readonly) GLint componentCount;
@property (readonly) GLenum type;
@property (readonly) GLboolean normalized;
@property (readonly) GLsizei stride;
@property (readonly) char * bufferOffset;

- (id)initWithComponentCount:(GLint)componentCount
              type:(GLenum)type
        normalized:(GLboolean)normalized
            stride:(GLsizei)stride
      bufferOffset:(GLuint)bufferOffset;

- (void)enableVertexArray:(GLuint)posAttribIndex;
@end
