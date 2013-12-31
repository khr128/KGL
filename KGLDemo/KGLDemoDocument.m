//
//  KGLDemoDocument.m
//  KGLDemo
//
//  Created by khr on 12/19/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDemoDocument.h"
#import <KControlPanels/Camera.h>
#import <KControlPanels/Point3d.h>

@implementation KGLDemoDocument

- (id)init
{
    self = [super init];
    if (self) {
    // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
  // Override returning the nib file name of the document
  // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
  return @"KGLDemoDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (id)managedObjectModel {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *demoModelPath =
  [mainBundle pathForResource:@"KGLDemoDocument" ofType:@"momd"];
  NSURL *demoModelUrl = [NSURL fileURLWithPath:demoModelPath];
  NSManagedObjectModel *mainModel =
  [[NSManagedObjectModel alloc] initWithContentsOfURL:demoModelUrl];
  
  NSBundle *kControlPanelBundle =
  [NSBundle bundleWithIdentifier:@"com.khr.KControlPanels"];
  NSString *path =
  [kControlPanelBundle pathForResource:@"KCameraUI" ofType:@"momd"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSManagedObjectModel *model =
  [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
  return
  [NSManagedObjectModel modelByMergingModels:
   [NSArray arrayWithObjects: mainModel, model, nil]];
}

- (Camera *)fetchOrCreateCamera {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Camera" inManagedObjectContext:self.managedObjectContext]];
  request.includesSubentities = YES;
  NSError *error = nil;
  NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  Camera *camera;
  if (results.count > 0) {
    camera = [results objectAtIndex:0];
  } else {
    camera = [NSEntityDescription insertNewObjectForEntityForName:@"Camera"
                                           inManagedObjectContext:self.managedObjectContext];
    camera.location = [Point3d initWith:self.managedObjectContext x:0 y:-5 z:-22.58];
    camera.lookAt = [Point3d initWith:self.managedObjectContext x:0 y:-5 z:-3];
    camera.up = [Point3d initWith:self.managedObjectContext x:0 y:1 z:0];
    camera.nearZ = [NSNumber numberWithFloat:0.1];
    camera.farZ = [NSNumber numberWithFloat:120.0];
    camera.angle = [NSNumber numberWithFloat:50.0];
    
    [camera addObservers];
  }
  return camera;
}
@end
