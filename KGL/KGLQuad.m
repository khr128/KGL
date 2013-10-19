//
//  RSQuad.m
//  RaySmart
//
//  Created by khr on 9/18/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLQuad.h"
#import "KGLVector3.h"
#import "KGLTriangle.h"
#import "KGLParameterizedVertex.h"

@implementation KGLQuad
@synthesize computesNormals;

- (id)initWithP1:(KGLParameterizedVertex *)pt1
              p2:(KGLParameterizedVertex *)pt2
              p3:(KGLParameterizedVertex *)pt3
              p4:(KGLParameterizedVertex *)pt4 {
  self = [super init];
  if (self) {
    self.p1 = pt1;
    self.p2 = pt2;
    self.p3 = pt3;
    self.p4 = pt4;
  }
  return self;
}

- (KGLParameterizedVertex *)center {
  return [[self.p1 midPointWith:self.p2] midPointWith:[self.p3 midPointWith:self.p4]];
}

- (NSArray *)quarter {
  KGLParameterizedVertex *c = [self center];
  KGLParameterizedVertex *mp1 = [self.p1 midPointWith:self.p2];
  KGLParameterizedVertex *mp2 = [self.p2 midPointWith:self.p3];
  KGLParameterizedVertex *mp3 = [self.p3 midPointWith:self.p4];
  KGLParameterizedVertex *mp4 = [self.p4 midPointWith:self.p1];
  return [NSArray arrayWithObjects:
          [[KGLQuad alloc] initWithP1:self.p1 p2:mp1 p3:c p4:mp4],
          [[KGLQuad alloc] initWithP1:mp1 p2:self.p2 p3:mp2 p4:c],
          [[KGLQuad alloc] initWithP1:c p2:mp2 p3:self.p3 p4:mp3],
          [[KGLQuad alloc] initWithP1:mp4 p2:c p3:mp3 p4:self.p4],
          nil];
}

- (NSArray *)tesselate{
  KGLParameterizedVertex *c = [self center];
  return [NSArray arrayWithObjects:
          [[KGLTriangle alloc] initWithP1:self.p1 p2:self.p2 p3:c],
          [[KGLTriangle alloc] initWithP1:self.p2 p2:self.p3 p3:c],
          [[KGLTriangle alloc] initWithP1:self.p3 p2:self.p4 p3:c],
          [[KGLTriangle alloc] initWithP1:self.p4 p2:self.p1 p3:c],
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
