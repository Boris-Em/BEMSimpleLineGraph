//
//  BEMSimpleLineGraphView.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMSimpleLineGraphView.h"
#import "BEMGraphCalculator.h"  //just for deprecation warnings; should be removed

const CGFloat BEMNullGraphValue = CGFLOAT_MAX;


#if !__has_feature(objc_arc)
// Add the -fobjc-arc flag to enable ARC for only these files, as described in the ARC documentation: http://clang.llvm.org/docs/AutomaticReferenceCounting.html
#error BEMSimpleLineGraph is built with Objective-C ARC. You must enable ARC for these files.
#endif

typedef NS_ENUM(NSInteger, BEMInternalTags)
{
    DotFirstTag100 = 100,
};

@interface BEMSimpleLineGraphView () {
    /// The number of Points in the Graph
    NSUInteger numberOfPoints;

    /// All of the X-Axis Values
    NSMutableArray <NSString *>*xAxisValues;

    /// All of the X-Axis Label Points
    NSMutableArray <NSNumber *>*xAxisLabelPoints;

    /// How much to ??
    CGFloat xAxisHorizontalFringeNegationValue;

    /// All of the Y-Axis Label Points
    NSMutableArray <NSNumber *> *yAxisLabelPoints;

    /// All of the Y-Axis Values
    NSMutableArray <NSNumber *>*yAxisValues;

    /// All of the Data Points
    NSMutableArray <NSNumber *> *dataPoints;

}

#pragma mark Properties to store all subviews
// Stores the background X Axis view
@property (strong, nonatomic ) UIView *backgroundXAxis;

// Stores the background Y Axis view
@property (strong, nonatomic) UIView *backgroundYAxis;

/// All of the Y-Axis Labels
@property (strong, nonatomic) NSMutableArray <UILabel *> *yAxisLabels;

/// All of the X-Axis Labels
@property (strong, nonatomic) NSMutableArray <UILabel *> *xAxisLabels;

/// All of the dataPoint Labels
@property (strong, nonatomic) NSMutableArray <UILabel *> *permanentPopups;

/// All of the dataPoint dots
@property (strong, nonatomic) NSMutableArray <BEMCircle *> *circleDots;

/// The line itself
@property (strong, nonatomic) BEMLine * masterLine;

/// The vertical line which appears when the user drags across the graph
@property (strong, nonatomic) UIView *touchInputLine;

/// View for picking up pan gesture
@property (strong, nonatomic, readwrite) UIView *panView;

/// Label to display when there is no data
@property (strong, nonatomic) UILabel *noDataLabel;

/// Cirle to display when there's only one datapoint
@property (strong, nonatomic) BEMCircle *oneDot;

/// The gesture recognizer picking up the pan in the graph view
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

/// This gesture recognizer picks up the initial touch on the graph view
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;

/// The label displayed when enablePopUpReport is set to YES
@property (strong, nonatomic) UILabel *popUpLabel;

// Possible custom View displayed instead of popUpLabel
@property (strong, nonatomic) UIView *customPopUpView;

#pragma mark calculated properties
/// The Y offset necessary to compensate the labels on the X-Axis
@property (nonatomic) CGFloat XAxisLabelYOffset;

/// The X offset necessary to compensate the labels on the Y-Axis. Will take the value of the bigger label on the Y-Axis
@property (nonatomic) CGFloat YAxisLabelXOffset;

/// The biggest value out of all of the data points
@property (nonatomic) CGFloat maxValue;

/// The smallest value out of all of the data points
@property (nonatomic) CGFloat minValue;


// Stores the current view size to detect whether a redraw is needed in layoutSubviews
@property (nonatomic) CGSize currentViewSize;

/// Find which point is currently the closest to the vertical line
- (BEMCircle *)closestDotFromTouchInputLine:(UIView *)touchInputLine;


@end

@implementation BEMSimpleLineGraphView

#pragma mark - Initialization

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    [self restorePropertyWithCoder:coder];
    return self;
}

-(void) decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    [self restorePropertyWithCoder:coder];
}

