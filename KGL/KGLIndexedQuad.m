//
//  RSIndexedQuad.m
//  RaySmart
//
//  Created by khr on 9/26/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLIndexedQuad.h"
#import "KGLParameterizedVertex.h"
#import "KGLIndexedTriangle.h"

@implementation KGLIndexedQuad
@synthesize computesNormals;

- (id)initWithI1:(GLuint)i1 i2:(GLuint)i2 i3:(GLuint)i3 i4:(GLuint)i4 andVertices:(NSMutableArray *)vertices {
  self = [super init];
  if (self) {
    self.i1 = i1;
    self.i2 = i2;
    self.i3 = i3;
    self.i4 = i4;
    self.vertices = vertices;
  }
  return self;
}

- (GLuint)centerIndex {
  KGLParameterizedVertex *p1 = [self.vertices objectAtIndex:self.i1];
  KGLParameterizedVertex *p2 = [self.vertices objectAtIndex:self.i2];
  KGLParameterizedVertex *p3 = [self.vertices objectAtIndex:self.i3];
  KGLParameterizedVertex *p4 = [self.vertices objectAtIndex:self.i4];
  
  [self.vertices addObject:[[p1 midPointWith:p2] midPointWith:[p3 midPointWith:p4]]];
  return (GLuint)self.vertices.count - 1;
}

- (NSArray *)tesselate{
  GLuint ci = [self centerIndex];
  return [NSArray arrayWithObjects:
          [[KGLIndexedTriangle alloc] initWithI1:self.i1 i2:self.i2 i3:ci andVertices:self.vertices],
          [[KGLIndexedTriangle alloc] initWithI1:self.i2 i2:self.i3 i3:ci andVertices:self.vertices],
          [[KGLIndexedTriangle alloc] initWithI1:self.i3 i2:self.i4 i3:ci andVertices:self.vertices],
          [[KGLIndexedTriangle alloc] initWithI1:self.i4 i2:self.i1 i3:ci andVertices:self.vertices],
          nil];
}

- (NSArray *)quarter {
  GLuint ci = [self centerIndex];
  
  KGLParameterizedVertex *p1 = [self.vertices objectAtIndex:self.i1];
  KGLParameterizedVertex *p2 = [self.vertices objectAtIndex:self.i2];
  KGLParameterizedVertex *p3 = [self.vertices objectAtIndex:self.i3];
  KGLParameterizedVertex *p4 = [self.vertices objectAtIndex:self.i4];
  
  [self.vertices addObject:[p1 midPointWith:p2]];
  GLuint mi1 = (GLuint)self.vertices.count - 1;
  [self.vertices addObject:[p2 midPointWith:p3]];
  GLuint mi2 = (GLuint)self.vertices.count - 1;
  [self.vertices addObject:[p3 midPointWith:p4]];
  GLuint mi3 = (GLuint)self.vertices.count - 1;
  [self.vertices addObject:[p4 midPointWith:p1]];
  GLuint mi4 = (GLuint)self.vertices.count - 1;
  
  return [NSArray arrayWithObjects:
          [[KGLIndexedQuad alloc] initWithI1:self.i1 i2:mi1 i3:ci i4:mi4 andVertices:self.vertices],
          [[KGLIndexedQuad alloc] initWithI1:mi1 i2:self.i2 i3:mi2 i4:ci andVertices:self.vertices],
          [[KGLIndexedQuad alloc] initWithI1:ci i2:mi2 i3:self.i3 i4:mi3 andVertices:self.vertices],
          [[KGLIndexedQuad alloc] initWithI1:mi4 i2:ci i3:mi3 i4:self.i4 andVertices:self.vertices],
          nil];
}

#pragma mark RSTesselate protocol implementation

- (NSArray *)tesselateWithLevel:(NSInteger)level {
  NSMutableArray *tesselation = [[NSMutableArray alloc] initWithCapacity:pow(4, level+1)];
  
  if (level == 0) {
    [tesselation addObjectsFromArray:[self tesselate]];
  } else {
    NSArray *quads = [self quarter];
    for (id<KGLTesselate> element in quads) {
      [tesselation addObjectsFromArray:[element tesselateWithLevel:level - 1]];
    }
  }
  return tesselation;
}

@end
