//
//  RSTorusBuilderTests.m
//  RaySmart
//
//  Created by khr on 10/2/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KGLTorusBuilder.h"

@interface KGLTorusBuilderTests : XCTestCase {
  KGLTorusBuilder *builder;
}

@end

@implementation KGLTorusBuilderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  builder = [[KGLTorusBuilder alloc] initWithLargeRadius:1 andSmallRadius:0.5];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation
{
  XCTAssertNotNil(builder, @"Torus builder creation failed");
}

@end
