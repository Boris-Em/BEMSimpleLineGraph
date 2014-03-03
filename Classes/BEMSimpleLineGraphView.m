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
#define padding 80
#define circleSize 10
#define labelXaxisOffset 10


@interface BEMSimpleLineGraphView () {
    /// The number of Points in the Graph
    NSInteger numberOfPoints;
    
    /// The closest dot to the touch point
    BEMCircle *closestDot;
    NSInteger currentlyCloser;
    
    /// All of the X-Axis Values
    NSMutableArray *xAxisValues;
    
    /// All of the Data Points
    NSMutableArray *dataPoints;
}

/// The vertical line which appears when the user drags across the graph
@property (strong, nonatomic) UIView *verticalLine;

/// The animation delegate for lines and dots
@property (strong, nonatomic) BEMAnimations *animationDelegate;

/// Find which dot is currently the closest to the vertical line
- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine;

// Determines the biggest Y-axis value from all the points
- (CGFloat)maxValue;

// Determines the smallest Y-axis value from all the points
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
    
    // Set the animation delegate
    self.animationDelegate = [[BEMAnimations alloc] init];
    self.animationDelegate.delegate = self;
    
    // Set the X Axis label font
    _labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    // DEFAULT VALUES
    _animationGraphEntranceSpeed = 5;
    _colorXaxisLabel = [UIColor blackColor];
    
    // Set the bottom color to the window's tint color (if no color is set)
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) _colorBottom = window.tintColor;
    else _colorBottom = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:0.2];
    
    _colorTop = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    _colorLine = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:1];
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;
    _widthLine = 1.0;
    _enableTouchReport = NO;
    _enableBezierCurve = NO;
    
    // Initialize the arrays
    xAxisValues = [NSMutableArray array];
    dataPoints = [NSMutableArray array];
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
    if (self.enableTouchReport == YES) {
        // Initialize the vertical gray line that appears where the user touches the graph.
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.viewForBaselineLayout.frame.size.height)];
        self.verticalLine.backgroundColor = [UIColor grayColor];
        self.verticalLine.alpha = 0;
        [self addSubview:self.verticalLine];
        
        UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        panView.backgroundColor = [UIColor clearColor];
        [self.viewForBaselineLayout addSubview:panView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [panView addGestureRecognizer:panGesture];
    }
    
    // Let the delegate know that the graph finished layout updates
    if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)])
        [self.delegate lineGraphDidFinishLoading:self];
}

#pragma mark - Drawing

- (void)drawGraph {
    if (numberOfPoints <= 1) { // Exception if there is only one point.
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, circleSize, circleSize)];
        circleDot.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        circleDot.alpha = 0.7;
        [self addSubview:circleDot];
        
        return;
    }
    
    // CREATION OF THE DOTS
    [self drawDots];
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    [self drawLines];
}

- (void)drawDots {
    CGFloat maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    CGFloat minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    CGFloat positionOnXAxis; // The position on the X-axis of the point currently being created.
    CGFloat positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    // Remove all dots that were previously on the graph
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMCircle class]])
            [subview removeFromSuperview];
    }
    
    // Remove all data points before adding them to the array
    [dataPoints removeAllObjects];
    
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
            else positionOnYAxis = (self.frame.size.height - padding) - ((dotValue - minValue) / ((maxValue - minValue) / (self.frame.size.height - padding))) + 30;
            
            BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, circleSize, circleSize)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0;
            
            [self addSubview:circleDot];
            
            [self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
        }
    }
}

