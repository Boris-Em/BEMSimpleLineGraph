//
//  SimpleLineGraphTests.m
//  SimpleLineGraphTests
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

@import XCTest;
#import "BEMSimpleLineGraphView.h"

@interface SimpleLineGraphTests : XCTestCase

@end

@implementation SimpleLineGraphTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    BEMSimpleLineGraphView *lineGraph = [[BEMSimpleLineGraphView alloc] init];
    XCTAssertNotNil(lineGraph, @"An allocated and initialized BEMSimpleLineGraph should not be nil.");
}

- (void)testInitWithFrame {
    BEMSimpleLineGraphView *lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    XCTAssertNotNil(lineGraph, @"An allocated and initialized BEMSimpleLineGraph should not be nil.");
}

@end
