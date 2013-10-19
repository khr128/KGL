//
//  RSIndexedTriangle.m
//  RaySmart
//
//  Created by khr on 9/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLIndexedTriangle.h"
#import "KGLParameterizedVertex.h"

@implementation KGLIndexedTriangle
@synthesize computesNormals;

- (id)initWithI1:(GLuint)i1 i2:(GLuint)i2 i3:(GLuint)i3 andVertices:(NSMutableArray *)vertices {
  self = [super init];
  if (self) {
    self.i1 = i1;
    self.i2 = i2;
    self.i3 = i3;
    self.vertices = vertices;
  }
  return self;
}

- (NSArray *)tesselateWithLevel:(NSInteger)level {
  NSMutableArray *tesselation = [[NSMutableArray alloc] initWithCapacity:pow(6, level)];
  [tesselation addObject:self];
  for (int l = 0; l < level; ++l) {
    NSMutableArray *tempTesselation = [[NSMutableArray alloc] initWithArray:tesselation];
    [tesselation removeAllObjects];
    for (KGLIndexedTriangle *triangle in tempTesselation) {
      KGLParameterizedVertex *p1 = [self.vertices objectAtIndex:triangle.i1];
      KGLParameterizedVertex *p2 = [self.vertices objectAtIndex:triangle.i2];
      KGLParameterizedVertex *p3 = [self.vertices objectAtIndex:triangle.i3];
      
      KGLParameterizedVertex * center = [p1 midPointWith:p2 and:p3];
      KGLParameterizedVertex * mp1 = [p1 midPointWith:p2];
      KGLParameterizedVertex * mp2 = [p2 midPointWith:p3];
      KGLParameterizedVertex * mp3 = [p3 midPointWith:p1];
      
      [self.vertices addObject:center];
      GLuint centerIndex = (GLuint)self.vertices.count - 1;
      [self.vertices addObject:mp1];
      GLuint mp1Index = (GLuint)self.vertices.count - 1;
      [self.vertices addObject:mp2];
      GLuint mp2Index = (GLuint)self.vertices.count - 1;
      [self.vertices addObject:mp3];
      GLuint mp3Index = (GLuint)self.vertices.count -1;
      
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:triangle.i1 i2:mp1Index i3:centerIndex andVertices:self.vertices]];
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:mp1Index i2:triangle.i2 i3:centerIndex andVertices:self.vertices]];
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:triangle.i2 i2:mp2Index i3:centerIndex andVertices:self.vertices]];
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:mp2Index i2:triangle.i3 i3:centerIndex andVertices:self.vertices]];
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:triangle.i3 i2:mp3Index i3:centerIndex andVertices:self.vertices]];
      [tesselation addObject:[[KGLIndexedTriangle alloc] initWithI1:mp3Index i2:triangle.i1 i3:centerIndex andVertices:self.vertices]];
    }
  }
  return tesselation;
}

- (GLushort *)toIndices {
  static GLushort array[3];
  array[0] = self.i1;
  array[1] = self.i2;
  array[2] = self.i3;
  return array;
}


@end
