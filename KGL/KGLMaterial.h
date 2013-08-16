//
//  KGLMaterial.h
//  GLfixed
//
//  Created by khr on 8/6/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "KGLShader.h"


@interface KGLMaterial : NSObject {
  GLKVector4 emissive;
  GLKVector4 ambient;
  GLKVector4 diffuse;
  GLKVector4 specular;
  GLfloat shininess;
}

- (id)initWithEmissive:(GLKVector4)emissive_i
               ambient:(GLKVector4)ambient_i
               diffuse:(GLKVector4)diffuse_i
              specular:(GLKVector4)specular_i
             shininess:(GLfloat)shininess_i;

- (void)loadUniformsInto:(KGLShader *)shader;
@end
