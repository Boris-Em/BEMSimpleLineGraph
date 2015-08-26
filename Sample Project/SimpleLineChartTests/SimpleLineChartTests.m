//
//  SimpleLineGraphTests.m
//  SimpleLineGraphTests
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

@import XCTest;
#import "BEMSimpleLineGraphView.h"

/// General, simple tests for BEMSimpleLineGraph
@interface SimpleLineGraphTests : XCTestCase <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (strong, nonatomic) BEMSimpleLineGraphView *lineGraph;

@end

const NSInteger numberOfPoints = 100;
const CGFloat pointValue = 3.0;
NSString * const xAxisLabelString = @"X-Axis-Label";

@implementation SimpleLineGraphTests

- (void)setUp {
    [super setUp];
    
    self.lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.lineGraph.delegate = self;
    self.lineGraph.dataSource = self;
}

#pragma mark BEMSimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView * __nonnull)graph {
    return numberOfPoints;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView * __nonnull)graph valueForPointAtIndex:(NSInteger)index {
    return pointValue;
}

- (NSString *)lineGraph:(nonnull BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return xAxisLabelString;
}

#pragma mark Test Methods
- (void)testInit {
    XCTAssertNotNil(self.lineGraph, @"An allocated and initialized BEMSimpleLineGraph should not be nil.");
}

- (void)testInitWithFrame {
    XCTAssertNotNil(self.lineGraph, @"An allocated and initialized BEMSimpleLineGraph should not be nil.");
}

- (void)testGraphValuesForXAxis {
    [self.lineGraph reloadGraph];
    
    NSArray *xAxisStrings = [self.lineGraph graphValuesForXAxis];
    XCTAssert(xAxisStrings.count == numberOfPoints, @"The number of strings on the X-Axis should be equal to the number returned by the data source method 'numberOfPointsInLineGraph:'");
    
    for (NSString *xAxisString in xAxisStrings) {
        XCTAssert([xAxisString isKindOfClass:[NSString class]], @"The array returned by 'graphValuesForXAxis' should only return NSStrings");
        XCTAssert([xAxisString isEqualToString:xAxisLabelString], @"The X-Axis strings should be the same as the one returned by the data source method 'labelOnXAxisForIndex:'");
    }
}

- (void)testGraphValuesForDataPoints {
    [self.lineGraph reloadGraph];
    
    NSArray *values = [self.lineGraph graphValuesForDataPoints];
    XCTAssert(values.count == numberOfPoints, @"The number of data points should be equal to the number returned by the data source method 'numberOfPointsInLineGraph:'");
    
    NSMutableArray *mockedValues = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfPoints; i++) {
        [mockedValues addObject:[NSNumber numberWithFloat:pointValue]];
    }
    XCTAssert([values isEqualToArray:mockedValues], @"The array returned by 'graphValuesForDataPoints' should be similar than the one returned by the data source method 'valueForPointAtIndex:'labelOnXAxisForIndex:");
}

- (void)testGraphLabelsForXAxis {
    [self.lineGraph reloadGraph];
    
    NSArray *labels = [self.lineGraph graphLabelsForXAxis];
    XCTAssert(labels.count == numberOfPoints, @"The number of X-Axis labels should be the same as the number of points on the graph");
    
    for (UILabel *XAxisLabel in labels) {
        XCTAssert([XAxisLabel isMemberOfClass:[UILabel class]], @"The array returned by 'graphLabelsForXAxis' should only return UILabels");
        XCTAssert([XAxisLabel.text isEqualToString:xAxisLabelString], @"The X-Axis label's strings should be the same as the one returned by the data source method 'labelOnXAxisForIndex:'");
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
