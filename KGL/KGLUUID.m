//
//  KGLUUID.m
//  KGL
//
//  Created by khr on 9/13/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLUUID.h"
#import "NSString+UUID.h"

@implementation KGLUUID

+ (NSString *)generate {
  return [NSString UUID];
}
@end