- (void)drawLines {
    CGFloat xDot1; // Postion on the X-axis of the first dot.
    CGFloat yDot1; // Postion on the Y-axis of the first dot.
    CGFloat xDot2; // Postion on the X-axis of the second dot.
    CGFloat yDot2; // Postion on the Y-axis of the second dot.
    
    // For Bezier Curved Lines
    CGFloat xDot0; // Postion on the X-axis of the previous dot.
    CGFloat yDot0; // Postion on the Y-axis of the previous dot.
    CGFloat xDot3; // Postion on the X-axis of the next dot.
    CGFloat yDot3; // Postion on the Y-axis of the next dot.
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMLine class]])
            [subview removeFromSuperview];
    }
    
    @autoreleasepool {
        for (int i = 0; i < numberOfPoints; i++) {
            for (UIView *dot in [self.viewForBaselineLayout subviews]) {
                if (dot.tag == i + 100)  {
                    xDot1 = dot.center.x;
                    yDot1 = dot.center.y;
                } else if (dot.tag == i + 101) {
                    xDot2 = dot.center.x;
                    yDot2 = dot.center.y;
                } else if (dot.tag == i + 102 && self.enableBezierCurve == YES) {
                    xDot3 = dot.center.x;
                    yDot3 = dot.center.y;
                } else if (dot.tag == i + 99 && self.enableBezierCurve == YES)  {
                    xDot0 = dot.center.x;
                    yDot0 = dot.center.y;
                }
            }
            
            BEMLine *line = [[BEMLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
            line.opaque = NO;
            line.tag = i + 1000;
            line.alpha = 0;
            line.backgroundColor = [UIColor clearColor];
            line.P1 = CGPointMake(xDot1, yDot1);
            line.P2 = CGPointMake(xDot2, yDot2);
            if (self.enableBezierCurve == YES) {
                line.P0 = CGPointMake(xDot0, yDot0);
                line.P3 = CGPointMake(xDot3, yDot3);
            }
            line.topColor = self.colorTop;
            line.bottomColor = self.colorBottom;
            if ([self.delegate respondsToSelector:@selector(lineGraph:lineColorForIndex:)]) line.color = [self.delegate lineGraph:self lineColorForIndex:i];
            else line.color = self.colorLine;
            line.topAlpha = self.alphaTop;
            line.bottomAlpha = self.alphaBottom;
            if ([self.delegate respondsToSelector:@selector(lineGraph:lineAlphaForIndex:)]) line.alpha = [self.delegate lineGraph:self lineAlphaForIndex:i];
            else line.lineAlpha = self.alphaLine;
            line.lineWidth = self.widthLine;
            line.bezierCurveIsEnabled = self.enableBezierCurve;
            [self addSubview:line];
            [self sendSubviewToBack:line];
            
            [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
        }
    }
}

- (void)drawXAxis {
    if ((![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)]) && (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)])) return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
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
        [self addSubview:firstLabel];
        [xAxisValues addObject:firstXLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        lastLabel.text = lastXLabel;
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor = self.colorXaxisLabel;
        lastLabel.backgroundColor = [UIColor clearColor];
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
    NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:dataPoints]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
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

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForBaselineLayout];
    
    self.verticalLine.frame = CGRectMake(translation.x, 0, 1, self.viewForBaselineLayout.frame.size.height);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.verticalLine.alpha = 0.2;
    } completion:nil];
    
    closestDot = [self closestDotFromVerticalLine:self.verticalLine];
    closestDot.alpha = 0.8;
    
    if (closestDot.tag > 99 && closestDot.tag < 1000) {
        if ([self.delegate respondsToSelector:@selector(lineGraph:didTouchGraphWithClosestIndex:)]) {
            [self.delegate lineGraph:self didTouchGraphWithClosestIndex:((NSInteger)closestDot.tag - 100)];
            
        } else if ([self.delegate respondsToSelector:@selector(didTouchGraphWithClosestIndex:)]) {
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
            closestDot.alpha = 0;
            self.verticalLine.alpha = 0;
        } completion:nil];
    }
}

#pragma mark - Graph Calculations

- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine {
    currentlyCloser = 1000;
    
    for (BEMCircle *dot in self.subviews) {
        
        if (dot.tag > 99 && dot.tag < 1000) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                dot.alpha = 0;
            } completion:nil];
            
            if (pow(((dot.center.x) - verticalLine.frame.origin.x), 2) < currentlyCloser) {
                currentlyCloser = pow(((dot.center.x) - verticalLine.frame.origin.x), 2);
                closestDot = dot;
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
