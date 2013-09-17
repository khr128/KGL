//
//  KGLLights.h
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGLShader.h"
#import "KGLCamera.h"

@class KGLLight;

@interface KGLLights : NSObject {
  NSMutableArray *lights;
}

- (void)loadUniformsInto:(KGLShader *)shader;
- (void)computeEyeCoordsWith:(KGLCamera *)camera;

- (void)addDirectionalLightAt:(GLKVector4)position
                      ambient:(GLKVector4)ambient
                      diffuse:(GLKVector4)diffuse
                     specular:(GLKVector4)specular;
- (KGLLight *)addPointLightWithUuid:(NSString *)uuid
                                 at:(GLKVector4)position
                        attenuation:(GLKVector3)attenuation
                            ambient:(GLKVector4)ambient
                            diffuse:(GLKVector4)diffuse
                           specular:(GLKVector4)specular;
- (KGLLight *)addPointLightAt:(GLKVector4)position
                  attenuation:(GLKVector3)attenuation
                      ambient:(GLKVector4)ambient
                      diffuse:(GLKVector4)diffuse
                     specular:(GLKVector4)specular;
- (KGLLight *)addSpotLightWithUuid:(NSString *)uuid
                                at:(GLKVector4)position
                       attenuation:(GLKVector3)attenuation
                     spotDirection:(GLKVector3)spotDirection
                 spotRadiusDegrees:(float)spotRadius
                 spotCutoffDegrees:(float)spotCutoff
                     spotTightness:(float)spotTightness
                           ambient:(GLKVector4)ambient
                           diffuse:(GLKVector4)diffuse
                          specular:(GLKVector4)specular;
- (KGLLight *)addSpotLightAt:(GLKVector4)position
               attenuation:(GLKVector3)attenuation
             spotDirection:(GLKVector3)spotDirection
         spotRadiusDegrees:(float)spotRadius
         spotCutoffDegrees:(float)spotCutoff
              spotTightness:(float)spotTightness
                   ambient:(GLKVector4)ambient diffuse:(GLKVector4)diffuse specular:(GLKVector4)specular;

- (KGLLight *)findLight:(NSString *)light;
@end
