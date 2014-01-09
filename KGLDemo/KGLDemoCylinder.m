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
#import <KGL/KGLTexture.h>

@implementation KGLDemoCylinder

- (KGLConeBuilder *)createBuilder:(float)radius p2:(KGLVector3 *)p2 p1:(KGLVector3 *)p1 {
  KGLConeBuilder *coneBuilder = [[KGLConeBuilder alloc] initWithP1:p1
                                                                r1:radius
                                                                p2:p2
                                                                r2:radius
                                                         closeEnd1:YES closeEnd2:YES];
  coneBuilder.tesselationLevel = ^{
    return (NSUInteger)0;
  };
  return coneBuilder;
}

- (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2 {
  self = [super init];
  if (self) {
    KGLConeBuilder *coneBuilder = [self createBuilder:radius p2:p2 p1:p1];
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

- (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2 andTexture:(NSString *)textureImage {
  self = [super init];
  if (self) {
    KGLConeBuilder *coneBuilder = [self createBuilder:radius p2:p2 p1:p1];
    __weak typeof(self) self_ = self;
    self.customTemplate = ^{
      [self_ loadTextureCoordinatesFromIndexed:coneBuilder];
      [self_ appearanceWithTexture:textureImage];
      [self_ translationX:p1.x y:p1.y z:p1.z];
    };
    [self createIndexedDrawable:coneBuilder];
    self.uuid = [KGLUUID generate];
  }
  return self;
}

- (void)setShaderAttributes {
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
}

- (void)appearance {
  [self setShaderAttributes];
  
  material = [[KGLMaterial alloc] initWithEmissive:GLKVector4Make(0.0, 0.0, 0.0, 1.0)
                                           ambient:GLKVector4Make(1.0, 0.0, 0.0, 1.0)
                                           diffuse:GLKVector4Make(1, 0, 0, 1.0)
                                          specular:GLKVector4Make(0.75, 0.75, 0.75, 1.0)
                                         shininess:12.0];
}

- (void)appearanceWithTexture:(NSString *)textureImage {
  [self setShaderAttributes];
  
  NSImage *image = [NSImage imageNamed:textureImage];
  CGImageRef imageRef = [image CGImageForProposedRect:nil context:nil hints:nil];
  CFDataRef imageDataRef = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
  const UInt8 *pImageData = CFDataGetBytePtr(imageDataRef);
  
  self.texture = [[KGLTexture alloc] initWithBytes:pImageData
                                             width:CGImageGetWidth(imageRef)
                                            height:CGImageGetHeight(imageRef)];
  
  [(NSMutableDictionary *)self.shaderAttributes setObject:[[KGLShaderAttribute alloc] initWithComponentCount:2
                                                                                                        type:GL_FLOAT
                                                                                                  normalized:GL_FALSE
                                                                                                      stride:0
                                                                                                bufferOffset:2*[self.data vertexSize]]
                                                   forKey:@"texCoords"];
  
  material = [[KGLMaterial alloc] initWithEmissive:GLKVector4Make(0.0, 0.0, 0.0, 1.0)
                                           ambient:GLKVector4Make(1.0, 1.0, 1.0, 1.0)
                                           diffuse:GLKVector4Make(1, 1, 1, 1.0)
                                          specular:GLKVector4Make(0.75, 0.75, 0.75, 1.0)
                                         shininess:12.0];
 }

@end
