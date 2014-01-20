//
//  Rotation.m
//  KGLDemo
//
//  Created by khr on 1/14/14.
//  Copyright (c) 2014 khr. All rights reserved.
//

#import "Rotation.h"

NSString * const KGL_DEMO_DISPLAY_UPDATE_NOTIFICATION = @"kglDemoDisplayUpdateNotification";

@implementation Rotation

@dynamic mainFrameAngle;
@dynamic nestedFrameAngle;

- (void)addObservers {
  [self addObserver:self forKeyPath:@"mainFrameAngle" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"nestedFrameAngle" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:KGL_DEMO_DISPLAY_UPDATE_NOTIFICATION object:self];
}
@end
