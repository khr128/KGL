//
//  RSVector3.m
//  RaySmart
//
//  Created by khr on 9/17/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLVector3.h"

@implementation KGLVector3

- (id)initWithX:(float)xi y:(float)yi z:(float)zi {
  self = [super init];
  if (self) {
    self.x = xi;
    self.y = yi;
    self.z = zi;
  }
  return self;
}

- (KGLVector3 *)add:(KGLVector3 *)v {
  return [[KGLVector3 alloc] initWithX:self.x+v.x y:self.y+v.y z:self.z+v.z];
}
- (KGLVector3 *)subtract:(KGLVector3 *)v {
  return [[KGLVector3 alloc] initWithX:self.x-v.x y:self.y-v.y z:self.z-v.z];
}

- (KGLVector3 *)divideByScalar:(float)c {
  return [[KGLVector3 alloc] initWithX:self.x/c y:self.y/c z:self.z/c];
}

- (KGLVector3 *)divideBy:(KGLVector3 *)v {
  return [[KGLVector3 alloc] initWithX:self.x/v.x y:self.y/v.y z:self.z/v.z];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"(%g, %g, %g)", self.x, self.y, self.z];
}

- (float)norm {
  return sqrtf([self dot:self]);
}

- (KGLVector3 *)normalize {
  return [self divideByScalar:[self norm]];
}

- (float)dot:(KGLVector3 *)v {
  return self.x*v.x + self.y*v.y + self.z*v.z;
}

- (GLfloat *)toFloats {
  static GLfloat array[3];
  array[0] = self.x;
  array[1] = self.y;
  array[2] = self.z;
  return array;
}
@end