-(void) restorePropertyWithCoder:(NSCoder *) coder {

#define RestoreProperty(property, type) \
if ([coder containsValueForKey:@#property]) { \
self.property = [coder decode ## type ##ForKey:@#property]; \
}\

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullable-to-nonnull-conversion"

    RestoreProperty (colorXaxisLabel, Object);
    RestoreProperty (colorYaxisLabel, Object);
    RestoreProperty (colorTop, Object);
    RestoreProperty (colorLine, Object);
    RestoreProperty (colorBottom, Object);
    RestoreProperty (colorPoint, Object);
    RestoreProperty (colorTouchInputLine, Object);
    RestoreProperty (colorBackgroundPopUplabel, Object);
    RestoreProperty (colorBackgroundYaxis, Object);
    RestoreProperty (colorBackgroundXaxis, Object);
    RestoreProperty (averageLine.color, Object);

    RestoreProperty (alphaTop, Float);
    RestoreProperty (alphaLine, Float);
    RestoreProperty (alphaTouchInputLine, Float);
    RestoreProperty (alphaBackgroundXaxis, Float);
    RestoreProperty (alphaBackgroundYaxis, Float);

    RestoreProperty (widthLine, Float);
    RestoreProperty (widthReferenceLines, Float);
    RestoreProperty (sizePoint, Float);
    RestoreProperty (widthTouchInputLine, Float);

    RestoreProperty (enableTouchReport, Bool);
    RestoreProperty (enablePopUpReport, Bool);
    RestoreProperty (enableBezierCurve, Bool);
    RestoreProperty (enableXAxisLabel, Bool);
    RestoreProperty (enableYAxisLabel, Bool);
    RestoreProperty (autoScaleYAxis, Bool);
    RestoreProperty (alwaysDisplayDots, Bool);
    RestoreProperty (alwaysDisplayPopUpLabels, Bool);
    RestoreProperty (enableLeftReferenceAxisFrameLine, Bool);
    RestoreProperty (enableBottomReferenceAxisFrameLine, Bool);
    RestoreProperty (interpolateNullValues, Bool);
    RestoreProperty (displayDotsOnly, Bool);
    RestoreProperty (displayDotsWhileAnimating, Bool);

    RestoreProperty (touchReportFingersRequired, Int);
    RestoreProperty (formatStringForValues, Object);

    RestoreProperty (averageLine, Object);
#pragma clang diagnostic pop
}

-(void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [self encodePropertiesWithCoder:coder];
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [super encodeWithCoder:coder];
    [self encodePropertiesWithCoder:coder];
}

-(void) encodePropertiesWithCoder: (NSCoder *) coder {

#define EncodeProperty(property, type) [coder encode ## type: self.property forKey:@#property]

    EncodeProperty (labelFont, Object);
    EncodeProperty (animationGraphEntranceTime, Float);
    EncodeProperty (animationGraphStyle, Integer);

    EncodeProperty (colorXaxisLabel, Object);
    EncodeProperty (colorYaxisLabel, Object);
    EncodeProperty (colorTop, Object);
    EncodeProperty (colorLine, Object);
    EncodeProperty (colorBottom, Object);
    EncodeProperty (colorPoint, Object);
    EncodeProperty (colorTouchInputLine, Object);
    EncodeProperty (colorBackgroundPopUplabel, Object);
    EncodeProperty (colorBackgroundYaxis, Object);
    EncodeProperty (colorBackgroundXaxis, Object);
    EncodeProperty (averageLine.color, Object);

    EncodeProperty (alphaTop, Float);
    EncodeProperty (alphaLine, Float);
    EncodeProperty (alphaTouchInputLine, Float);
    EncodeProperty (alphaBackgroundXaxis, Float);
    EncodeProperty (alphaBackgroundYaxis, Float);

    EncodeProperty (widthLine, Float);
    EncodeProperty (widthReferenceLines, Float);
    EncodeProperty (sizePoint, Float);
    EncodeProperty (widthTouchInputLine, Float);

    EncodeProperty (enableTouchReport, Bool);
    EncodeProperty (enablePopUpReport, Bool);
    EncodeProperty (enableBezierCurve, Bool);
    EncodeProperty (enableXAxisLabel, Bool);
    EncodeProperty (enableYAxisLabel, Bool);
    EncodeProperty (autoScaleYAxis, Bool);
    EncodeProperty (alwaysDisplayDots, Bool);
    EncodeProperty (alwaysDisplayPopUpLabels, Bool);
    EncodeProperty (enableLeftReferenceAxisFrameLine, Bool);
    EncodeProperty (enableBottomReferenceAxisFrameLine, Bool);
    EncodeProperty (enableTopReferenceAxisFrameLine, Bool);
    EncodeProperty (enableRightReferenceAxisFrameLine, Bool);
    EncodeProperty (interpolateNullValues, Bool);
    EncodeProperty (displayDotsOnly, Bool);
    EncodeProperty (displayDotsWhileAnimating, Bool);

    [coder encodeInt: (int)(self.touchReportFingersRequired) forKey:@"touchReportFingersRequired"];
    EncodeProperty (formatStringForValues, Object);
    EncodeProperty (averageLine, Object);
}

- (void)commonInit {
    // Do any initialization that's common to both -initWithFrame: and -initWithCoder: in this method

    // Set the X Axis label font
    _labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];

    // Set Animation Values
    _animationGraphEntranceTime = 1.5;

    // Set Color Values
    _colorXaxisLabel = [UIColor blackColor];
    _colorYaxisLabel = [UIColor blackColor];
    _colorTop = [UIColor colorWithRed:0 green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    _colorLine = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    _colorBottom = [UIColor colorWithRed:0 green:122.0f/255.0f blue:255.0f/255.0f alpha:1];
    _colorPoint = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _colorTouchInputLine = [UIColor grayColor];
    _colorBackgroundPopUplabel = [UIColor whiteColor];
    _alphaTouchInputLine = 0.2f;
    _widthTouchInputLine = 1.0;
    _colorBackgroundXaxis = nil;
    _alphaBackgroundXaxis = 1.0;
    _colorBackgroundYaxis = nil;
    _alphaBackgroundYaxis = 1.0;
    _displayDotsWhileAnimating = YES;

    // Set Alpha Values
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;

    // Set Size Values
    _widthLine = 1.0;
    _widthReferenceLines = 1.0;
    _sizePoint = 10.0;

    // Set Default Feature Values
    _enableTouchReport = NO;
    _touchReportFingersRequired = 1;
    _enablePopUpReport = NO;
    _enableBezierCurve = NO;
    _enableXAxisLabel = YES;
    _enableYAxisLabel = NO;
    _YAxisLabelXOffset = 0;
    _autoScaleYAxis = YES;
    _alwaysDisplayDots = NO;
    _alwaysDisplayPopUpLabels = NO;
    _enableLeftReferenceAxisFrameLine = YES;
    _enableBottomReferenceAxisFrameLine = YES;
    _formatStringForValues = @"%.0f";
    _interpolateNullValues = YES;
    _displayDotsOnly = NO;

    // Initialize the various arrays
    xAxisValues = [NSMutableArray array];
    xAxisLabelPoints = [NSMutableArray array];
    yAxisValues = [NSMutableArray array];
    yAxisLabelPoints = [NSMutableArray array];
    dataPoints = [NSMutableArray array];
    _xAxisLabels = [NSMutableArray array];
    _yAxisLabels = [NSMutableArray array];
    _permanentPopups = [NSMutableArray array];
    _circleDots = [NSMutableArray array];
    xAxisHorizontalFringeNegationValue = 0.0;


    // Initialize BEM Objects
    _averageLine = [[BEMAverageLine alloc] init];
}

- (void)drawGraph {
    // Let the delegate know that the graph began layout updates
    if ([self.delegate respondsToSelector:@selector(lineGraphDidBeginLoading:)])
        [self.delegate lineGraphDidBeginLoading:self];

    // Get the number of points in the graph
    [self layoutNumberOfPoints];

    if (numberOfPoints <= 1) {
        return;
    } else {
        // Draw the graph
        [self drawEntireGraph];

        // Setup the touch report
        [self layoutTouchReport];

        // Let the delegate know that the graph finished updates
        if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)])
            [self.delegate lineGraphDidFinishLoading:self];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGSizeEqualToSize(self.currentViewSize, self.bounds.size))  return;
    self.currentViewSize = self.bounds.size;

    [self drawGraph];
}

-(void) clearGraph {
    for (UIView * subvView in self.subviews) {
        [subvView removeFromSuperview];
    }
}

- (void)layoutNumberOfPoints {
    // Get the total number of data points from the delegate
#ifndef TARGET_INTERFACE_BUILDER
    if ([self.dataSource respondsToSelector:@selector(numberOfPointsInLineGraph:)]) {
        numberOfPoints = [self.dataSource numberOfPointsInLineGraph:self];
    } else {
        numberOfPoints = 0;
    }
#else
    numberOfPoints = 10;
#endif
    [self.noDataLabel removeFromSuperview];
    [self.oneDot  removeFromSuperview];

   if (numberOfPoints == 0) {
       // There are no points to load
        [self clearGraph];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(noDataLabelEnableForLineGraph:)] &&
            ![self.delegate noDataLabelEnableForLineGraph:self]) {
            return;
        }

        NSLog(@"[BEMSimpleLineGraph] Data source contains no data. A no data label will be displayed and drawing will stop. Add data to the data source and then reload the graph.");
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewForFirstBaselineLayout.frame.size.width, self.viewForFirstBaselineLayout.frame.size.height)];
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        NSString *noDataText = nil;
        if ([self.delegate respondsToSelector:@selector(noDataLabelTextForLineGraph:)]) {
            noDataText = [self.delegate noDataLabelTextForLineGraph:self];
        }
        self.noDataLabel.text = noDataText ?: NSLocalizedString(@"No Data", nil);
        self.noDataLabel.font = self.noDataLabelFont ?: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.noDataLabel.textColor = self.noDataLabelColor ?: (self.colorXaxisLabel ?: [UIColor blackColor]);

        [self.viewForFirstBaselineLayout addSubview:self.noDataLabel];

        // Let the delegate know that the graph finished layout updates
       if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)]) {
            [self.delegate lineGraphDidFinishLoading:self];
       }

    } else if (numberOfPoints == 1) {
        NSLog(@"[BEMSimpleLineGraph] Data source contains only one data point. Add more data to the data source and then reload the graph.");
        [self clearGraph];
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, self.sizePoint, self.sizePoint)];
        circleDot.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        circleDot.color = self.colorPoint;
        circleDot.alpha = 1.0f;

        [self.viewForFirstBaselineLayout addSubview:circleDot];
        self.oneDot = circleDot;

        // Let the delegate know that the graph finished layout updates
        if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)]) {
            [self.delegate lineGraphDidFinishLoading:self];
        }
        
    }
}

- (void)layoutTouchReport {
    // If the touch report is enabled, set it up
    if (self.enableTouchReport == YES || self.enablePopUpReport == YES) {
        // Initialize the vertical gray line that appears where the user touches the graph.
        if (!self.touchInputLine) {
            self.touchInputLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.widthTouchInputLine, self.frame.size.height)];
        }
        self.touchInputLine.alpha = 0;
        self.touchInputLine.backgroundColor = self.colorTouchInputLine;
        [self addSubview:self.touchInputLine];

        if (!self.panView) {
            self.panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.viewForFirstBaselineLayout.frame.size.width, self.viewForFirstBaselineLayout.frame.size.height)];
            self.panView.backgroundColor = [UIColor clearColor];

            self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureAction:)];
            self.panGesture.delegate = self;
            [self.panGesture setMaximumNumberOfTouches:1];
            [self.panView addGestureRecognizer:self.panGesture];

            self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureAction:)];
            self.longPressGesture.minimumPressDuration = 0.1f;
            [self.panView addGestureRecognizer:self.longPressGesture];
        }
        [self addSubview:self.panView];
    }
}

