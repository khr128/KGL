//
//  KGLTransformation.h
//  GLfixed
//
//  Created by khr on 8/16/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGLModelingHierarchy.h"
#import "KGLRender.h"

@interface KGLObject : NSObject<KGLModelingHierarchy,KGLRender>

@property (strong) NSString *uuid;

- (void)translateByX:(float)x y:(float)y z:(float)z;
- (void)translationX:(float)x y:(float)y z:(float)z;
- (void)rotationX:(float)radiansX y:(float)radiansY z:(float)radiansZ;
@end
