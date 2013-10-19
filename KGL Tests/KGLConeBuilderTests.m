//
//  RSConeBuilderTests.m
//  RaySmart
//
//  Created by khr on 10/4/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KGLConeBuilder.h"
#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"

@interface KGLConeBuilderTests : XCTestCase {
  KGLConeBuilder *builder;
}

@end

@implementation KGLConeBuilderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  KGLVector3 *p1 = [[KGLVector3 alloc] initWithX:0 y:0 z:0];
  float r1 = 1;
  KGLVector3 *p2 = [[KGLVector3 alloc] initWithX:0 y:-2 z:0];
  float r2 = 0.5;
  
  builder = [[KGLConeBuilder alloc] initWithP1:p1 r1:r1 p2:p2 r2:r2];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation
{
  XCTAssertNotNil(builder, @"Cone builder creation failed");
}

- (void)testAffineTransform {
  KGLVector3 *v = [[KGLVector3 alloc] initWithX:1 y:1 z:1];
  KGLVector3 *transformedV = [builder affineTransform:v];
  
  XCTAssertNotNil(transformedV, @"Transformed vertex is nil");
  XCTAssertEqual(transformedV.x, (float)1.0, @"incorrect transformed X");
  XCTAssertEqual(transformedV.y, (float)-2.0, @"incorrect transformed Y");
  XCTAssertEqual(transformedV.z, (float)1.0, @"incorrect transformed Z");
}

- (void)testInverseAffineTransform {
  KGLVector3 *v = [[KGLVector3 alloc] initWithX:1 y:-2 z:1];
  KGLVector3 *transformedV = [builder inverseAffineTransform:v];
  
  XCTAssertNotNil(transformedV, @"Transformed vertex is nil");
  XCTAssertEqual(transformedV.x, (float)1.0, @"incorrect transformed X");
  XCTAssertEqual(transformedV.y, (float)1.0, @"incorrect transformed Y");
  XCTAssertEqual(transformedV.z, (float)1.0, @"incorrect transformed Z");
}

- (void)testDegenerateAffineTransform {
  KGLVector3 *p1 = [[KGLVector3 alloc] initWithX:0 y:0 z:0];
  float r1 = 1;
  KGLVector3 *p2 = [[KGLVector3 alloc] initWithX:0 y:0 z:-2];
  float r2 = 0.5;
  
  builder = [[KGLConeBuilder alloc] initWithP1:p1 r1:r1 p2:p2 r2:r2];
  
  KGLVector3 *v = [[KGLVector3 alloc] initWithX:1 y:1 z:1];
  KGLVector3 *transformedV = [builder affineTransform:v];
  
  XCTAssertNotNil(transformedV, @"Transformed vertex is nil");
  XCTAssertEqual(transformedV.x, (float)1.0, @"incorrect transformed X");
  XCTAssertEqual(transformedV.y, (float)1.0, @"incorrect transformed Y");
  XCTAssertEqual(transformedV.z, (float)-2.0, @"incorrect transformed Z");
}

- (void)testDegenerateInverseAffineTransform {
  KGLVector3 *p1 = [[KGLVector3 alloc] initWithX:0 y:0 z:0];
  float r1 = 1;
  KGLVector3 *p2 = [[KGLVector3 alloc] initWithX:0 y:0 z:-2];
  float r2 = 0.5;
  
  builder = [[KGLConeBuilder alloc] initWithP1:p1 r1:r1 p2:p2 r2:r2];
  
  KGLVector3 *v = [[KGLVector3 alloc] initWithX:1 y:1 z:-2];
  KGLVector3 *transformedV = [builder inverseAffineTransform:v];
  
  XCTAssertNotNil(transformedV, @"Transformed vertex is nil");
  XCTAssertEqual(transformedV.x, (float)1.0, @"incorrect transformed X");
  XCTAssertEqual(transformedV.y, (float)1.0, @"incorrect transformed Y");
  XCTAssertEqual(transformedV.z, (float)1.0, @"incorrect transformed Z");
}

@end
