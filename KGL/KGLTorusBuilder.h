//
//  RSTorusBuilder.h
//  RaySmart
//
//  Created by khr on 10/1/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLIndexedObjectBuilder.h"

@interface KGLTorusBuilder : KGLIndexedObjectBuilder

- (id)initWithLargeRadius:(float)R andSmallRadius:(float)r;
@end
