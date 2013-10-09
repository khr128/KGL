//
//  KGLTexture.h
//  KGL
//
//  Created by khr on 10/8/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLTexture : NSObject
@property (assign) GLuint texName;

- (id)initWithBytes:(const GLubyte *)data width:(GLuint)w height:(GLuint)h;
- (void)bind;
- (void)unbind;
@end
