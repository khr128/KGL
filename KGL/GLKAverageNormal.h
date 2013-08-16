//
//  GLKAccumulatedNormal.h
//  GLfixed
//
//  Created by khr on 8/8/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLKAverageNormal : NSObject {
  GLKVector3 sum;
  int count;
}

-(GLKVector3)normal;
-(void)add:(GLKVector3)n;
@end
