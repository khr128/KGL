//
//  KGLDemoCylinder.h
//  KGLDemo
//
//  Created by khr on 12/25/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <KGL/KGLBuiltObject.h>

@class KGLVector3;
@interface KGLDemoCylinder : KGLBuiltObject
- (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2;
- (id)initWithRadius:(float)radius p1:(KGLVector3 *)p1 p2:(KGLVector3 *)p2 andTexture:(NSString *)textureImage;
@end
