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
      
    } else if (light.spotCutoff == 180) { //point light
      
      light.eyePosition = [camera worldPosToEye:light.worldPosition];
      
    } else { //spot light
      
      light.eyePosition = [camera worldPosToEye:light.worldPosition];
      light.eyeSpotDirection = [camera worldVec3ToEye3:light.worldSpotDirection];
      
    }
  }
}

- (void)addDirectionalLightAt:(GLKVector4)position
                      ambient:(GLKVector4)ambient diffuse:(GLKVector4)diffuse specular:(GLKVector4)specular
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

- (void)addPointLightAt:(GLKVector4)position attenuation:(GLKVector3)attenuation
                ambient:(GLKVector4)ambient diffuse:(GLKVector4)diffuse specular:(GLKVector4)specular
{
  KGLLight *light;
  light = [[KGLLight alloc] init];
  position.w = 1;

  light.worldPosition = position;
  light.constantAttenuation = attenuation.x;
  light.linearAttenuation = attenuation.y;
  light.quadraticAttenuation = attenuation.z;
  
  light.ambient = ambient;
  light.diffuse = diffuse;
  light.specular = specular;
  
  light.spotCutoff = 180;
  
  [lights addObject:light];
}

- (void)addSpotLightAt:(GLKVector4)position attenuation:(GLKVector3)attenuation
         spotDirection:(GLKVector3)spotDirection
     spotCutoffDegrees:(float)spotCutoff
          spotExponent:(float)spotExponent
               ambient:(GLKVector4)ambient diffuse:(GLKVector4)diffuse specular:(GLKVector4)specular
{
  KGLLight *light;
  light = [[KGLLight alloc] init];
  position.w = 1;
  
  light.worldPosition = position;
  light.constantAttenuation = attenuation.x;
  light.linearAttenuation = attenuation.y;
  light.quadraticAttenuation = attenuation.z;
  
  light.ambient = ambient;
  light.diffuse = diffuse;
  light.specular = specular;
  
  light.worldSpotDirection = spotDirection;
  light.spotCutoff = spotCutoff;
  light.spotCosCutoff = cos(GLKMathDegreesToRadians(spotCutoff));
  light.spotExponent = spotExponent;
  
  [lights addObject:light];  
}


@end