#pragma mark - Drawing

- (void)didFinishDrawingIncludingYAxis:(BOOL)yAxisFinishedDrawing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (self.animationGraphEntranceTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.enableYAxisLabel == NO) {
            // Let the delegate know that the graph finished rendering
            if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishDrawing:)])
                [self.delegate lineGraphDidFinishDrawing:self];
            return;
        } else {
            if (yAxisFinishedDrawing == YES) {
                // Let the delegate know that the graph finished rendering
                if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishDrawing:)])
                    [self.delegate lineGraphDidFinishDrawing:self];
                return;
            }
        }
    });
}

- (void)drawEntireGraph {
    // The following method calls are in this specific order for a reason
    // Changing the order of the method calls below can result in drawing glitches and even crashes

    self.averageLine.yValue = NAN;
#ifndef TARGET_INTERFACE_BUILDER
    self.maxValue = [self getMaximumValue];
    self.minValue = [self getMinimumValue];
#else
    self.minValue = 0.0f;
    self.maxValue = 10000.0f;
#endif
    // Set the Y-Axis Offset if the Y-Axis is enabled. The offset is relative to the size of the longest label on the Y-Axis.
    if (self.enableYAxisLabel) {
        self.YAxisLabelXOffset = 2.0f + [self calculateWidestLabel];
    } else {
        self.YAxisLabelXOffset = 0;
    }
    // Draw the X-Axis
    [self drawXAxis];

    // Draw the data points
    [self drawDots];

    // Draw line with bottom and top fill
    [self drawLine];

    // Draw the Y-Axis
    [self drawYAxis];
}

-(CGFloat) labelWidthForValue:(CGFloat) value {
    NSDictionary *attributes = @{NSFontAttributeName: self.labelFont};
    NSString *valueString = [self yAxisTextForValue:value];
    NSString *labelString = [valueString stringByReplacingOccurrencesOfString:@"[0-9-]" withString:@"N" options:NSRegularExpressionSearch range:NSMakeRange(0, [valueString length])];
    return [labelString sizeWithAttributes:attributes].width;
}

- (CGFloat) calculateWidestLabel {
    NSDictionary *attributes = @{NSFontAttributeName: self.labelFont};
    CGFloat widestNumber;
    if (self.autoScaleYAxis == YES){
        widestNumber = MAX([self labelWidthForValue:self.maxValue],
                           [self labelWidthForValue:self.minValue]);
    } else {
        widestNumber  = [self labelWidthForValue:self.frame.size.height] ;
    }
    if (self.averageLine.enableAverageLine) {
        return MAX(widestNumber,    [self.averageLine.title sizeWithAttributes:attributes].width);
    } else {
        return widestNumber;
    }
}


-(BEMCircle *) circleDotAtIndex:(NSUInteger) index forValue:(CGFloat) dotValue reuseNumber: (NSUInteger) reuseNumber {
    CGFloat positionOnXAxis = numberOfPoints > 1 ?
    (((self.frame.size.width - self.YAxisLabelXOffset) / (numberOfPoints - 1)) * index) :
    self.frame.size.width/2;
    if (self.positionYAxisRight == NO) {
        positionOnXAxis += self.YAxisLabelXOffset;
    }

    CGFloat positionOnYAxis = [self yPositionForDotValue:dotValue];

    [yAxisValues addObject:@(positionOnYAxis)];

    BEMCircle *circleDot = nil;
    if (reuseNumber < self.circleDots.count) {
        circleDot = self.circleDots[reuseNumber];
    }
    if (dotValue >= BEMNullGraphValue) {
        // If we're dealing with an null value, don't draw the dot (but put it in yAxis to interpolate line)
        [circleDot removeFromSuperview];
        return nil;
    }

    CGRect dotFrame = CGRectMake(0, 0, self.sizePoint, self.sizePoint);
    if (circleDot) {
        circleDot.frame = dotFrame;
        [circleDot setNeedsDisplay];
    } else {
        circleDot = [[BEMCircle alloc] initWithFrame:dotFrame];
        [self.circleDots addObject:circleDot];
    }

    circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
    circleDot.tag = (NSInteger) index + DotFirstTag100;
    circleDot.absoluteValue = dotValue;
    circleDot.color = self.colorPoint;

    return circleDot;

}

- (void)drawDots {

    // Remove all data points before adding them to the array
    [dataPoints removeAllObjects];

    // Remove all yAxis values before adding them to the array
    [yAxisValues removeAllObjects];

    // Loop through each point and add it to the graph
    @autoreleasepool {
        for (NSUInteger index = 0; index < numberOfPoints; index++) {
            CGFloat dotValue = 0;

#ifndef TARGET_INTERFACE_BUILDER
            if ([self.dataSource respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
                dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:index];

            } else {
                [NSException raise:@"lineGraph:valueForPointAtIndex: protocol method is not implemented in the data source. Throwing exception here before the system throws a CALayerInvalidGeometry Exception." format:@"Value for point %f at index %lu is invalid. CALayer position may contain NaN: [0 nan]", dotValue, (unsigned long)index];
            }
#else
            dotValue = (int)(arc4random() % 10000);
#endif
            [dataPoints addObject:@(dotValue)];

            BEMCircle * circleDot = [self circleDotAtIndex: index forValue: dotValue reuseNumber: index];
            UILabel * label = nil;
            if (index < self.permanentPopups.count) {
                label = self.permanentPopups[index];
            } else {
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [self.permanentPopups addObject:label ];
            }

            if (circleDot) {
                [self addSubview:circleDot];

                if ((self.alwaysDisplayPopUpLabels == YES)  &&
                    (![self.delegate respondsToSelector:@selector(lineGraph:alwaysDisplayPopUpAtIndex:)] ||
                      [self.delegate lineGraph:self alwaysDisplayPopUpAtIndex:index])) {
                    label = [self configureLabel:label forPoint: circleDot ];

                    [self adjustXLocForLabel:label avoidingDot:circleDot.frame];

                    UILabel * leftNeighbor = (index >= 1 && self.permanentPopups[index-1].superview) ? self.permanentPopups[index-1] : nil;
                    UILabel * secondNeighbor = (index >= 2 && self.permanentPopups[index-2].superview) ? self.permanentPopups[index-2] : nil;
                    BOOL showLabel =  [self adjustYLocForLabel:label
                                                   avoidingDot:circleDot.frame
                                                  andNeighbors:leftNeighbor.frame
                                                           and:secondNeighbor.frame ];
                    if (showLabel) {
                        [self addSubview:label];
                    } else {
                        [label removeFromSuperview];
                    }
                } else {
                    //not showing labels this time, so remove if any
                    [label removeFromSuperview];
                }

                // Dot and/or label entrance animation
                circleDot.alpha = 0.0f;
                label.alpha = 0.0f;
                if (self.animationGraphEntranceTime <= 0) {
                    if (self.displayDotsOnly || self.alwaysDisplayDots ) {
                        circleDot.alpha = 1.0f;
                    }
                    label.alpha = 1.0f;
                } else if (self.displayDotsWhileAnimating) {
                    [UIView animateWithDuration: self.animationGraphEntranceTime/numberOfPoints delay: index*(self.animationGraphEntranceTime/numberOfPoints) options:UIViewAnimationOptionCurveLinear animations:^{
                        circleDot.alpha = 1.0;
                        label.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
                            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                circleDot.alpha = 0;
                            } completion:nil];
                        }
                    }];
                } else if (label) {
                    [UIView animateWithDuration:0.5f delay:self.animationGraphEntranceTime options:UIViewAnimationOptionCurveLinear animations:^{
                        label.alpha = 1;
                    } completion:nil];
                }

            } else {
                [label removeFromSuperview];
            }
        }
        for (NSUInteger i = self.circleDots.count -1; i>=numberOfPoints; i--) {
            [[self.permanentPopups lastObject] removeFromSuperview]; //no harm if not showing
            [self.permanentPopups removeLastObject];
            [[self.circleDots lastObject] removeFromSuperview];
            [self.circleDots removeLastObject];
        }
    }
}

