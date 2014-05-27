//
//  BEMSimpleLineGraphView.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMSimpleLineGraphView.h"

#if !__has_feature(objc_arc)
    // Add the -fobjc-arc flag to enable ARC for only these files, as described in the ARC documentation: http://clang.llvm.org/docs/AutomaticReferenceCounting.html
    #error BEMSimpleLineGraph is built with Objective-C ARC. You must enable ARC for these files.
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define labelXaxisOffset 10


@interface BEMSimpleLineGraphView () {
    /// The number of Points in the Graph
    NSInteger numberOfPoints;
    
    /// The closest point to the touch point
    BEMCircle *closestDot;
    NSInteger currentlyCloser;
    
    /// All of the X-Axis Values
    NSMutableArray *xAxisValues;
    
    /// All of the X-Axis Values
    NSMutableArray *yAxisValues;
    
    /// All of the Data Points
    NSMutableArray *dataPoints;
}

/// The vertical line which appears when the user drags across the graph
@property (strong, nonatomic) UIView *verticalLine;

/// View for picking up pan gesture
@property (strong, nonatomic, readwrite) UIView *panView;

/// The gesture recognizer picking up the pan in the graph view
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

/// The label displayed when enablePopUpReport is set to YES
@property (strong, nonatomic) UILabel *popUpLabel;

/// The view used for the background of the popup label
@property (strong, nonatomic) UIView *popUpView;

/// The X position (center) of the view for the popup label
@property (assign) CGFloat xCenterLabel;

/// The Y position (center) of the view for the popup label
@property (assign) CGFloat yCenterLabel;

/// Find which point is currently the closest to the vertical line
- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine;

/// Determines the biggest Y-axis value from all the points
- (CGFloat)maxValue;

/// Determines the smallest Y-axis value from all the points
- (CGFloat)minValue;

@end

@implementation BEMSimpleLineGraphView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    // Do any initialization that's common to both -initWithFrame: and -initWithCoder: in this method
    
    // Set the X Axis label font
    _labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];

    // DEFAULT VALUES
    _animationGraphEntranceTime = 1.5;
    _colorXaxisLabel = [UIColor blackColor];
    
    _colorTop = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _colorLine = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    _colorBottom = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;
    _widthLine = 1.0;
    _sizePoint = 10.0;
    _colorPoint = [UIColor whiteColor];
    _enableTouchReport = NO;
    _enablePopUpReport = NO;
    _enableBezierCurve = NO;
    _autoScaleYAxis = YES;
    _alwaysDisplayDots = NO;
    _alwaysDisplayPopUpLabels = NO;
    
    // Initialize the arrays
    xAxisValues = [NSMutableArray array];
    dataPoints = [NSMutableArray array];
    yAxisValues = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Let the delegate know that the graph began layout updates
    if ([self.delegate respondsToSelector:@selector(lineGraphDidBeginLoading:)])
        [self.delegate lineGraphDidBeginLoading:self];
    
    // Get the total number of data points from the delegate
    if ([self.delegate respondsToSelector:@selector(numberOfPointsInLineGraph:)]) {
        numberOfPoints = [self.delegate numberOfPointsInLineGraph:self];
        
    } else if ([self.delegate respondsToSelector:@selector(numberOfPointsInGraph)]) {
        [self printDeprecationWarningForOldMethod:@"numberOfPointsInGraph" andReplacementMethod:@"numberOfPointsInLineGraph:"];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        numberOfPoints = [self.delegate numberOfPointsInGraph];
#pragma clang diagnostic pop
        
    } else numberOfPoints = 0;
    
    // Draw the graph
    [self drawGraph];
    
    // Draw the X-Axis
    [self drawXAxis];
    
    // If the touch report is enabled, set it up
    if (self.enableTouchReport == YES || self.enablePopUpReport == YES) {
        // Initialize the vertical gray line that appears where the user touches the graph.
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.viewForBaselineLayout.frame.size.height)];
        self.verticalLine.backgroundColor = [UIColor grayColor];
        self.verticalLine.alpha = 0;
        [self addSubview:self.verticalLine];
        
        self.panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        self.panView.backgroundColor = [UIColor clearColor];
        [self.viewForBaselineLayout addSubview:self.panView];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panGesture.delegate = self;
        [self.panGesture setMaximumNumberOfTouches:1];
        [self.panView addGestureRecognizer:self.panGesture];
        
        if (self.enablePopUpReport == YES && self.alwaysDisplayPopUpLabels == NO) {
            self.popUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            self.popUpLabel.text = [NSString stringWithFormat:@"%@", [self calculateMaximumPointValue]];
            self.popUpLabel.textAlignment = 1;
            self.popUpLabel.numberOfLines = 1;
            self.popUpLabel.font = self.labelFont;
            self.popUpLabel.backgroundColor = [UIColor clearColor];
            [self.popUpLabel sizeToFit];
            self.popUpLabel.alpha = 0;
            
            self.popUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.popUpLabel.frame.size.width + 7, self.popUpLabel.frame.size.height + 2)];
            self.popUpView.backgroundColor = [UIColor whiteColor];
            self.popUpView.alpha = 0;
            self.popUpView.layer.cornerRadius = 3;
            [self addSubview:self.popUpView];
            [self addSubview:self.popUpLabel];
        }
    }
    
    // Let the delegate know that the graph finished layout updates
    if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)])
        [self.delegate lineGraphDidFinishLoading:self];
}

