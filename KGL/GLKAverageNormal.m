//
//  GLKAccumulatedNormal.m
//  GLfixed
//
//  Created by khr on 8/8/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "GLKAverageNormal.h"

@implementation GLKAverageNormal

- (id)init {
  self = [super init];
  if (self) {
    sum = GLKVector3Make(0, 0, 0);
    count = 0;
  }
  return self;
}

-(GLKVector3)normal {
  return count == 0 ? GLKVector3Make(0, 0, 1) : GLKVector3DivideScalar(sum, count);
}

-(void)add:(GLKVector3)n {
  sum = GLKVector3Add(sum, n);
  ++count;
}


@end
