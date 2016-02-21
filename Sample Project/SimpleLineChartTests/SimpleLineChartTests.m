//
//  SimpleLineGraphTests.m
//  SimpleLineGraphTests
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

@import XCTest;
#import "BEMSimpleLineGraphView.h"
#import "contantsTests.h"

/// Same tags as in BEMSimpleLineGraphView.m
typedef NS_ENUM(NSInteger, BEMInternalTags)
{
    DotFirstTag100 = 100,
    DotLastTag1000 = 1000,
    LabelYAxisTag2000 = 2000,
    BackgroundYAxisTag2100 = 2100,
    BackgroundXAxisTag2200 = 2200,
    PermanentPopUpViewTag3100 = 3100,
};

/// General, simple tests for BEMSimpleLineGraph. Mostly testing default values.
@interface SimpleLineGraphTests : XCTestCase <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (strong, nonatomic) BEMSimpleLineGraphView *lineGraph;

@end


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

- (void)testReloadDataPerformance {
    [self measureBlock:^{
        [self.lineGraph reloadGraph];
    }];
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

- (void)testDrawnPoints {
    self.lineGraph.animationGraphEntranceTime = 0.0;
    [self.lineGraph reloadGraph];
    
    NSMutableArray *dots = [NSMutableArray new];
    for (UIView *dot in self.lineGraph.subviews) {
        if ([dot isKindOfClass:[BEMCircle class]] && dot.tag >= DotFirstTag100 && dot.tag <= DotLastTag1000) {
            [dots addObject:dot];
        }
    }
    XCTAssert(dots.count == numberOfPoints, @"There should be as many BEMCircle views in the graph's subviews as the data source method 'numberOfPointsInLineGraph:' returns");
    
    for (BEMCircle *dot in dots) {
        XCTAssert(dot.bounds.size.width == 10.0, @"Dots are expected to have a default width of 10.0");
        XCTAssert(dot.bounds.size.height == 10.0, @"Dots are expected to have a default height of 10.0");
        XCTAssert([dot.color isEqual:[UIColor colorWithWhite:1.0 alpha:0.7]], @"Dots are expected to be white at alpha 0.7 by default");
        XCTAssert(dot.absoluteValue == pointValue, @"Dots are expected to have a value equal to the value returned by the data source method 'valueForPointAtIndex:'");
        XCTAssert(dot.alpha == 0.0, @"Dots are expected to not be displayed by default (alpha of 0)");
        XCTAssert([dot.backgroundColor isEqual:[UIColor clearColor]], @"Dots are expected to have a clearColor background color by default");
    }
}

- (void)testGraphLabelsForXAxis {
    self.lineGraph.enableXAxisLabel = NO;
    [self.lineGraph reloadGraph];
    
    XCTAssert([self.lineGraph graphLabelsForXAxis].count == 0);
    
    self.lineGraph.enableXAxisLabel = YES;
    [self.lineGraph reloadGraph];
    
    NSArray *labels = [self.lineGraph graphLabelsForXAxis];
    XCTAssert(labels.count == numberOfPoints, @"The number of X-Axis labels should be the same as the number of points on the graph");
    
    for (UILabel *XAxisLabel in labels) {
        XCTAssert([XAxisLabel isMemberOfClass:[UILabel class]], @"The array returned by 'graphLabelsForXAxis' should only return UILabels");
        XCTAssert([XAxisLabel.text isEqualToString:xAxisLabelString], @"The X-Axis label's strings should be the same as the one returned by the data source method 'labelOnXAxisForIndex:'");
        XCTAssert([XAxisLabel.backgroundColor isEqual:[UIColor clearColor]], @"X-Axis labels are expected to have a clear beackground color by default");
        XCTAssert([XAxisLabel.textColor isEqual:[UIColor blackColor]], @"X-Axis labels are expected to have a black text color by default");
        XCTAssert(XAxisLabel.textAlignment == NSTextAlignmentCenter, @"X-Axis labels are expected to have their text centered by default");
        XCTAssert(XAxisLabel.tag == DotLastTag1000, @"X-Axis labels are expected to have a certain tag by default");
    }
}

- (void)testYAxisLabels {
    self.lineGraph.enableYAxisLabel = NO;
    [self.lineGraph reloadGraph];
    
    for (UILabel *label in self.lineGraph.subviews) {
        XCTAssert(label.tag != LabelYAxisTag2000, @"No Y-Axis labels are expected if enableYAxisLabel is set to NO");
    }
    
    self.lineGraph.enableYAxisLabel = YES;
    [self.lineGraph reloadGraph];
    
    NSString *value = [NSString stringWithFormat:@"%.f", pointValue];
    
    NSMutableArray *yAxisLabels = [NSMutableArray new];
    for (UILabel *label in self.lineGraph.subviews) {
        if ([label isKindOfClass:[UILabel class]] && label.tag == LabelYAxisTag2000) {
            [yAxisLabels addObject:label];
            XCTAssert([label.text isEqualToString:value], @"The value on the Y-Axis label is expected to be the value given by the data source method 'valueForPointAtIndex:'");
            XCTAssert([label.textColor isEqual:[UIColor blackColor]], @"The Y-Axis label is expected to have a text color of black by default");
            XCTAssert([label.backgroundColor isEqual:[UIColor clearColor]], @"The Y-Axis label is expected to have a backgrounf color of clear by default");
        }
    }
    
    XCTAssert(yAxisLabels.count == 1, @"With all the dots having the same value, we only expect one Y axis label");
}

- (void)tearDown {
    self.lineGraph = nil;
    [super tearDown];
}

@end