#pragma mark - Drawing

- (void)drawGraph {
    if (numberOfPoints <= 1) { // Exception if there is only one point.
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, self.sizePoint, self.sizePoint)];
        circleDot.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        circleDot.Pointcolor = self.colorPoint;
        circleDot.alpha = 0;
        [self addSubview:circleDot];
        return;
    }
    
    // CREATION OF THE DOTS
    [self drawDots];
}

- (void)drawDots {
    CGFloat maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    CGFloat minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    CGFloat positionOnXAxis; // The position on the X-axis of the point currently being created.
    CGFloat positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    CGFloat padding = self.frame.size.height/2;
    if (padding > 80.0) {
        padding = 80.0;
    }

    // Remove all dots that were previously on the graph
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMCircle class]])
            [subview removeFromSuperview];
    }
    
    // Remove all data points before adding them to the array
    [dataPoints removeAllObjects];
    
    // Remove all yAxis values before adding them to the array
    [yAxisValues removeAllObjects];
    
    // Loop through each point and add it to the graph
    @autoreleasepool {
        for (int i = 0; i < numberOfPoints; i++) {
            CGFloat dotValue = 0;
            
            if ([self.delegate respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
                dotValue = [self.delegate lineGraph:self valueForPointAtIndex:i];
                
            } else if ([self.delegate respondsToSelector:@selector(valueForIndex:)]) {
                [self printDeprecationWarningForOldMethod:@"valueForIndex:" andReplacementMethod:@"lineGraph:valueForPointAtIndex:"];
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                dotValue = [self.delegate valueForIndex:i];
#pragma clang diagnostic pop
                
            } else [NSException raise:@"lineGraph:valueForPointAtIndex: protocol method is not implemented in the delegate. Throwing exception here before the system throws a CALayerInvalidGeometry Exception." format:@"Value for point %f at index %lu is invalid. CALayer position may contain NaN: [0 nan]", dotValue, (unsigned long)i];
            
            [dataPoints addObject:[NSNumber numberWithFloat:dotValue]];
            
            positionOnXAxis = (self.frame.size.width/(numberOfPoints - 1))*i;
            if (minValue == maxValue) positionOnYAxis = self.frame.size.height/2;
            else {
                if (self.autoScaleYAxis == YES) {
                    positionOnYAxis = ((self.frame.size.height - padding) - ((dotValue - minValue) / ((maxValue - minValue) / (self.frame.size.height - padding))) + padding/2);
                } else {
                    positionOnYAxis = ((self.frame.size.height - padding) - dotValue);
                }
                
            }
            if ([self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)] || [self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)])
            {
                positionOnYAxis = positionOnYAxis - 10;
            }
            
            BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, self.sizePoint, self.sizePoint)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0;
            circleDot.absoluteValue = dotValue;
            circleDot.Pointcolor = self.colorPoint;
            
            [yAxisValues addObject:[NSNumber numberWithFloat:positionOnYAxis]];

            [self addSubview:circleDot];
            
            if (self.alwaysDisplayPopUpLabels == YES) {
                [self displayPermanentLabelForPoint:circleDot];
            }
            
            // Dot entrance animation
            if (self.animationGraphEntranceTime == 0) {
                if (self.alwaysDisplayDots == NO) {
                    circleDot.alpha = 0;
                }
            } else {
                [UIView animateWithDuration:(float)self.animationGraphEntranceTime/numberOfPoints
                                      delay:(float)i*((float)self.animationGraphEntranceTime/numberOfPoints)
                                    options:UIViewAnimationOptionCurveLinear animations:^{
                    circleDot.alpha = 0.7;
                } completion:^(BOOL finished){
                    if (self.alwaysDisplayDots == NO) {
                        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            circleDot.alpha = 0;
                        } completion:nil];
                    }
                }];
            }
        }
    }
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    [self drawLine];
}

