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


@interface KGLDrawable : KGLObject {
  KGLDrawableData *data;
  KGLMaterial *material;
}

@property (strong) NSDictionary *shaderAttributes;

@end
