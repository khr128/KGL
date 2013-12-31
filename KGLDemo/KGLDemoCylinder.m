//
//  KGLDemoCylinder.m
//  KGLDemo
//
//  Created by khr on 12/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDemoCylinder.h"
#import <KGL/KGLConeBuilder.h>
#import <KGL/KGLVector3.h>
#import <KGL/KGLUUID.h>
#import <KGL/KGLShaderAttribute.h>

@implementation KGLDemoCylinder

- (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2 {
  self = [super init];
  if (self) {
    KGLConeBuilder *coneBuilder = [[KGLConeBuilder alloc] initWithP1:p1
                                                                  r1:radius
                                                                  p2:p2
                                                                  r2:radius
                                                           closeEnd1:YES closeEnd2:YES];
    coneBuilder.tesselationLevel = ^{
      return (NSUInteger)0;
    };
    __weak typeof(self) self_ = self;
    self.customTemplate = ^{
      [self_ appearance];
      [self_ translationX:p1.x y:p1.y z:p1.z];
    };
    [self createIndexedDrawable:coneBuilder];
    self.uuid = [KGLUUID generate];
  }
  return self;
}

- (void)appearance {
  self.shaderAttributes = [[NSMutableDictionary alloc]
                           initWithObjectsAndKeys:
                           [[KGLShaderAttribute alloc] initWithComponentCount:3
                                                                         type:GL_FLOAT
                                                                   normalized:GL_FALSE
                                                                       stride:0
                                                                 bufferOffset:0],
                           @"inPosition",
                           [[KGLShaderAttribute alloc] initWithComponentCount:3
                                                                         type:GL_FLOAT
                                                                   normalized:GL_FALSE
                                                                       stride:0
                                                                 bufferOffset:[self.data vertexSize]],
                           @"normal",
                           nil];
  
  material = [[KGLMaterial alloc] initWithEmissive:GLKVector4Make(0.0, 0.0, 0.0, 1.0)
                                           ambient:GLKVector4Make(1.0, 1.0, 1.0, 1.0)
                                           diffuse:GLKVector4Make(1, 1, 1, 1.0)
                                          specular:GLKVector4Make(0.75, 0.75, 0.75, 1.0)
                                         shininess:12.0];
}

@end