- (void)displayPermanentLabelForPoint:(BEMCircle *)circleDot
{
    self.enablePopUpReport = NO;
    self.xCenterLabel = circleDot.center.x;
    UILabel *permanentPopUpLabel = [[UILabel alloc] init];
    permanentPopUpLabel.textAlignment = 1;
    permanentPopUpLabel.numberOfLines = 0;
    permanentPopUpLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:circleDot.absoluteValue]];
    permanentPopUpLabel.font = self.labelFont;
    permanentPopUpLabel.backgroundColor = [UIColor clearColor];
    [permanentPopUpLabel sizeToFit];
    permanentPopUpLabel.center = CGPointMake(self.xCenterLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
    permanentPopUpLabel.alpha = 0;
    
    UIView *permanentPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, permanentPopUpLabel.frame.size.width + 7, permanentPopUpLabel.frame.size.height + 2)];
    permanentPopUpView.backgroundColor = [UIColor whiteColor];
    permanentPopUpView.alpha = 0;
    permanentPopUpView.layer.cornerRadius = 3;
    permanentPopUpView.tag = 2100;
    permanentPopUpView.center = permanentPopUpLabel.center;
    
    if (permanentPopUpLabel.frame.origin.x <= 0) {
        self.xCenterLabel = permanentPopUpLabel.frame.size.width/2 + 4;
        permanentPopUpLabel.center = CGPointMake(self.xCenterLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
        permanentPopUpView.center = permanentPopUpLabel.center;
    } else if ((permanentPopUpLabel.frame.origin.x + permanentPopUpLabel.frame.size.width) >= self.frame.size.width) {
        self.xCenterLabel = self.frame.size.width - permanentPopUpLabel.frame.size.width/2 - 4;
        permanentPopUpLabel.center = CGPointMake(self.xCenterLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
        permanentPopUpView.center = permanentPopUpLabel.center;
    }
    if (permanentPopUpLabel.frame.origin.y <= 2) {
        permanentPopUpLabel.center = CGPointMake(self.xCenterLabel, circleDot.center.y + circleDot.frame.size.height/2 + 15);
        permanentPopUpView.center = permanentPopUpLabel.center;
    }
    
    if ([self checkOverlapsForView:permanentPopUpView] == YES) {
        permanentPopUpLabel.center = CGPointMake(self.xCenterLabel, circleDot.center.y + circleDot.frame.size.height/2 + 15);
        permanentPopUpView.center = permanentPopUpLabel.center;
    }
    
    [self addSubview:permanentPopUpView];
    [self addSubview:permanentPopUpLabel];
    
    if (self.animationGraphEntranceTime == 0) {
        permanentPopUpLabel.alpha = 1;
        permanentPopUpView.alpha = 0.7;
    } else {
        [UIView animateWithDuration:0.5
                              delay:self.animationGraphEntranceTime
                            options:UIViewAnimationOptionCurveLinear animations:^{
                        permanentPopUpLabel.alpha = 1;
                        permanentPopUpView.alpha = 0.7;
        } completion:nil];
    }
}

-(BOOL)checkOverlapsForView:(UIView *)view
{
    for (UIView *viewForLabel in [self subviews]) {
        if ([viewForLabel isKindOfClass:[UIView class]] && viewForLabel.tag == 2100) {
            if ((viewForLabel.frame.origin.x + viewForLabel.frame.size.width) >= view.frame.origin.x) {
                if (viewForLabel.frame.origin.y >= view.frame.origin.y && viewForLabel.frame.origin.y <= view.frame.origin.y + view.frame.size.height) {
                    return YES;
                } else if (viewForLabel.frame.origin.y + viewForLabel.frame.size.height >= view.frame.origin.y && viewForLabel.frame.origin.y + viewForLabel.frame.size.height <= view.frame.origin.y + view.frame.size.height){
                    return YES;
                }
                
            }
        }
    }
    return NO;
}


- (void)drawLine {
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMLine class]])
            [subview removeFromSuperview];
    }
    BEMLine *line = [[BEMLine alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    line.opaque = NO;
    line.alpha = 1;
    line.backgroundColor = [UIColor clearColor];
    line.topColor = self.colorTop;
    line.bottomColor = self.colorBottom;
    line.topAlpha = self.alphaTop;
    line.bottomAlpha = self.alphaBottom;
    line.lineWidth = self.widthLine;
    line.lineAlpha = self.alphaLine;
    line.bezierCurveIsEnabled = self.enableBezierCurve;
    line.arrayOfPoints = yAxisValues;
    line.color = self.colorLine;
    line.animationTime = self.animationGraphEntranceTime;
    [self addSubview:line];
    [self sendSubviewToBack:line];
    
}

- (void)drawXAxis {
    if ((![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)]) && (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)])) return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == 1000)
            [subview removeFromSuperview];
    }

    NSInteger numberOfGaps = 0;
    
    if ([self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)]) {
        numberOfGaps = [self.delegate numberOfGapsBetweenLabelsOnLineGraph:self] + 1;
        
    } else if ([self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)]) {
        [self printDeprecationWarningForOldMethod:@"numberOfGapsBetweenLabels" andReplacementMethod:@"numberOfGapsBetweenLabelsOnLineGraph:"];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        numberOfGaps = [self.delegate numberOfGapsBetweenLabels] + 1;
#pragma clang diagnostic pop
        
    } else numberOfGaps = 0;
    
    // Remove all X-Axis Labels before adding them to the array
    [xAxisValues removeAllObjects];
    
    if (numberOfGaps >= (numberOfPoints - 1)) {
        NSString *firstXLabel = @"";
        NSString *lastXLabel = @"";
        
        if ([self.delegate respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
            firstXLabel = [self.delegate lineGraph:self labelOnXAxisForIndex:0];
            lastXLabel = [self.delegate lineGraph:self labelOnXAxisForIndex:(numberOfPoints - 1)];
            
        } else if ([self.delegate respondsToSelector:@selector(labelOnXAxisForIndex:)]) {
            [self printDeprecationWarningForOldMethod:@"labelOnXAxisForIndex:" andReplacementMethod:@"lineGraph:labelOnXAxisForIndex:"];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            firstXLabel = [self.delegate labelOnXAxisForIndex:0];
            lastXLabel = [self.delegate labelOnXAxisForIndex:(numberOfPoints - 1)];
#pragma clang diagnostic pop
            
        } else firstXLabel = @"";
        
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        firstLabel.text = firstXLabel;
        firstLabel.font = self.labelFont;
        firstLabel.textAlignment = 0;
        firstLabel.textColor = self.colorXaxisLabel;
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.tag = 1000;
        [self addSubview:firstLabel];
        [xAxisValues addObject:firstXLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        lastLabel.text = lastXLabel;
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor = self.colorXaxisLabel;
        lastLabel.backgroundColor = [UIColor clearColor];
        lastLabel.tag = 1000;
        [self addSubview:lastLabel];
        [xAxisValues addObject:lastXLabel];
        
    } else {
        NSInteger offset = [self offsetForXAxisWithNumberOfGaps:numberOfGaps]; // The offset (if possible and necessary) used to shift the Labels on the X-Axis for them to be centered.
        
        @autoreleasepool {
            for (int i = 1; i <= (numberOfPoints/numberOfGaps); i++) {
                NSString *xAxisLabel = @"";
                
                if ([self.delegate respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
                    NSInteger index = i * numberOfGaps - 1 - offset;
                    xAxisLabel = [self.delegate lineGraph:self labelOnXAxisForIndex:index];
                    
                } else if ([self.delegate respondsToSelector:@selector(labelOnXAxisForIndex:)]) {
                    [self printDeprecationWarningForOldMethod:@"labelOnXAxisForIndex:" andReplacementMethod:@"lineGraph:labelOnXAxisForIndex:"];
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    xAxisLabel = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1 - offset)];
#pragma clang diagnostic pop
                    
                } else xAxisLabel = @"";
                
                UILabel *labelXAxis = [[UILabel alloc] init];
                labelXAxis.text = xAxisLabel;
                [labelXAxis sizeToFit];
                [labelXAxis setCenter:CGPointMake((self.viewForBaselineLayout.frame.size.width/(numberOfPoints-1))*(i*numberOfGaps - 1 - offset), self.frame.size.height - labelXaxisOffset)];
                labelXAxis.font = self.labelFont;
                labelXAxis.textAlignment = 1;
                labelXAxis.textColor = self.colorXaxisLabel;
                labelXAxis.backgroundColor = [UIColor clearColor];
                labelXAxis.tag = 1000;
                [self addSubview:labelXAxis];
                [xAxisValues addObject:xAxisLabel];
            }
        }
    }
}

