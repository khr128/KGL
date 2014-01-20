//
//  Rotation.h
//  KGLDemo
//
//  Created by khr on 1/14/14.
//  Copyright (c) 2014 khr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const KGL_DEMO_DISPLAY_UPDATE_NOTIFICATION;

@interface Rotation : NSManagedObject

@property (nonatomic, retain) NSNumber * mainFrameAngle;
@property (nonatomic, retain) NSNumber * nestedFrameAngle;

- (void)addObservers;
@end
