//
//  RSParameterizedVertexTests.m
//  RaySmart
//
//  Created by khr on 9/29/13.
//  Copyright (c) 2013 khr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KGLParameterizedVertex.h"
#import "KGLVector3.h"

#define PI 3.14159265359

@interface RSParameterizedVertexTests : XCTestCase {
  KGLVector3 * (^sphericalCartesianTransform)(KGLParameterizedVertex *);
  KGLVector3 * (^inverseSphericalCartesianTransform)(KGLVector3 *);
  KGLVector3 *center;
  float radius;
}

@end

@implementation RSParameterizedVertexTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  
  center = [[KGLVector3 alloc] initWithX:1 y:2 z:2];
  KGLVector3 * c = center;
  radius = 1;
  float r = radius;
  sphericalCartesianTransform = ^KGLVector3 *(KGLParameterizedVertex *v) {
    return [[KGLVector3 alloc] initWithX:c.x + v.p1*sinf(v.p2)*cosf(v.p3)
                                      y:c.y + v.p1*sinf(v.p2)*sinf(v.p3)
                                      z:c.z + v.p1*cosf(v.p2)];
  };
  inverseSphericalCartesianTransform = ^KGLVector3 *(KGLVector3 *v) {
    float phi = atan2f(v.y-c.y, v.x-c.x);
    return [[KGLVector3 alloc] initWithX:r
                                      y:acosf((v.z-c.z)/[[v subtract:c] norm])
                                      z:phi>0 ? phi : phi + 2*PI];
  };
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMidPointAtPhiPeriod
{
  KGLParameterizedVertex *smallPhiVertex = [[KGLParameterizedVertex alloc] initWithP1:radius p2:1 p3:0.01
                                                                   cartesianTransform:sphericalCartesianTransform
                                                            inverseCartesianTransform:inverseSphericalCartesianTransform];
  KGLParameterizedVertex *nearPeriodVertex = [[KGLParameterizedVertex alloc] initWithP1:radius p2:1 p3:2*PI-0.03
                                                                  cartesianTransform:sphericalCartesianTransform
                                                            inverseCartesianTransform:inverseSphericalCartesianTransform];
  
  KGLParameterizedVertex *midPointVertex = [nearPeriodVertex midPointWith:smallPhiVertex];
  
  XCTAssertEqualWithAccuracy(midPointVertex.p1, smallPhiVertex.p1, 1.0e-6);
  XCTAssertEqualWithAccuracy(midPointVertex.p1, nearPeriodVertex.p1, 1.0e-6);
  
  XCTAssertEqualWithAccuracy(midPointVertex.p2, smallPhiVertex.p2, 1.0e-4);
  XCTAssertEqualWithAccuracy(midPointVertex.p2, nearPeriodVertex.p2, 1.0e-4);
  

  XCTAssertEqualWithAccuracy(midPointVertex.p3, 0.5*(smallPhiVertex.p3 + nearPeriodVertex.p3) + PI, 1.5e-5);
  
}

@end
