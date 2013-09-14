//
//  KGLReferenceFrame.m
//  GLfixed
//
//  Created by khr on 8/15/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLReferenceFrame.h"

@implementation KGLReferenceFrame
- (void)render {
  self.modelMatrix = GLKMatrix4Multiply(self.parent.modelMatrix, self.localModelMatrix);
  [super render];
}

- (void) addChild:(id<KGLRender,KGLModelingHierarchy>)child {
  child.scene = self.scene;
  child.parent = self;
  [self.children addObject:child];
}

- (id<KGLRender,KGLModelingHierarchy>)findChild:(NSString *)uuid {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
  NSArray *found = [self.children filteredArrayUsingPredicate:predicate];
  return found.count > 0 ? [found objectAtIndex:0] : nil;
}

- (void)addChild:(id<KGLRender,KGLModelingHierarchy>)child withUuid:(NSString *)uuid {
  id<KGLRender,KGLModelingHierarchy> existingChild = [self findChild:uuid];
  if (existingChild == nil) {
    [self addChild:child];
  }
}

- (void)removeChildByUuid:(NSString *)uuid {
  id<KGLRender,KGLModelingHierarchy> child = [self findChild:uuid];
  if (child) {
    [self.children removeObject:child];
  }
}
@end
