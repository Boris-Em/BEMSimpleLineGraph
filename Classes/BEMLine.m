//
//  BEMLine.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMLine.h"
#import "BEMSimpleLineGraphView.h"

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#else
#define CGFloatValue floatValue
#endif


@interface BEMLine()

@property (nonatomic, strong) NSMutableArray <NSValue *> *points;

@end

@implementation BEMLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _enableLeftReferenceFrameLine = YES;
        _enableBottomReferenceFrameLine = YES;
        _interpolateNullValues = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //----------------------------//
    //---- Draw Reference Lines ---//
    //----------------------------//
    self.layer.sublayers = nil;

    UIBezierPath *verticalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *horizontalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *referenceFramePath = [UIBezierPath bezierPath];

    verticalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    verticalReferenceLinesPath.lineWidth = 0.7f;

    horizontalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    horizontalReferenceLinesPath.lineWidth = 0.7f;

    referenceFramePath.lineCapStyle = kCGLineCapButt;
    referenceFramePath.lineWidth = 0.7f;

    if (self.enableReferenceFrame == YES) {
        if (self.enableBottomReferenceFrameLine) {
            // Bottom Line
            [referenceFramePath moveToPoint:CGPointMake(0, self.frame.size.height-self.referenceLineWidth/4)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-self.referenceLineWidth/4)];
        }

        if (self.enableLeftReferenceFrameLine) {
            // Left Line
            [referenceFramePath moveToPoint:CGPointMake(0+self.referenceLineWidth/4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(0+self.referenceLineWidth/4, 0)];
        }

        if (self.enableTopReferenceFrameLine) {
            // Top Line
            [referenceFramePath moveToPoint:CGPointMake(0+self.referenceLineWidth/4, self.referenceLineWidth/4)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, self.referenceLineWidth/4)];
        }

        if (self.enableRightReferenceFrameLine) {
            // Right Line
            [referenceFramePath moveToPoint:CGPointMake(self.frame.size.width - self.referenceLineWidth/4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width - self.referenceLineWidth/4, 0)];
        }
    }

    if (self.enableReferenceLines == YES) {
        if (self.arrayOfVerticalReferenceLinePoints.count > 0) {
            for (NSNumber *xNumber in self.arrayOfVerticalReferenceLinePoints) {
                CGFloat xValue =[xNumber doubleValue];
                if (self.verticalReferenceHorizontalFringeNegation != 0.0) {
                    NSUInteger index = [self.arrayOfVerticalReferenceLinePoints indexOfObject:xNumber];
                    if (index == 0) { // far left reference line
                        xValue += self.verticalReferenceHorizontalFringeNegation;
                    } else if (index == [self.arrayOfVerticalReferenceLinePoints count]-1) { // far right reference line
                        xValue -= self.verticalReferenceHorizontalFringeNegation;
                    }
                }
                CGPoint initialPoint = CGPointMake(xValue, self.frame.size.height);
                CGPoint finalPoint = CGPointMake(xValue, 0);

                [verticalReferenceLinesPath moveToPoint:initialPoint];
                [verticalReferenceLinesPath addLineToPoint:finalPoint];
            }
        }

        if (self.arrayOfHorizontalReferenceLinePoints.count > 0) {
            for (NSNumber *yNumber in self.arrayOfHorizontalReferenceLinePoints) {
                CGPoint initialPoint = CGPointMake(0, [yNumber floatValue]);
                CGPoint finalPoint = CGPointMake(self.frame.size.width, [yNumber floatValue]);

                [horizontalReferenceLinesPath moveToPoint:initialPoint];
                [horizontalReferenceLinesPath addLineToPoint:finalPoint];
            }
        }
    }


    //----------------------------//
    //----- Draw Average Line ----//
    //----------------------------//
    UIBezierPath *averageLinePath = [UIBezierPath bezierPath];
    if (self.averageLine.enableAverageLine == YES) {
        averageLinePath.lineCapStyle = kCGLineCapButt;
        averageLinePath.lineWidth = self.averageLine.width;

        CGPoint initialPoint = CGPointMake(0, self.averageLineYCoordinate);
        CGPoint finalPoint = CGPointMake(self.frame.size.width, self.averageLineYCoordinate);

        [averageLinePath moveToPoint:initialPoint];
        [averageLinePath addLineToPoint:finalPoint];
    }


    //----------------------------//
    //------ Draw Graph Line -----//
    //----------------------------//
    // LINE
    UIBezierPath *line = [UIBezierPath bezierPath];
    UIBezierPath *fillTop;
    UIBezierPath *fillBottom;

    CGFloat xIndexScale = self.frame.size.width/([self.arrayOfPoints count] - 1);

    self.points = [NSMutableArray arrayWithCapacity:self.arrayOfPoints.count];
    for (NSUInteger i = 0; i < self.arrayOfPoints.count; i++) {
        CGFloat value = [self.arrayOfPoints[i] CGFloatValue];;
        if (value >= BEMNullGraphValue  && self.interpolateNullValues) {
            //need to interpolate. For midpoints, just don't add a point
            if (i ==0) {
                //extrapolate a left edge point from next two actual values
                NSUInteger firstPos = 1; //look for first real value
                while (firstPos < self.arrayOfPoints.count && [self.arrayOfPoints[firstPos] CGFloatValue] >= BEMNullGraphValue) firstPos++;
                if (firstPos >= self.arrayOfPoints.count) break;  // all NaNs?? =>don't create any line

                CGFloat firstValue = [self.arrayOfPoints[firstPos] CGFloatValue];
                NSUInteger secondPos = firstPos+1; //look for second real value
                while (secondPos < self.arrayOfPoints.count && [self.arrayOfPoints[secondPos] CGFloatValue] >= BEMNullGraphValue) secondPos++;
                if (secondPos >= self.arrayOfPoints.count) {
                    // only one real number
                    value = firstValue;
                } else {
                    CGFloat delta = firstValue - [self.arrayOfPoints[secondPos] CGFloatValue];
                    value = firstValue + firstPos*delta/(secondPos-firstPos);
                }

            } else if (i == self.arrayOfPoints.count-1) {
                //extrapolate a right edge poit from previous two actual values
                NSInteger firstPos = i-1; //look for first real value
                while (firstPos >= 0 && [self.arrayOfPoints[firstPos] CGFloatValue] >= BEMNullGraphValue) firstPos--;
                if (firstPos < 0 ) continue;  // all NaNs?? =>don't create any line; should already be gone

                CGFloat firstValue = [self.arrayOfPoints[firstPos] CGFloatValue];
                NSInteger secondPos = firstPos-1; //look for second real value
                while (secondPos >= 0 && [self.arrayOfPoints[secondPos] CGFloatValue] >= BEMNullGraphValue) secondPos--;
                if (secondPos < 0) {
                    // only one real number
                    value = firstValue;
                } else {
                    CGFloat delta = firstValue - [self.arrayOfPoints[secondPos] CGFloatValue];
                    value = firstValue + (self.arrayOfPoints.count - firstPos-1)*delta/(firstPos - secondPos);
                }

            } else {
                continue; //skip this (middle Null) point, let graphics handle interpolation
            }
        }
        CGPoint newPoint = CGPointMake(xIndexScale * i, value);
        [self.points addObject:[NSValue valueWithCGPoint:newPoint]];
  }

    if (!self.disableMainLine && self.bezierCurveIsEnabled) {
        line = [BEMLine quadCurvedPathWithPoints:self.points open:YES];
        fillBottom = [BEMLine quadCurvedPathWithPoints:self.bottomPointsArray open:NO];
        fillTop = [BEMLine quadCurvedPathWithPoints:self.topPointsArray open:NO];
    } else if (!self.disableMainLine && !self.bezierCurveIsEnabled) {
        line = [BEMLine linesToPoints:self.points open:YES];
        fillBottom = [BEMLine linesToPoints:self.bottomPointsArray open:NO];
        fillTop = [BEMLine linesToPoints:self.topPointsArray open:NO];
    } else {
        fillBottom = [BEMLine linesToPoints:self.bottomPointsArray open:NO];
        fillTop = [BEMLine linesToPoints:self.topPointsArray open:NO];
    }

    //----------------------------//
    //----- Draw Fill Colors -----//
    //----------------------------//
    [self.topColor set];
    [fillTop fillWithBlendMode:kCGBlendModeNormal alpha:self.topAlpha];

    [self.bottomColor set];
    [fillBottom fillWithBlendMode:kCGBlendModeNormal alpha:self.bottomAlpha];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.topGradient != nil) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, [fillTop CGPath]);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, self.topGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillTop.bounds)), (CGGradientDrawingOptions) 0);
        CGContextRestoreGState(ctx);
    }

    if (self.bottomGradient != nil) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, [fillBottom CGPath]);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, self.bottomGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillBottom.bounds)), (CGGradientDrawingOptions) 0);
        CGContextRestoreGState(ctx);
    }


    //----------------------------//
    //------ Animate Drawing -----//
    //----------------------------//
    if (self.enableReferenceLines == YES) {
        CAShapeLayer *verticalReferenceLinesPathLayer = [CAShapeLayer layer];
        verticalReferenceLinesPathLayer.frame = self.bounds;
        verticalReferenceLinesPathLayer.path = verticalReferenceLinesPath.CGPath;
        verticalReferenceLinesPathLayer.opacity = (float)(self.lineAlpha <= 0 ? 0.1 : self.lineAlpha/2.0);
        verticalReferenceLinesPathLayer.fillColor = nil;
        verticalReferenceLinesPathLayer.lineWidth = self.referenceLineWidth/2;

        if (self.lineDashPatternForReferenceYAxisLines) {
            verticalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceYAxisLines;
        }

        if (self.referenceLineColor) {
            verticalReferenceLinesPathLayer.strokeColor = self.referenceLineColor.CGColor;
        } else {
            verticalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }

        if (self.animationTime > 0)
            [self animateForLayer:verticalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        [self.layer addSublayer:verticalReferenceLinesPathLayer];


        CAShapeLayer *horizontalReferenceLinesPathLayer = [CAShapeLayer layer];
        horizontalReferenceLinesPathLayer.frame = self.bounds;
        horizontalReferenceLinesPathLayer.path = horizontalReferenceLinesPath.CGPath;
        horizontalReferenceLinesPathLayer.opacity = (float)(self.lineAlpha <= 0 ? 0.1 : self.lineAlpha/2.0);
        horizontalReferenceLinesPathLayer.fillColor = nil;
        horizontalReferenceLinesPathLayer.lineWidth = self.referenceLineWidth/2;
        if(self.lineDashPatternForReferenceXAxisLines) {
            horizontalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceXAxisLines;
        }

        if (self.referenceLineColor) {
            horizontalReferenceLinesPathLayer.strokeColor = self.referenceLineColor.CGColor;
        } else {
            horizontalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }

        if (self.animationTime > 0)
            [self animateForLayer:horizontalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        [self.layer addSublayer:horizontalReferenceLinesPathLayer];
    }

    CAShapeLayer *referenceLinesPathLayer = [CAShapeLayer layer];
    referenceLinesPathLayer.frame = self.bounds;
    referenceLinesPathLayer.path = referenceFramePath.CGPath;
    referenceLinesPathLayer.opacity = (float)(self.lineAlpha <= 0 ? 0.1 : self.lineAlpha/2.0);
    referenceLinesPathLayer.fillColor = nil;
    referenceLinesPathLayer.lineWidth = self.referenceLineWidth/2;

    if (self.referenceLineColor) referenceLinesPathLayer.strokeColor = self.referenceLineColor.CGColor;
    else referenceLinesPathLayer.strokeColor = self.color.CGColor;

    if (self.animationTime > 0)
        [self animateForLayer:referenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
    [self.layer addSublayer:referenceLinesPathLayer];

    if (self.disableMainLine == NO) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = line.CGPath;
        pathLayer.strokeColor = self.color.CGColor;
        pathLayer.fillColor = nil;
        pathLayer.opacity = (float)self.lineAlpha;
        pathLayer.lineWidth = self.lineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
        pathLayer.lineCap = kCALineCapRound;
        if (self.animationTime > 0) [self animateForLayer:pathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        if (self.lineGradient) [self.layer addSublayer:[self backgroundGradientLayerForLayer:pathLayer]];
        else [self.layer addSublayer:pathLayer];
    }

    if (self.averageLine.enableAverageLine == YES) {
        CAShapeLayer *averageLinePathLayer = [CAShapeLayer layer];
        averageLinePathLayer.frame = self.bounds;
        averageLinePathLayer.path = averageLinePath.CGPath;
        averageLinePathLayer.opacity = (float)self.averageLine.alpha;
        averageLinePathLayer.fillColor = nil;
        averageLinePathLayer.lineWidth = self.averageLine.width;

        if (self.averageLine.dashPattern) averageLinePathLayer.lineDashPattern = self.averageLine.dashPattern;

        if (self.averageLine.color) averageLinePathLayer.strokeColor = self.averageLine.color.CGColor;
        else averageLinePathLayer.strokeColor = self.color.CGColor;

        if (self.animationTime > 0)
            [self animateForLayer:averageLinePathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        [self.layer addSublayer:averageLinePathLayer];
    }
}

- (NSArray <NSValue *> *)topPointsArray {
    CGPoint topPointZero = CGPointMake(0,0);
    CGPoint topPointFull = CGPointMake(self.frame.size.width, 0);
    NSMutableArray <NSValue *> *topPoints = [NSMutableArray arrayWithArray:self.points];
    [topPoints insertObject:[NSValue valueWithCGPoint:topPointZero] atIndex:0];
    [topPoints addObject:[NSValue valueWithCGPoint:topPointFull]];
    return topPoints;
}

- (NSArray <NSValue *> *)bottomPointsArray {
    CGPoint bottomPointZero = CGPointMake(0, self.frame.size.height);
    CGPoint bottomPointFull = CGPointMake(self.frame.size.width, self.frame.size.height);
    NSMutableArray <NSValue *> *bottomPoints = [NSMutableArray arrayWithArray:self.points];
    [bottomPoints insertObject:[NSValue valueWithCGPoint:bottomPointZero] atIndex:0];
    [bottomPoints addObject:[NSValue valueWithCGPoint:bottomPointFull]];
    return bottomPoints;
}

+ (UIBezierPath *)linesToPoints:(NSArray <NSValue *> *)points open:(BOOL) canSkipPoints {
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];

    for (NSValue * point in points) {
        if (point == value) continue; //already at first point
        CGPoint p2 = [point CGPointValue];

        if (canSkipPoints && (p1.y >= BEMNullGraphValue || p2.y >= BEMNullGraphValue)) {
            [path moveToPoint:p2];
        } else {
            [path addLineToPoint:p2];
        }
        p1 = p2;
    }
    return path;
}

+ (UIBezierPath *)quadCurvedPathWithPoints:(NSArray <NSValue *> *)points open:(BOOL) canSkipPoints {
    UIBezierPath *path = [UIBezierPath bezierPath];

    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];

    for (NSValue * point in points) {
        if (point == value) continue; //already at first point
        CGPoint p2 = [point CGPointValue];

        if (canSkipPoints && (p1.y >= BEMNullGraphValue || p2.y >= BEMNullGraphValue)) {
            [path moveToPoint:p2];
        } else {
            CGPoint midPoint = midPointForPoints(p1, p2);
            [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
            [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];
        }
        p1 = p2;
    }
    return path;
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    CGFloat avgY = (p1.y + p2.y) / 2.0;
    if (isinf(avgY)) avgY = BEMNullGraphValue;
    return CGPointMake((p1.x + p2.x) / 2, avgY);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = (CGFloat)fabs(p2.y - controlPoint.y);

    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;

    return controlPoint;
}

- (void)animateForLayer:(CAShapeLayer *)shapeLayer withAnimationType:(BEMLineAnimation)animationType isAnimatingReferenceLine:(BOOL)shouldHalfOpacity {
    if (animationType == BEMLineAnimationNone) return;
    else if (animationType == BEMLineAnimationFade) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        if (shouldHalfOpacity == YES) pathAnimation.toValue = [NSNumber numberWithDouble:self.lineAlpha <= 0 ? 0.1f : self.lineAlpha/2.0f];
        else pathAnimation.toValue = [NSNumber numberWithDouble:self.lineAlpha];
        [shapeLayer addAnimation:pathAnimation forKey:@"opacity"];

        return;
    } else if (animationType == BEMLineAnimationExpand) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithDouble:shapeLayer.lineWidth];
        [shapeLayer addAnimation:pathAnimation forKey:@"lineWidth"];

        return;
    } else {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];

        return;
    }
}

- (CALayer *)backgroundGradientLayerForLayer:(CAShapeLayer *)shapeLayer {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    CGPoint start, end;
    if (self.lineGradientDirection == BEMLineGradientDirectionHorizontal) {
        start = CGPointMake(0, CGRectGetMidY(shapeLayer.bounds));
        end = CGPointMake(CGRectGetMaxX(shapeLayer.bounds), CGRectGetMidY(shapeLayer.bounds));
    } else {
        start = CGPointMake(CGRectGetMidX(shapeLayer.bounds), 0);
        end = CGPointMake(CGRectGetMidX(shapeLayer.bounds), CGRectGetMaxY(shapeLayer.bounds));
    }

    CGContextDrawLinearGradient(imageCtx, self.lineGradient, start, end, (CGGradientDrawingOptions)0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.contents = (id)image.CGImage;
    gradientLayer.mask = shapeLayer;
    return gradientLayer;
}

@end