- (NSInteger)offsetForXAxisWithNumberOfGaps:(NSInteger)numberOfGaps {
    // Calculates the optimum offset needed for the Labels to be centered on the X-Axis.
    NSInteger leftGap = numberOfGaps - 1;
    NSInteger rightGap = numberOfPoints - (numberOfGaps*(numberOfPoints/numberOfGaps));
    NSInteger offset = 0;
    
    if (leftGap != rightGap) {
        for (int i = 0; i <= numberOfGaps; i++) {
            if (leftGap - i == rightGap + i) {
                offset = i;
            }
        }
    }
    
    return offset;
}

- (UIImage *)graphSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]; // Pre-iOS 7 Style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Data Source

- (void)reloadGraph {
    for (UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    [self setNeedsLayout];
}

#pragma mark - Calculations

- (NSNumber *)calculatePointValueAverage {
    NSExpression *expression = [NSExpression expressionForFunction:@"average:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueSum {
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueMedian {
    NSExpression *expression = [NSExpression expressionForFunction:@"median:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueMode {
    NSExpression *expression = [NSExpression expressionForFunction:@"mode:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSMutableArray *value = [expression expressionValueWithObject:nil context:nil];
    
    return [value firstObject];
}

- (NSNumber *)calculateLineGraphStandardDeviation {
    NSExpression *expression = [NSExpression expressionForFunction:@"stddev:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculateMinimumPointValue {
    if (dataPoints.count > 0) {
        NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
        NSNumber *value = [expression expressionValueWithObject:nil context:nil];
        return value;
    } else {
        return 0;
    }
}

- (NSNumber *)calculateMaximumPointValue {
    NSExpression *expression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}


#pragma mark - Values

- (NSArray *)graphValuesForXAxis {
    return xAxisValues;
}

- (NSArray *)graphValuesForDataPoints {
    return dataPoints;
}


#pragma mark - Touch Gestures

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.panGesture]) {
        if (gestureRecognizer.numberOfTouches > 0) {
            CGPoint translation = [self.panGesture velocityInView:self.panView];
            return fabs(translation.y) < fabs(translation.x);
            } else {
                return NO;
                }
        }
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForBaselineLayout];

    if ((translation.x + self.frame.origin.x) <= self.frame.origin.x) { // To make sure the vertical line doesn't go beyond the frame of the graph.
        self.verticalLine.frame = CGRectMake(0, 0, 1, self.viewForBaselineLayout.frame.size.height);
    } else if ((translation.x + self.frame.origin.x) >= self.frame.origin.x + self.frame.size.width) {
        self.verticalLine.frame = CGRectMake(self.frame.size.width, 0, 1, self.viewForBaselineLayout.frame.size.height);
    } else {
        self.verticalLine.frame = CGRectMake(translation.x, 0, 1, self.viewForBaselineLayout.frame.size.height);
    }
    
    self.verticalLine.alpha = 0.2;

    closestDot = [self closestDotFromVerticalLine:self.verticalLine];
    closestDot.alpha = 0.8;
    
    
    if (self.enablePopUpReport == YES && self.alwaysDisplayPopUpLabels == NO) {
        [self setUpPopUpLabelAbovePoint:closestDot];
    }
    
    if ([closestDot isMemberOfClass:[BEMCircle class]]) {
        if ([self.delegate respondsToSelector:@selector(lineGraph:didTouchGraphWithClosestIndex:)] && self.enableTouchReport == YES) {
            [self.delegate lineGraph:self didTouchGraphWithClosestIndex:((NSInteger)closestDot.tag - 100)];
            
        } else if ([self.delegate respondsToSelector:@selector(didTouchGraphWithClosestIndex:)] && self.enableTouchReport == YES) {
            [self printDeprecationWarningForOldMethod:@"didTouchGraphWithClosestIndex:" andReplacementMethod:@"lineGraph:didTouchGraphWithClosestIndex:"];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self.delegate didTouchGraphWithClosestIndex:((int)closestDot.tag - 100)];
#pragma clang diagnostic pop
        }
    }
    
    // ON RELEASE
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(lineGraph:didReleaseTouchFromGraphWithClosestIndex:)]) {
            [self.delegate lineGraph:self didReleaseTouchFromGraphWithClosestIndex:(closestDot.tag - 100)];
            
        } else if ([self.delegate respondsToSelector:@selector(didReleaseGraphWithClosestIndex:)]) {
            [self printDeprecationWarningForOldMethod:@"didReleaseGraphWithClosestIndex:" andReplacementMethod:@"lineGraph:didReleaseTouchFromGraphWithClosestIndex:"];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self.delegate didReleaseGraphWithClosestIndex:(closestDot.tag - 100)];
