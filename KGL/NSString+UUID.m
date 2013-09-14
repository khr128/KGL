//
//  NSString+UUID.m
//  RaySmart
//
//  Created by khr on 9/7/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
+(NSString*)UUID {
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef string = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  return (__bridge NSString *)string;
}
@end
