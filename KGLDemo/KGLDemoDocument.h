//
//  KGLDemoDocument.h
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Camera;
@interface KGLDemoDocument : NSPersistentDocument {
  IBOutlet NSObjectController *objectController;
}

-(Camera *) fetchOrCreateCamera;
@end
