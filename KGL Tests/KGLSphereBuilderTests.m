//
//  RSSphereBuilderTests.m
//  RaySmart
//
//  Created by khr on 9/27/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KGLSphereBuilder.h"

@interface KGLSphereBuilderTests : XCTestCase {
  KGLSphereBuilder *builder;
}

@end

@implementation KGLSphereBuilderTests

- (void)setUp
{
    [super setUp];
  builder = [[KGLSphereBuilder alloc] initWithRadius:1];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation
{
  XCTAssertNotNil(builder, @"Sphere builder creation failed");
}

@end