#pragma clang diagnostic pop
        }
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.alwaysDisplayDots == NO) {
                closestDot.alpha = 0;
            }
            self.verticalLine.alpha = 0;
            if (self.enablePopUpReport == YES) {
                self.popUpView.alpha = 0;
                self.popUpLabel.alpha = 0;
            }
        } completion:nil];
    }
}

- (void)setUpPopUpLabelAbovePoint:(BEMCircle *)closestPoint {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.popUpView.alpha = 0.7;
        self.popUpLabel.alpha = 1;
    } completion:nil];
    
    self.xCenterLabel = closestDot.center.x;
    self.yCenterLabel = closestDot.center.y - closestDot.frame.size.height/2 - 15;
    self.popUpView.center = CGPointMake(self.xCenterLabel, self.yCenterLabel);
    self.popUpLabel.center = self.popUpView.center;
    self.popUpLabel.text = [NSString stringWithFormat:@"%@", [dataPoints objectAtIndex:(NSInteger)closestDot.tag - 100]];
    
    if (self.popUpView.frame.origin.x <= 0) {
        self.xCenterLabel = self.popUpView.frame.size.width/2;
        self.popUpView.center = CGPointMake(self.xCenterLabel, self.yCenterLabel);
        self.popUpLabel.center = self.popUpView.center;
    } else if ((self.popUpView.frame.origin.x + self.popUpView.frame.size.width) >= self.frame.size.width) {
        self.xCenterLabel = self.frame.size.width - self.popUpView.frame.size.width/2;
        self.popUpView.center = CGPointMake(self.xCenterLabel, self.yCenterLabel);
        self.popUpLabel.center = self.popUpView.center;
    }
    if (self.popUpView.frame.origin.y <= 2) {
        self.yCenterLabel = closestDot.center.y + closestDot.frame.size.height/2 + 15;
        self.popUpView.center = CGPointMake(self.xCenterLabel, closestDot.center.y + closestDot.frame.size.height/2 + 15);
        self.popUpLabel.center = self.popUpView.center;
    }
}

