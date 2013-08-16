//
//  KGLRender.h
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGLScene;

@protocol KGLRender <NSObject>

@property (weak) KGLScene *scene;

- (void)render;

@end
