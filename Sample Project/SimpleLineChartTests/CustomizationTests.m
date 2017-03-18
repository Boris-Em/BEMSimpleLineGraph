//
//  CustomizationTests.m
//  SimpleLineChart
//
//  Created by Bobo on 8/26/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import XCTest;
#import "BEMSimpleLineGraphView.h"
#import "contantsTests.h"
#pragma clang diagnostic ignored "-Wfloat-equal"

@interface BEMSimpleLineGraphView ()
//Allow tester to get to internal properties

/// All of the dataPoint labels
@property (strong, nonatomic) NSMutableArray <UILabel *> *permanentPopups;

/// All of the dataPoint dots
@property (strong, nonatomic) NSMutableArray <BEMCircle *> *circleDots;

@end

@interface CustomizationTests : XCTestCase <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (strong, nonatomic) BEMSimpleLineGraphView *lineGraph;

@end

@implementation CustomizationTests

- (void)setUp {
    [super setUp];

    self.lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.lineGraph.delegate = self;
    self.lineGraph.dataSource = self;
}

#pragma mark BEMSimpleLineGraph Data Source

- (NSUInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView * __nonnull)graph {
    return numberOfPoints;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView * __nonnull)graph valueForPointAtIndex:(NSUInteger)index {
    return pointValue;
}

- (NSString *)lineGraph:(nonnull BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSUInteger)index {
    return xAxisLabelString;
}

- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView * __nonnull)graph {
    return popUpPrefix;
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView * __nonnull)graph {
    return popUpSuffix;
}

#pragma mark Tests

- (void)testDotCustomization {
    CGFloat sizePoint = 20.0;

    self.lineGraph.alwaysDisplayDots = YES;
    self.lineGraph.animationGraphEntranceTime = 0.0;
    self.lineGraph.sizePoint = sizePoint;
    self.lineGraph.colorPoint = [UIColor greenColor];
    [self.lineGraph reloadGraph];

    NSArray <BEMCircle *> *dots = self.lineGraph.circleDots;

    XCTAssert(dots.count == numberOfPoints, @"There should be as many BEMCircle views in the graph's subviews as the data source method 'numberOfPointsInLineGraph:' returns");

    for (BEMCircle *dot in dots) {
        XCTAssert(dot.bounds.size.width == sizePoint, @"Dots size point has been customized to 20.0");
        XCTAssert(dot.bounds.size.height == sizePoint, @"Dots size point has been customized to 20.0");
        XCTAssert([dot.color isEqual:[UIColor greenColor]], @"Dots color has been set to green");
        XCTAssert(dot.absoluteValue == pointValue, @"Dots are expected to have a value equal to the value returned by the data source method 'valueForPointAtIndex:'");
        XCTAssert(dot.alpha >= 0.98 && dot.alpha <= 1.0, @"Dots are expected to always be displayed (alpha of 1.0)");
        XCTAssert([dot.backgroundColor isEqual:[UIColor clearColor]], @"Dots are expected to have a clearColor background color by default");
    }
}

- (void)testXAxisCustomization {
    UIFont *font = [UIFont systemFontOfSize:25.0];
    self.lineGraph.labelFont = font;
    self.lineGraph.colorXaxisLabel = [UIColor greenColor];
    [self.lineGraph reloadGraph];

    NSArray <UILabel *> *labels = [self.lineGraph graphLabelsForXAxis];
    XCTAssert(labels.count == numberOfPoints, @"The number of X-Axis labels should be the same as the number of points on the graph");

    for (UILabel *XAxisLabel in labels) {
        XCTAssert([XAxisLabel isMemberOfClass:[UILabel class]], @"The array returned by 'graphLabelsForXAxis' should only return UILabels");
        XCTAssert([XAxisLabel.text isEqualToString:xAxisLabelString], @"The X-Axis label's strings should be the same as the one returned by the data source method 'labelOnXAxisForIndex:'");
        XCTAssert([XAxisLabel.backgroundColor isEqual:[UIColor clearColor]], @"X-Axis labels are expected to have a clear background color by default");
        XCTAssert(XAxisLabel.textAlignment == NSTextAlignmentCenter, @"X-Axis labels are expected to have their text centered by default");
        XCTAssert(XAxisLabel.font == font, @"X-Axis label's font is expected to be the customized one");
        XCTAssert(XAxisLabel.textColor = [UIColor greenColor], @"X-Axis label's text color is expected to tbe the customized one");
    }
}

- (void)testPopUps {
    self.lineGraph.alwaysDisplayPopUpLabels = YES;
    self.lineGraph.colorBackgroundPopUplabel = [UIColor greenColor];
    UIFont *font = [UIFont systemFontOfSize:25.0];
    self.lineGraph.labelFont = font;
    [self.lineGraph reloadGraph];

    NSMutableArray <UILabel *> *popUps = self.lineGraph.permanentPopups;

    XCTAssert(popUps.count == numberOfPoints, @"We should have a popup above each and every dot");
    NSString *expectedLabelText = [NSString stringWithFormat:@"%@%.f%@", popUpPrefix,pointValue,popUpSuffix];
    for (UILabel *popUp in popUps) {
        XCTAssert([popUp isMemberOfClass:[UILabel class]],@"Popups must be label class");
        //  XCTAssert(popUp.backgroundColor == [UIColor greenColor],@"")
        // XCTAssert(popUp.layer.alpha >= 0.69 && popUp.alpha <= 0.71, @"The popups should always be displayed and have an alpha of 0.7");
        UIColor * expectedColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.7f];
        XCTAssert(CGColorEqualToColor(popUp.layer.backgroundColor, expectedColor.CGColor), @"The popups background color should be the one set by the property");
        XCTAssert([popUp.text isEqualToString:expectedLabelText], @"The popup labels should display the value of the dot and the suffix and prefix returned by the delegate");
        XCTAssert(popUp.font == font, @"The popup label's font is expected to be the customized one");
        XCTAssert(popUp.backgroundColor == [UIColor clearColor], @"The popup label's background color should always be clear color");
    }
}

- (void)tearDown {
    self.lineGraph = nil;
    [super tearDown];
}

@end