- (void)drawLine {
    if (!self.masterLine) {
        self.masterLine = [[BEMLine alloc] initWithFrame:[self drawableGraphArea]];
    } else {
        self.masterLine.frame = [self drawableGraphArea];
        [self.masterLine setNeedsDisplay];
    }
    [self addSubview:self.masterLine];
    BEMLine * line = self.masterLine;
    line.opaque = NO;
    line.alpha = 1;
    line.backgroundColor = [UIColor clearColor];
    line.topColor = self.colorTop;
    line.bottomColor = self.colorBottom;
    line.topAlpha = self.alphaTop;
    line.bottomAlpha = self.alphaBottom;
    line.topGradient = self.gradientTop;
    line.bottomGradient = self.gradientBottom;
    line.lineWidth = self.widthLine;
    line.referenceLineWidth = self.widthReferenceLines > 0.0 ? self.widthReferenceLines : (self.widthLine/2);
    line.lineAlpha = self.alphaLine;
    line.bezierCurveIsEnabled = self.enableBezierCurve;
    line.arrayOfPoints = yAxisValues;
    line.arrayOfValues = self.graphValuesForDataPoints;
    line.lineDashPatternForReferenceYAxisLines = self.lineDashPatternForReferenceYAxisLines;
    line.lineDashPatternForReferenceXAxisLines = self.lineDashPatternForReferenceXAxisLines;
    line.interpolateNullValues = self.interpolateNullValues;

    line.enableReferenceFrame = self.enableReferenceAxisFrame;
    line.enableRightReferenceFrameLine = self.enableRightReferenceAxisFrameLine;
    line.enableTopReferenceFrameLine = self.enableTopReferenceAxisFrameLine;
    line.enableLeftReferenceFrameLine = self.enableLeftReferenceAxisFrameLine;
    line.enableBottomReferenceFrameLine = self.enableBottomReferenceAxisFrameLine;

    if (self.enableReferenceXAxisLines || self.enableReferenceYAxisLines) {
        line.enableReferenceLines = YES;
        line.referenceLineColor = self.colorReferenceLines;
        line.verticalReferenceHorizontalFringeNegation = xAxisHorizontalFringeNegationValue;
        line.arrayOfVerticalReferenceLinePoints = self.enableReferenceXAxisLines ? xAxisLabelPoints : nil;
        line.arrayOfHorizontalReferenceLinePoints = self.enableReferenceYAxisLines ? yAxisLabelPoints : nil;
    } else {
        line.enableReferenceLines = NO;
    }

    line.color = self.colorLine;
    line.lineGradient = self.gradientLine;
    line.lineGradientDirection = self.gradientLineDirection;
    line.animationTime = self.animationGraphEntranceTime;
    line.animationType = self.animationGraphStyle;

    if (self.averageLine.enableAverageLine == YES) {
        if (isnan(self.averageLine.yValue)) self.averageLine.yValue = self.getAverageValue;
        line.averageLineYCoordinate = [self yPositionForDotValue:self.averageLine.yValue];
    }
    line.averageLine = self.averageLine;

    line.disableMainLine = self.displayDotsOnly;

    [self sendSubviewToBack:line];
    [self sendSubviewToBack:self.backgroundXAxis];

    [self didFinishDrawingIncludingYAxis:NO];
}

- (void)drawXAxis {
    if (!self.enableXAxisLabel) {
        [self.backgroundXAxis removeFromSuperview];
        self.backgroundXAxis = nil;
        for (UILabel * label in self.xAxisLabels) {
            [label removeFromSuperview];
        }
        self.xAxisLabels = [NSMutableArray array];
        return;
    }
    if (![self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) return;

    [xAxisValues removeAllObjects];
    [xAxisLabelPoints removeAllObjects];

    xAxisHorizontalFringeNegationValue = 0.0;

    // Draw X-Axis Background Area
    if (!self.backgroundXAxis) {
        self.backgroundXAxis = [[UIView alloc] initWithFrame:[self drawableXAxisArea]];
    } else {
        self.backgroundXAxis.frame = [self drawableXAxisArea];
    }
    [self addSubview:self.backgroundXAxis];

    if (self.colorBackgroundXaxis) {
        self.backgroundXAxis.backgroundColor = self.colorBackgroundXaxis;
        self.backgroundXAxis.alpha = self.alphaBackgroundXaxis;
    } else {
        self.backgroundXAxis.backgroundColor = self.colorBottom;
        self.backgroundXAxis.alpha = self.alphaBottom;
    }

    NSArray <NSNumber *> *axisIndices = nil;
    if ([self.delegate respondsToSelector:@selector(incrementPositionsForXAxisOnLineGraph:)]) {
        axisIndices = [self.delegate incrementPositionsForXAxisOnLineGraph:self];
    } else {
        NSUInteger baseIndex = 0;
        NSUInteger increment = 1;
        if ([self.delegate respondsToSelector:@selector(baseIndexForXAxisOnLineGraph:)] && [self.delegate respondsToSelector:@selector(incrementIndexForXAxisOnLineGraph:)]) {
            baseIndex = [self.delegate baseIndexForXAxisOnLineGraph:self];
            increment = [self.delegate incrementIndexForXAxisOnLineGraph:self];
        } else if ([self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)]) {
            increment = [self.delegate numberOfGapsBetweenLabelsOnLineGraph:self] + 1;
            if (increment >= numberOfPoints -1) {
                //need at least two points
                baseIndex = 0;
                increment = numberOfPoints - 1;
            } else {
                NSUInteger leftGap = increment - 1;
                NSUInteger rightGap = numberOfPoints % increment;
                NSUInteger offset = (leftGap-rightGap)/2;
                baseIndex = increment - 1 - offset;
            }
        }
        if (increment == 0) increment = 1;
        NSMutableArray <NSNumber *> *values = [NSMutableArray array ];
        NSUInteger index = baseIndex;
        while (index < numberOfPoints) {
            [values addObject:@(index)];
            index += increment;
        }
        axisIndices = [values copy];
    }

    NSUInteger xAxisLabelNumber = 0;
    @autoreleasepool {
        for (NSNumber *indexNum in axisIndices) {
            NSUInteger index = indexNum.unsignedIntegerValue;
            if (index > numberOfPoints) continue;
            NSString *xAxisLabelText = [self xAxisTextForIndex:index];

            UILabel *labelXAxis = [self xAxisLabelWithText:xAxisLabelText atIndex:index reuseNumber: xAxisLabelNumber];

            [xAxisLabelPoints addObject:@(labelXAxis.center.x - (self.positionYAxisRight ? 0.0f : self.YAxisLabelXOffset))];

            [self addSubview:labelXAxis];
            [xAxisValues addObject:xAxisLabelText];
            xAxisLabelNumber++;
        }
    }
    for (NSUInteger i = self.xAxisLabels.count ; i>xAxisLabelNumber; i--) {
        [[self.xAxisLabels lastObject] removeFromSuperview];
        [self.xAxisLabels removeLastObject];
    }

    __block UILabel *prevLabel;

    NSMutableArray <UILabel *> *overlapLabels = [NSMutableArray arrayWithCapacity:self.xAxisLabels.count];
    [self.xAxisLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            prevLabel = label; //always show first label
        } else if (label.superview) { //only look at active labels
            if (CGRectIsNull(CGRectIntersection(prevLabel.frame, label.frame)) &&
                CGRectContainsRect(self.backgroundXAxis.frame, label.frame)) {
                prevLabel = label;  //no overlap and inside frame, so show this one
            } else {
                //                NSLog(@"Not showing %@ due to %@; label: %@, width: %@ prevLabel: %@, frame: %@",
                //                      label.text,
                //                      CGRectIsNull(CGRectIntersection(prevLabel.frame, label.frame)) ?@"Overlap" : @"Out of bounds",
                //                      NSStringFromCGRect(label.frame),
                //                      @(CGRectGetMaxX(label.frame)),
                //                      NSStringFromCGRect(prevLabel.frame),
                //                      NSStringFromCGRect(self.backgroundXAxis.frame));
                [overlapLabels addObject:label]; // Overlapped
            }
        }
    }];

    for (UILabel *l in overlapLabels) {
        [l removeFromSuperview];
    }
}

