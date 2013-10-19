//
//  RSTriangle.m
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLTriangle.h"
#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"

@implementation KGLTriangle
@synthesize computesNormals;

- (id)initWithP1:(KGLParameterizedVertex *)pt1 p2:(KGLParameterizedVertex *)pt2 p3:(KGLParameterizedVertex *)pt3 {
  self = [super init];
  if (self) {
    self.p1 = pt1;
    self.p2 = pt2;
    self.p3 = pt3;
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"p1 %@\np2 %@\np3 %@\n", self.p1, self.p2, self.p3];
}

#pragma mark RSTesselate protocol implementation

- (NSArray *)tesselateWithLevel:(NSInteger)level {
  NSMutableArray *tesselation = [[NSMutableArray alloc] initWithCapacity:pow(6, level)];
  [tesselation addObject:self];
  for (int l = 0; l < level; ++l) {
    NSMutableArray *tempTesselation = [[NSMutableArray alloc] initWithArray:tesselation];
    [tesselation removeAllObjects];
    for (KGLTriangle *triangle in tempTesselation) {
      KGLParameterizedVertex * center = [triangle.p1 midPointWith:triangle.p2 and:triangle.p3];
      KGLParameterizedVertex * mp1 = [triangle.p1 midPointWith:triangle.p2];
      KGLParameterizedVertex * mp2 = [triangle.p2 midPointWith:triangle.p3];
      KGLParameterizedVertex * mp3 = [triangle.p3 midPointWith:triangle.p1];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:triangle.p1 p2:mp1 p3:center]];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:mp1 p2:triangle.p2 p3:center]];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:triangle.p2 p2:mp2 p3:center]];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:mp2 p2:triangle.p3 p3:center]];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:triangle.p3 p2:mp3 p3:center]];
      [tesselation addObject:[[KGLTriangle alloc] initWithP1:mp3 p2:triangle.p1 p3:center]];
    }
  }
  return tesselation;
}

- (GLfloat *)toFloats {
  static GLfloat array[9];
  KGLVector3 *p1 = [self.p1 vector3];
  KGLVector3 *p2 = [self.p2 vector3];
  KGLVector3 *p3 = [self.p3 vector3];
  array[0] = p1.x;
  array[1] = p1.y;
  array[2] = p1.z;
  array[3] = p2.x;
  array[4] = p2.y;
  array[5] = p2.z;
  array[6] = p3.x;
  array[7] = p3.y;
  array[8] = p3.z;
  return array;
}

- (GLfloat *)toTexCoords {
  static GLfloat array[6];
  array[0] = self.p1.s;
  array[1] = self.p1.t;
  array[2] = self.p2.s;
  array[3] = self.p2.t;
  array[4] = self.p3.s;
  array[5] = self.p3.t;
  return array;
}
@end
