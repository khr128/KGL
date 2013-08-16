//
//  KGLDrawableDataIndexed.h
//  GLfixed
//
//  Created by khr on 8/9/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import "KGLDrawableData.h"

@interface KGLDrawableDataIndexed : KGLDrawableData{
  GLushort *indices;
  GLuint indexSize;
}

- (void)loadIndices:(const GLushort *)array size:(GLuint)size;

@end