#pragma mark - Graph Calculations

- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine {
    currentlyCloser = 1000;
    for (BEMCircle *point in self.subviews) {
        if ([point isMemberOfClass:[BEMCircle class]]) {
            if (self.alwaysDisplayDots == NO) {
                point.alpha = 0;
            }
            if (pow(((point.center.x) - verticalLine.frame.origin.x), 2) < currentlyCloser) {
                currentlyCloser = pow(((point.center.x) - verticalLine.frame.origin.x), 2);
                closestDot = point;
            }
        }
    }
    return closestDot;
}

- (CGFloat)maxValue {
    CGFloat dotValue;
    CGFloat maxValue = 0;
    
    @autoreleasepool {
        for (int i = 0; i < numberOfPoints; i++) {
            if ([self.delegate respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
                dotValue = [self.delegate lineGraph:self valueForPointAtIndex:i];
                
            } else if ([self.delegate respondsToSelector:@selector(valueForIndex:)]) {
                [self printDeprecationWarningForOldMethod:@"valueForIndex:" andReplacementMethod:@"lineGraph:valueForPointAtIndex:"];
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                dotValue = [self.delegate valueForIndex:i];
#pragma clang diagnostic pop
                
            } else dotValue = 0;
            
            if (dotValue > maxValue) {
                maxValue = dotValue;
            }
        }
    }
    return maxValue;
}

- (CGFloat)minValue {
    CGFloat dotValue;
    CGFloat minValue = INFINITY;
    
    @autoreleasepool {
        for (int i = 0; i < numberOfPoints; i++) {
            if ([self.delegate respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
                dotValue = [self.delegate lineGraph:self valueForPointAtIndex:i];
                
            } else if ([self.delegate respondsToSelector:@selector(valueForIndex:)]) {
                [self printDeprecationWarningForOldMethod:@"valueForIndex:" andReplacementMethod:@"lineGraph:valueForPointAtIndex:"];
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                dotValue = [self.delegate valueForIndex:i];
#pragma clang diagnostic pop
                
            } else dotValue = 0;
            
            if (dotValue < minValue) {
                minValue = dotValue;
            }
        }
    }
    
    return minValue;
}

#pragma mark - Other Methods

- (void)printDeprecationWarningForOldMethod:(NSString *)oldMethod andReplacementMethod:(NSString *)replacementMethod {
    NSLog(@"[BEMSimpleLineGraph] DEPRECATION WARNING. The delegate method, %@, is deprecated and will become unavailable in a future version. Use %@ instead. Update your delegate method as soon as possible. An exception will be thrown in a future version.", oldMethod, replacementMethod);
}

@end
