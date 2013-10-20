//
//  KGLDrawable.h
//  GLfixed
//
//  Created by khr on 8/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "KGLDrawableData.h"
#import "KGLMaterial.h"
#import "KGLObject.h"

@class KGLTexture;

@interface KGLDrawable : KGLObject {
  KGLMaterial *material;
}

@property (strong) NSDictionary *shaderAttributes;
@property (strong) KGLTexture *texture;
@property (strong) KGLDrawableData *data;

@end
