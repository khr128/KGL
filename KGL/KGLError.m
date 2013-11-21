//
//  KGLError.m
//  GLfixed
//
//  Created by khr on 8/5/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLError.h"
#import <GLKit/GLKit.h>

@interface KGLError(Private)
+(NSString *)errorString:(GLenum) error;
@end

@implementation KGLError
+(NSString *)errorString:(GLenum) error {
	NSString *str;
	switch( error )
	{
		case GL_NO_ERROR:
			str = @"GL_NO_ERROR";
			break;
		case GL_INVALID_ENUM:
			str = @"GL_INVALID_ENUM";
			break;
		case GL_INVALID_VALUE:
			str = @"GL_INVALID_VALUE";
			break;
		case GL_INVALID_OPERATION:
			str = @"GL_INVALID_OPERATION";
			break;
#if defined __gl_h_ || defined __gl3_h_
		case GL_OUT_OF_MEMORY:
			str = @"GL_OUT_OF_MEMORY";
			break;
		case GL_INVALID_FRAMEBUFFER_OPERATION:
			str = @"GL_INVALID_FRAMEBUFFER_OPERATION";
			break;
#endif
#if defined __gl_h_
		case GL_STACK_OVERFLOW:
			str = @"GL_STACK_OVERFLOW";
			break;
		case GL_STACK_UNDERFLOW:
			str = @"GL_STACK_UNDERFLOW";
			break;
		case GL_TABLE_TOO_LARGE:
			str = @"GL_TABLE_TOO_LARGE";
			break;
#endif
		default:
			str = @"(ERROR: Unknown Error Enum)";
			break;
	}
	return str;
}

+(void)log {
  GLenum err = glGetError();
  while (err != GL_NO_ERROR) {
    NSLog(@"GLError %@ set in File:%s Line:%d\n", [KGLError errorString:err], __FILE__, __LINE__);
    err = glGetError();
  }
}

@end
