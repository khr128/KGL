//
//  KGLLights.m
//  GLfixed
//
//  Created by khr on 8/12/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLLights.h"
#import "KGLLight.h"
#import "KGLCamera.h"

#define KGL_PI 3.1415926535897932384626433832795

@implementation KGLLights

- (id)init {
  self = [super init];
  if (self) {
    lights = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadUniformsInto:(KGLShader *)shader {
  glUniform1i(glGetUniformLocation(shader.program, "NumEnabledLights"), (GLint)[lights count]);
  
  int i = 0;
  for (KGLLight *light in lights) {
    [light loadUniformsForLight:i into:shader];
    ++i;
  }
}

- (void)computeEyeCoordsWith:(KGLCamera *)camera {
  for (KGLLight *light in lights) {
    if (light.worldPosition.w == 0) { //directional light
      
      light.eyePosition = [camera worldVecToEye:light.worldPosition];
      light.worldHalfVector = GLKVector4MultiplyScalar(
          GLKVector4Subtract(light.worldPosition, GLKVector4MakeWithVector3(camera.viewDir, 0)), 0.5);
      light.eyeHalfVector = [camera worldVecToEye:light.worldHalfVector];
      
    } else if (light.spotRadius == 180) { //point light
      
      light.eyePosition = [camera worldPosToEye:light.worldPosition];
      
    } else { //spot light
      
      light.eyePosition = [camera worldPosToEye:light.worldPosition];
      light.eyeSpotDirection = [camera worldVec3ToEye3:light.worldSpotDirection];
      
    }
  }
}

- (void)addDirectionalLightAt:(GLKVector4)position
                      ambient:(GLKVector4)ambient
                      diffuse:(GLKVector4)diffuse
                     specular:(GLKVector4)specular
{
  KGLLight *light;
  light = [[KGLLight alloc] init];
  position.w = 0;
  
  light.worldPosition = position;
  light.ambient = ambient;
  light.diffuse = diffuse;
  light.specular = specular;
    
  [lights addObject:light];
}

- (KGLLight *)addPointLightWithUuid:(NSString *)uuid
                                 at:(GLKVector4)position
                        attenuation:(GLKVector3)attenuation
                            ambient:(GLKVector4)ambient
                            diffuse:(GLKVector4)diffuse
                           specular:(GLKVector4)specular
{
  KGLLight *light;
  light = [self findLight:uuid];

  if (light == nil) {
    light = [self addPointLightAt:position attenuation:attenuation ambient:ambient diffuse:diffuse specular:specular];
  }
  
  light.uuid = uuid;
  return light;
}

- (KGLLight *)addPointLightAt:(GLKVector4)position
                  attenuation:(GLKVector3)attenuation
                      ambient:(GLKVector4)ambient
                      diffuse:(GLKVector4)diffuse
                     specular:(GLKVector4)specular
  {
  KGLLight *light;
  light = [[KGLLight alloc] init];
  position.w = 1;

  light.worldPosition = position;
  light.attenuation = attenuation;
  
  light.ambient = ambient;
  light.diffuse = diffuse;
  light.specular = specular;
  
  light.spotRadius = 180;
  
  [lights addObject:light];
  return light;
}

- (KGLLight *)addSpotLightWithUuid:(NSString *)uuid
                            at:(GLKVector4)position
                   attenuation:(GLKVector3)attenuation
                 spotDirection:(GLKVector3)spotDirection
             spotRadiusDegrees:(float)spotRadius
             spotCutoffDegrees:(float)spotCutoff
                  spotTightness:(float)spotTightness
                       ambient:(GLKVector4)ambient
                       diffuse:(GLKVector4)diffuse
                      specular:(GLKVector4)specular
{
  KGLLight *light;
  light = [self findLight:uuid];
  
  if (light == nil) {
    light = [self addSpotLightAt:position
                     attenuation:attenuation
                   spotDirection:spotDirection
               spotRadiusDegrees:spotRadius
               spotCutoffDegrees:spotCutoff
                   spotTightness:spotTightness
                         ambient:ambient
                         diffuse:diffuse
                        specular:specular];
  }
  
  light.uuid = uuid;
  return light;
}
  
- (KGLLight *)addSpotLightAt:(GLKVector4)position
                 attenuation:(GLKVector3)attenuation
               spotDirection:(GLKVector3)spotDirection
           spotRadiusDegrees:(float)spotRadius
           spotCutoffDegrees:(float)spotCutoff
                spotTightness:(float)spotTightness
                     ambient:(GLKVector4)ambient
                     diffuse:(GLKVector4)diffuse
                    specular:(GLKVector4)specular
  {
  KGLLight *light;
  light = [[KGLLight alloc] init];
  position.w = 1;
  
  light.worldPosition = position;
  light.attenuation = attenuation;
  
  light.ambient = ambient;
  light.diffuse = diffuse;
  light.specular = specular;
  
  light.worldSpotDirection = spotDirection;
  light.spotRadius = spotRadius;
  light.spotCosCutoff = cos(GLKMathDegreesToRadians(spotCutoff));
  light.spotTightness = spotTightness;
  
  [lights addObject:light];
  return light;
}

- (KGLLight *)findLight:(NSString *)uuid {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
  NSArray *found = [lights filteredArrayUsingPredicate:predicate];
  return found.count > 0 ? [found objectAtIndex:0] : nil;
}

@end
