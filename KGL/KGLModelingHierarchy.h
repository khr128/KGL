//
//  KGLModelingHierarchy.h
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "KGLRender.h"

@protocol KGLModelingHierarchy <NSObject>
@property (assign) GLKMatrix4 modelMatrix;
@property (assign) GLKMatrix4 localModelMatrix;
@property (weak) id<KGLRender,KGLModelingHierarchy> parent;
@property (strong) NSMutableArray *children;

@optional
- (void)addChild:(id<KGLRender,KGLModelingHierarchy>)child;
- (void)addChild:(id<KGLRender,KGLModelingHierarchy>)child withUuid:(NSString *)uuid;
- (void)removeChildByUuid:(NSString *)uuid;
- (id<KGLRender,KGLModelingHierarchy>)findChild:(NSString *)uuid;

@end