- (NSString *)xAxisTextForIndex:(NSUInteger)index {
    NSString *xAxisLabelText = @"";

    if ([self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
        xAxisLabelText = [self.dataSource lineGraph:self labelOnXAxisForIndex:index];
    } else {
        xAxisLabelText = @"";
    }

    return xAxisLabelText;
}

- (UILabel *)xAxisLabelWithText:(NSString *)text atIndex:(NSUInteger)index reuseNumber:(NSUInteger) xAxisLabelNumber{
    UILabel *labelXAxis;
    if (xAxisLabelNumber < self.xAxisLabels.count) {
        labelXAxis = self.xAxisLabels[xAxisLabelNumber];
    } else {
        labelXAxis = [[UILabel alloc] init];
        [self.xAxisLabels addObject:labelXAxis];
    }

    labelXAxis.text = text;
    labelXAxis.font = self.labelFont;
    labelXAxis.textAlignment = 1;
    labelXAxis.textColor = self.colorXaxisLabel;
    labelXAxis.backgroundColor = [UIColor clearColor];

    // Add support multi-line, but this might overlap with the graph line if text have too many lines
    labelXAxis.numberOfLines = 0;
    CGRect lRect = [labelXAxis.text boundingRectWithSize:self.viewForFirstBaselineLayout.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelXAxis.font} context:nil];

    // Determine the horizontal translation to perform on the far left and far right labels
    // This property is negated when calculating the position of reference frames
    CGFloat horizontalTranslation = 0;
    if (index == 0) {
        horizontalTranslation = lRect.size.width/2;
    } else if (index+1 == numberOfPoints) {
        horizontalTranslation = -lRect.size.width/2;
    }
    xAxisHorizontalFringeNegationValue = horizontalTranslation;

    // Determine the final x-axis position
    CGFloat positionOnXAxis =  (((self.frame.size.width - self.YAxisLabelXOffset) / (numberOfPoints - 1)) * index) + horizontalTranslation;
    if (!self.positionYAxisRight) {
        positionOnXAxis += self.YAxisLabelXOffset;
    }

    labelXAxis.frame = lRect;
    labelXAxis.center = CGPointMake(positionOnXAxis, self.frame.size.height - lRect.size.height/2.0f-1.0f);
    return labelXAxis;
}

-(NSString *) yAxisTextForValue:(CGFloat) value {
    NSString *yAxisSuffix = @"";
    NSString *yAxisPrefix = @"";

    if ([self.delegate respondsToSelector:@selector(yAxisPrefixOnLineGraph:)]) yAxisPrefix = [self.delegate yAxisPrefixOnLineGraph:self];
    if ([self.delegate respondsToSelector:@selector(yAxisSuffixOnLineGraph:)]) yAxisSuffix = [self.delegate yAxisSuffixOnLineGraph:self];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"
    NSString *formattedValue = [NSString stringWithFormat:self.formatStringForValues, value];
#pragma clang diagnostic pop

    return [NSString stringWithFormat:@"%@%@%@", yAxisPrefix, formattedValue, yAxisSuffix];
}

- (UILabel *)yAxisLabelWithText:(NSString *)text atValue:(CGFloat)value reuseNumber:(NSUInteger) reuseNumber {
    //provide a Y-Axis Label with text at Value, reusing reuseNumber'd label if it exists
    //special case: use self.Averageline.label if reuseNumber = NSIntegerMax
    CGFloat labelHeight = self.labelFont.pointSize + 7.0f;
    CGRect frameForLabelYAxis = CGRectMake(1.0f, 0.0f, self.YAxisLabelXOffset - 1.0f, labelHeight);

    CGFloat xValueForCenterLabelYAxis = (self.YAxisLabelXOffset-1.0f) /2.0f;
    NSTextAlignment textAlignmentForLabelYAxis = NSTextAlignmentRight;
    if (self.positionYAxisRight) {
        frameForLabelYAxis.origin = CGPointMake(self.frame.size.width - self.YAxisLabelXOffset - 1.0f, 0.0f);
        xValueForCenterLabelYAxis = self.frame.size.width - xValueForCenterLabelYAxis-2.0f;
    }

    UILabel *labelYAxis;
    if ( reuseNumber == NSIntegerMax) {
        if (!self.averageLine.label) {
            self.averageLine.label = [[UILabel alloc] initWithFrame:frameForLabelYAxis];
        }
        labelYAxis = self.averageLine.label;
    } else if (reuseNumber < self.yAxisLabels.count) {
        labelYAxis = self.yAxisLabels[reuseNumber];
    } else {
        labelYAxis = [[UILabel alloc] initWithFrame:frameForLabelYAxis];
        [self.yAxisLabels addObject:labelYAxis];
    }
    labelYAxis.frame = frameForLabelYAxis;
    labelYAxis.text = text;
    labelYAxis.textAlignment = textAlignmentForLabelYAxis;
    labelYAxis.font = self.labelFont;
    labelYAxis.textColor = self.colorYaxisLabel;
    labelYAxis.backgroundColor = [UIColor clearColor];
    CGFloat yAxisPosition = [self yPositionForDotValue:value];
    labelYAxis.center = CGPointMake(xValueForCenterLabelYAxis, yAxisPosition);

    NSNumber *yAxisLabelCoordinate = @(labelYAxis.center.y);
    [yAxisLabelPoints addObject:yAxisLabelCoordinate];
    return labelYAxis;
}

