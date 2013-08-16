//
//  KGLShader.h
//  GLfixed
//
//  Created by khr on 8/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface KGLShader : NSObject

@property (readonly) GLuint program;
@property (strong) NSString *vertexShaderFile;
@property (strong) NSString *fragmentShaderFile;
@property (strong) NSArray *attributes;
@property (strong) NSArray *uniforms;

- (void)build;
@end
