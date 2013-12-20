//
//  KGLDemoControlPanelMediator.m
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDemoControlPanelMediator.h"

@implementation KGLDemoControlPanelMediator

- (IBAction)showCameraControlPanel:(id)sender {
  [self showPanel:sender nibName:@"KCameraUIControlPanel" context:nil];  
}

@end