- (void)drawYAxis {
    if (!self.enableYAxisLabel) {
        [self.backgroundYAxis removeFromSuperview];
        self.backgroundYAxis = nil;
        [self.averageLine.label removeFromSuperview];
        self.averageLine.label = nil;
        for (UILabel * label in self.yAxisLabels) {
            [label removeFromSuperview];
        }
        self.yAxisLabels = [NSMutableArray array];
        return;
    }

    //Make Background for Y Axis
    CGRect frameForBackgroundYAxis = CGRectMake(
                                                (self.positionYAxisRight ?
                                                 self.frame.size.width - self.YAxisLabelXOffset - 1.0f:
                                                 0.0),
                                                0,
                                                self.YAxisLabelXOffset,
                                                self.frame.size.height);

    if (!self.backgroundYAxis) {
        self.backgroundYAxis= [[UIView alloc] initWithFrame:frameForBackgroundYAxis];
    } else {
        self.backgroundYAxis.frame = frameForBackgroundYAxis;
    }
    [self addSubview:self.backgroundYAxis];
    if (self.colorBackgroundYaxis) {
        self.backgroundYAxis.backgroundColor = self.colorBackgroundYaxis;
        self.backgroundYAxis.alpha = self.alphaBackgroundYaxis;
    } else {
        self.backgroundYAxis.backgroundColor =  self.colorTop;
        self.backgroundYAxis.alpha = self.alphaTop;
    }

    [yAxisLabelPoints removeAllObjects];

    NSUInteger numberOfLabels = 3;
    if ([self.delegate respondsToSelector:@selector(numberOfYAxisLabelsOnLineGraph:)]) {
        numberOfLabels = [self.delegate numberOfYAxisLabelsOnLineGraph:self];
        if (numberOfLabels <= 0) return;
    }

    //Now calculate baseValue and increment for all scenarios
    CGFloat value;
    CGFloat increment;
    if (self.autoScaleYAxis) {
        // Plot according to min-max range

        if (numberOfLabels == 1) {
            value = (self.minValue + self.maxValue)/2.0f;
            increment = 0; //NA
        } else {
            value = self.minValue;
            increment = (self.maxValue - self.minValue)/(numberOfLabels-1);
            if ([self.delegate respondsToSelector:@selector(baseValueForYAxisOnLineGraph:)] && [self.delegate respondsToSelector:@selector(incrementValueForYAxisOnLineGraph:)]) {
                value = [self.delegate baseValueForYAxisOnLineGraph:self];
                increment = [self.delegate incrementValueForYAxisOnLineGraph:self];
                if (increment <= 0) increment = 1;
                numberOfLabels = (NSUInteger) ((self.maxValue - value)/increment)+1;
                if (numberOfLabels > 100) {
                    NSLog(@"[BEMSimpleLineGraph] Increment does not properly lay out Y axis, bailing early");
                    return;
                }
            }
        }
    } else {
        //not AutoScale
        CGFloat graphHeight = self.frame.size.height - self.XAxisLabelYOffset;
        if (numberOfLabels == 1) {
            value = graphHeight/2.0f;
            increment = 0; //NA
        } else {
            increment = graphHeight / numberOfLabels;
            value = increment/2;
        }
    }
    NSMutableArray <NSNumber *> *dotValues = [[NSMutableArray alloc] initWithCapacity:numberOfLabels];
    for (NSUInteger i = 0; i < numberOfLabels; i++) {
        [dotValues addObject:@(value)];
        value += increment;
    }
    NSUInteger yAxisLabelNumber = 0;
    @autoreleasepool {
        for (NSNumber *dotValueNum in dotValues) {
            CGFloat dotValue = dotValueNum.floatValue;
            NSString *labelText = [self yAxisTextForValue:dotValue];
            UILabel *labelYAxis = [self yAxisLabelWithText:labelText
                                                   atValue:dotValue
                                               reuseNumber:yAxisLabelNumber];

            [self addSubview:labelYAxis];
            yAxisLabelNumber++;
        }
    }

    for (NSUInteger i = self.yAxisLabels.count -1; i>=yAxisLabelNumber; i--) {
        [[self.yAxisLabels lastObject] removeFromSuperview];
        [self.yAxisLabels removeLastObject];
    }

    // Detect overlapped labels
    __block UILabel * prevLabel = nil;;
    NSMutableArray <UILabel *> *overlapLabels = [NSMutableArray arrayWithCapacity:0];

    [self.yAxisLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {

        if (idx == 0) {
            prevLabel = label; //always show first label
        } else if (label.superview) { //only look at active labels
            if (CGRectIsNull(CGRectIntersection(prevLabel.frame, label.frame)) &&
                CGRectContainsRect(self.backgroundYAxis.frame, label.frame)) {
                prevLabel = label;  //no overlap and inside frame, so show this one
            } else {
                [overlapLabels addObject:label]; // Overlapped
                                                 //                NSLog(@"Not showing %@ due to %@; label: %@, width: %@ prevLabel: %@, frame: %@",
                                                 //                      label.text,
                                                 //                      CGRectIsNull(CGRectIntersection(prevLabel.frame, label.frame)) ?@"Overlap" : @"Out of bounds",
                                                 //                      NSStringFromCGRect(label.frame),
                                                 //                      @(CGRectGetMaxX(label.frame)),
                                                 //                      NSStringFromCGRect(prevLabel.frame),
                                                 //                      NSStringFromCGRect(self.backgroundXAxis.frame));
            }
        }
    }];


    if (self.averageLine.enableAverageLine && self.averageLine.title.length > 0) {

        UILabel *averageLabel = [self yAxisLabelWithText:self.averageLine.title
                                                 atValue:self.averageLine.yValue
                                             reuseNumber:NSIntegerMax];

        [self addSubview:averageLabel];

        //check for overlap; Average wins
        for (UILabel * label in self.yAxisLabels) {
            if (! CGRectIsNull(CGRectIntersection(averageLabel.frame, label.frame))) {
                [overlapLabels addObject:label];
            }
        }
    }

    for (UILabel *label in overlapLabels) {
        [label removeFromSuperview];
    }

    [self didFinishDrawingIncludingYAxis:YES];
}

/// Area on the graph that doesn't include the axes
- (CGRect) drawableGraphArea {
    //  CGRectMake(xAxisXPositionFirstOffset, self.frame.size.height-20, viewWidth/2, 20);
    CGFloat xAxisHeight = self.enableXAxisLabel ?  self.labelFont.pointSize + 8.0f : 0.0f;
    CGFloat xOrigin = self.positionYAxisRight ? 0 : self.YAxisLabelXOffset;
    CGFloat viewWidth = self.frame.size.width - self.YAxisLabelXOffset;
    CGFloat adjustedHeight = self.bounds.size.height - xAxisHeight;

    CGRect rect = CGRectMake(xOrigin, 0, viewWidth, adjustedHeight);
    return rect;
}

- (CGRect)drawableXAxisArea {
    CGFloat xAxisHeight = self.labelFont.pointSize + 8.0f;
    CGFloat xAxisWidth = [self drawableGraphArea].size.width + 1;
    CGFloat xAxisXOrigin = self.positionYAxisRight ? 0 : self.YAxisLabelXOffset;
    CGFloat xAxisYOrigin = self.bounds.size.height - xAxisHeight;
    return CGRectMake(xAxisXOrigin, xAxisYOrigin, xAxisWidth, xAxisHeight);
}

- (UILabel *)configureLabel: (UILabel *) oldLabel forPoint: (BEMCircle *)circleDot  {

    UILabel *newPopUpLabel = oldLabel;
    if ( !newPopUpLabel) {
        newPopUpLabel =[[UILabel alloc] init];
        newPopUpLabel.alpha = 0;
    }

    newPopUpLabel.textAlignment = NSTextAlignmentCenter;
    newPopUpLabel.numberOfLines = 0;
    newPopUpLabel.font = self.labelFont;
    newPopUpLabel.backgroundColor = [UIColor clearColor];
    newPopUpLabel.layer.backgroundColor = [self.colorBackgroundPopUplabel colorWithAlphaComponent:0.7f].CGColor;
    newPopUpLabel.layer.cornerRadius = 6;

    NSUInteger index = (NSUInteger) circleDot.tag - DotFirstTag100;

    // Populate the popup label text with values
    newPopUpLabel.text = nil;
    if ([self.delegate respondsToSelector:@selector(popUpTextForlineGraph:atIndex:)]) newPopUpLabel.text = [self.delegate popUpTextForlineGraph:self atIndex:index];

    // If the supplied popup label text is nil we can proceed to fill out the text using suffixes, prefixes, and the graph's data source.
    if (newPopUpLabel.text == nil) {
        NSString *prefix = @"";
        NSString *suffix = @"";

        if ([self.delegate respondsToSelector:@selector(popUpSuffixForlineGraph:)])
            suffix = [self.delegate popUpSuffixForlineGraph:self];

        if ([self.delegate respondsToSelector:@selector(popUpPrefixForlineGraph:)])
            prefix = [self.delegate popUpPrefixForlineGraph:self];

        NSNumber *value = (index <= dataPoints.count) ? value = dataPoints[index] : @(0); // @((NSInteger) circleDot.absoluteValue)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"
        //note this can indeed crash if delegate provides junk for formatString (e.g. %@); try/catch doesn't work
        NSString *formattedValue = [NSString stringWithFormat:self.formatStringForValues, value.doubleValue];
#pragma clang diagnostic pop
        newPopUpLabel.text = [NSString stringWithFormat:@"%@%@%@", prefix, formattedValue, suffix];
    }
    CGSize requiredSize = [newPopUpLabel sizeThatFits:CGSizeMake(100.0f, CGFLOAT_MAX)];
    newPopUpLabel.frame = CGRectMake(10, 10, requiredSize.width+10.0f, requiredSize.height+10.0f);
    return newPopUpLabel;
}

-(void) adjustXLocForLabel: (UIView *) popUpLabel avoidingDot: (CGRect) circleDotFrame {

    //now fixup left/right layout issues
    CGFloat xCenter = CGRectGetMidX(circleDotFrame);
    CGFloat halfLabelWidth = popUpLabel.frame.size.width/2 ;
    if (self.enableYAxisLabel && !self.positionYAxisRight && ((xCenter - halfLabelWidth) <= self.YAxisLabelXOffset) ) {
        //When bumping into left Y axis
        xCenter = halfLabelWidth + self.YAxisLabelXOffset + 4.0f;
    } else if (self.enableYAxisLabel && self.positionYAxisRight && (xCenter + halfLabelWidth >= self.frame.size.width - self.YAxisLabelXOffset)) {
        //When bumping into right Y axis
        xCenter = self.frame.size.width - halfLabelWidth  - self.YAxisLabelXOffset - 4.0f;
    } else if (xCenter - halfLabelWidth <= 0) {
        //When over left edge
        xCenter = halfLabelWidth + 4.0f;
    } else if (xCenter + halfLabelWidth >= self.frame.size.width) {
        //When over right edge
        xCenter = self.frame.size.width - halfLabelWidth;
    }
    popUpLabel.center = CGPointMake(xCenter, popUpLabel.center.y);
}

-(BOOL) adjustYLocForLabel: (UIView *) popUpLabel avoidingDot: (CGRect) dotFrame andNeighbors: (CGRect) leftNeightbor and:  (CGRect) secondNeighbor {
    //returns YES if it can avoid those neighbors
    //note: nil.frame == CGRectZero
    //check for bumping into top OR overlap with left neighbors
    //default Y is above point
    CGFloat halfLabelHeight = popUpLabel.frame.size.height/2.0f;
    popUpLabel.center = CGPointMake(popUpLabel.center.x, CGRectGetMinY(dotFrame) - 12.0f - halfLabelHeight );
    if (CGRectGetMinY(popUpLabel.frame) < 2.0f ||
        (!CGRectIsEmpty(CGRectIntersection(popUpLabel.frame, leftNeightbor))) ||
        (!CGRectIsEmpty(CGRectIntersection(popUpLabel.frame, secondNeighbor)))) {
        //if so, try below point instead
        CGRect frame = popUpLabel.frame;
        frame.origin.y = CGRectGetMaxY(dotFrame)+12.0f;
        popUpLabel.frame = frame;
        //check for bottom and again for overlap with neighbor and even neighbor second to the left
        if (CGRectGetMaxY(frame) > (self.frame.size.height - self.XAxisLabelYOffset) ||
            (!CGRectIsEmpty(CGRectIntersection(popUpLabel.frame, leftNeightbor))) ||
            (!CGRectIsEmpty(CGRectIntersection(popUpLabel.frame, secondNeighbor)))) {
            return NO;
        }
    }
    return YES;
}


- (UIImage *)graphSnapshotImage {
    return [self graphSnapshotImageRenderedWhileInBackground:NO];
}

- (UIImage *)graphSnapshotImageRenderedWhileInBackground:(BOOL)appIsInBackground {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);

    if (appIsInBackground == NO) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) [self.layer renderInContext:context];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Data Source

- (void)reloadGraph {
    [self drawGraph];
    //    [self setNeedsLayout];
}

#pragma mark - Values

- (NSArray <NSString *> *)graphValuesForXAxis {
    return xAxisValues;
}

- (NSArray <NSNumber *> *)graphValuesForDataPoints {
    return dataPoints;
}

- (NSArray <UILabel *> *)graphLabelsForXAxis {
    return self.xAxisLabels;
}

- (NSArray <UILabel *> *)graphLabelsForYAxis {
    return self.yAxisLabels;
}

- (void)setAnimationGraphStyle:(BEMLineAnimation)animationGraphStyle {
    _animationGraphStyle = animationGraphStyle;
    if (_animationGraphStyle == BEMLineAnimationNone)
        self.animationGraphEntranceTime = 0.f;
}


#pragma mark - Touch Gestures

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.panGesture]) {
        if (gestureRecognizer.numberOfTouches >= self.touchReportFingersRequired) {
            CGPoint translation = [self.panGesture velocityInView:self.panView];
            return fabs(translation.y) < fabs(translation.x);
        } else {
            return NO;
        }
        return YES;
    } else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)handleGestureAction:(UIGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForFirstBaselineLayout];

    if (!((translation.x + self.frame.origin.x) <= self.frame.origin.x) && !((translation.x + self.frame.origin.x) >= self.frame.origin.x + self.frame.size.width)) { // To make sure the vertical line doesn't go beyond the frame of the graph.
        self.touchInputLine.frame = CGRectMake(translation.x - self.widthTouchInputLine/2, 0, self.widthTouchInputLine, self.frame.size.height);
    }

    self.touchInputLine.alpha = self.alphaTouchInputLine;

    BEMCircle *closestDot = [self closestDotFromTouchInputLine:self.touchInputLine];
    NSUInteger index = 0;
    if (closestDot.tag > DotFirstTag100) {
        index = closestDot.tag - DotFirstTag100;
    } else {
        if (numberOfPoints == 0) return; //something's very wrong
    }
    closestDot.alpha = 0.8f;

    if (recognizer.state != UIGestureRecognizerStateEnded) {
        //ON START OR MOVE
        if (self.enablePopUpReport == YES  && self.alwaysDisplayPopUpLabels == NO) {
            if (!self.customPopUpView && [self.delegate respondsToSelector:@selector(popUpViewForLineGraph:)] ) {
                self.customPopUpView = [self.delegate popUpViewForLineGraph:self];
            }
            if (self.customPopUpView) {
                [self addSubview:self.customPopUpView];
                [self adjustXLocForLabel:self.customPopUpView avoidingDot:closestDot.frame];
                [self adjustYLocForLabel:self.customPopUpView avoidingDot:closestDot.frame andNeighbors:CGRectZero and:CGRectZero];
                if ([self.delegate respondsToSelector:@selector(lineGraph:modifyPopupView:forIndex:)]) {
                    self.customPopUpView.alpha = 1.0f;
                    [self.delegate lineGraph:self modifyPopupView:self.customPopUpView forIndex:index];
                } else {
                    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.customPopUpView.alpha = 1.0f;
                    } completion:nil];
                }
            } else {
                if (!self.popUpLabel) {
                    self.popUpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                }
                [self addSubview: self.popUpLabel ];
                self.popUpLabel = [self configureLabel:self.popUpLabel forPoint:closestDot];
                [self adjustXLocForLabel:self.popUpLabel avoidingDot:closestDot.frame];
                [self adjustYLocForLabel:self.popUpLabel avoidingDot:closestDot.frame andNeighbors:CGRectZero and:CGRectZero];
                [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.popUpLabel.alpha = 1.0f;
                } completion:nil];
            }
        }

        if (self.enableTouchReport && [self.delegate respondsToSelector:@selector(lineGraph:didTouchGraphWithClosestIndex:)]) {
            [self.delegate lineGraph:self didTouchGraphWithClosestIndex:index];
        }
    } else {
        // ON RELEASE
        if (self.enableTouchReport && [self.delegate respondsToSelector:@selector(lineGraph:didReleaseTouchFromGraphWithClosestIndex:)]) {
            [self.delegate lineGraph:self didReleaseTouchFromGraphWithClosestIndex:index];
        }

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
                closestDot.alpha = 0;
            }
            self.touchInputLine.alpha = 0;
            self.popUpLabel.alpha = 0;
            self.customPopUpView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.customPopUpView removeFromSuperview];
            self.customPopUpView = nil;
        }];
    }
}

#pragma mark - Graph Calculations

- (BEMCircle *)closestDotFromTouchInputLine:(UIView *)touchInputLine {
    BEMCircle * closestDot = nil;
    CGFloat currentlyCloser = CGFLOAT_MAX;
    for (BEMCircle *point in self.circleDots) {
        if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
            point.alpha = 0;
        }
        CGFloat distance = (CGFloat)fabs(point.center.x - touchInputLine.center.x) ;
        if (distance < currentlyCloser) {
            currentlyCloser = distance;
            closestDot = point;
        }
    }
    return closestDot;
}

- (CGFloat)getMaximumValue {
    if ([self.delegate respondsToSelector:@selector(maxValueForLineGraph:)]) {
        return [self.delegate maxValueForLineGraph:self];
    } else {
        CGFloat maxValue = -FLT_MAX;

        @autoreleasepool {
            for (NSUInteger i = 0; i < numberOfPoints; i++) {
                CGFloat dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
                if (dotValue >= BEMNullGraphValue) continue;
                if (dotValue > maxValue) maxValue = dotValue;
            }
        }
        return maxValue;
    }
}

- (CGFloat)getMinimumValue {
    if ([self.delegate respondsToSelector:@selector(minValueForLineGraph:)]) {
        return [self.delegate minValueForLineGraph:self];
    } else {
        CGFloat minValue = INFINITY;

        @autoreleasepool {
            for (NSUInteger i = 0; i < numberOfPoints; i++) {
                CGFloat dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
                if (dotValue >= BEMNullGraphValue) continue;
                if (dotValue < minValue) minValue = dotValue;
            }
        }
        return minValue;
    }
}
- (CGFloat)getAverageValue {
    if ([self.delegate respondsToSelector:@selector(averageValueForLineGraph:)]) {
        return [self.delegate averageValueForLineGraph:self];
    } else {
        CGFloat sumValue = 0.0f;
        int numPoints = 0;
        @autoreleasepool {
            for (NSUInteger i = 0; i < numberOfPoints; i++) {
                CGFloat dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
                if (dotValue >= BEMNullGraphValue) continue;
                sumValue += dotValue;
                numPoints++;
            }
        }
        if (numPoints > 0) {
            return sumValue/numPoints;
        } else {
            return NAN;
        }
    }
}

- (CGFloat)yPositionForDotValue:(CGFloat)dotValue {
    if (isnan(dotValue) || dotValue >= BEMNullGraphValue) {
        return BEMNullGraphValue;
    }

    CGFloat positionOnYAxis; // The position on the Y-axis of the point currently being created.
    CGFloat padding = MIN(90.0f,self.frame.size.height/2);

    if ([self.delegate respondsToSelector:@selector(staticPaddingForLineGraph:)]) {
        padding = [self.delegate staticPaddingForLineGraph:self];
    }

    self.XAxisLabelYOffset = self.enableXAxisLabel ? self.backgroundXAxis.frame.size.height : 0.0f;

    if (self.autoScaleYAxis) {
        if (self.minValue >= self.maxValue ) {
            positionOnYAxis = self.frame.size.height/2.0f;
        } else {
            CGFloat percentValue = (dotValue - self.minValue) / (self.maxValue - self.minValue);
            CGFloat topOfChart = self.frame.size.height - padding/2.0f;
            CGFloat sizeOfChart = self.frame.size.height - padding;
            positionOnYAxis = topOfChart - percentValue * sizeOfChart + self.XAxisLabelYOffset;
        }
    } else {
        positionOnYAxis = ((self.frame.size.height) - dotValue);
    }
    positionOnYAxis -= self.XAxisLabelYOffset;
    
    return positionOnYAxis;
}

#pragma mark - Deprecated Methods


 - (NSNumber *)calculatePointValueSum {
    [self printDeprecationTransitionWarningForOldMethod:@"calculatePointValueSum" replacementMethod:@"calculatePointValueSumOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculatePointValueSumOnGraph:self];
}

- (NSNumber *)calculatePointValueMode {
    [self printDeprecationTransitionWarningForOldMethod:@"calculatePointValueMode" replacementMethod:@"calculatePointValueModeOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculatePointValueModeOnGraph:self];
}

- (NSNumber *)calculatePointValueMedian {
    [self printDeprecationTransitionWarningForOldMethod:@"calculatePointValueMedian" replacementMethod:@"calculatePointValueMedianOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculatePointValueMedianOnGraph:self];
}

- (NSNumber *)calculatePointValueAverage {
    [self printDeprecationTransitionWarningForOldMethod:@"calculatePointValueAverage" replacementMethod:@"calculatePointValueAverageOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculatePointValueAverageOnGraph:self];
}

- (NSNumber *)calculateMinimumPointValue {
    [self printDeprecationTransitionWarningForOldMethod:@"calculateMinimumPointValue" replacementMethod:@"calculatePointValueAverageOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculateMinimumPointValueOnGraph:self];
}

- (NSNumber *)calculateMaximumPointValue {
    [self printDeprecationTransitionWarningForOldMethod:@"calculateMaximumPointValue" replacementMethod:@"calculateMaximumPointValueOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculateMaximumPointValueOnGraph:self];
}

- (NSNumber *)calculateLineGraphStandardDeviation {
    [self printDeprecationTransitionWarningForOldMethod:@"calculateLineGraphStandardDeviation" replacementMethod:@"calculateStandardDeviationOnGraph:" newObject:@"BEMGraphCalculator" sharedInstance:YES];
    return [[BEMGraphCalculator sharedCalculator] calculateStandardDeviationOnGraph:self];
}

- (void)printDeprecationAndUnavailableWarningForOldMethod:(NSString *)oldMethod {
    NSLog(@"[BEMSimpleLineGraph] UNAVAILABLE, DEPRECATION ERROR. The delegate method, %@, is both deprecated and unavailable. It is now a data source method. You must implement this method from BEMSimpleLineGraphDataSource. Update your delegate method as soon as possible. One of two things will now happen: A) an exception will be thrown, or B) the graph will not load.", oldMethod);
}

- (void)printDeprecationWarningForOldMethod:(NSString *)oldMethod andReplacementMethod:(NSString *)replacementMethod {
    NSLog(@"[BEMSimpleLineGraph] DEPRECATION WARNING. The delegate method, %@, is deprecated and will become unavailable in a future version. Use %@ instead. Update your delegate method as soon as possible. An exception will be thrown in a future version.", oldMethod, replacementMethod);
}

- (void)printDeprecationTransitionWarningForOldMethod:(NSString *)oldMethod replacementMethod:(NSString *)replacementMethod newObject:(NSString *)newObjectName sharedInstance:(BOOL)isSharedInstance {
    if (isSharedInstance == YES) NSLog(@"[BEMSimpleLineGraph] %@ is deprecated. Please use %@ on the shared instance of %@.", oldMethod, replacementMethod, newObjectName);
    else NSLog(@"[BEMSimpleLineGraph] %@ is deprecated. Please use %@ on the %@ class.", oldMethod, replacementMethod, newObjectName);
}

@end
