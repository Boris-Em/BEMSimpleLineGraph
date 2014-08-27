//
//  BEMLine.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMLine.h"

@implementation BEMLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _frameOffset = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // ---------------------------//
    // --- Draw Refrence Lines ---//
    // ---------------------------//
    UIBezierPath *referenceLinesPath = [UIBezierPath bezierPath];
    referenceLinesPath.lineCapStyle = kCGLineCapButt;
    referenceLinesPath.lineWidth = 0.7;
    
    if (self.enableRefrenceLines == YES) {
        for (NSNumber *xNumber in self.arrayOfVerticalRefrenceLinePoints) {
            CGPoint initialPoint = CGPointMake([xNumber floatValue], self.frame.size.height - self.frameOffset);
            CGPoint finalPoint = CGPointMake([xNumber floatValue], 0);
            
            [referenceLinesPath moveToPoint:initialPoint];
            [referenceLinesPath addLineToPoint:finalPoint];
        }
        
        if (self.arrayOfHorizontalRefrenceLinePoints.count > 0) {
            for (NSNumber *yNumber in self.arrayOfHorizontalRefrenceLinePoints) {
                CGPoint initialPoint = CGPointMake(0, [yNumber floatValue]);
                CGPoint finalPoint = CGPointMake(self.frame.size.width, [yNumber floatValue]);
                
                [referenceLinesPath moveToPoint:initialPoint];
                [referenceLinesPath addLineToPoint:finalPoint];
            }
        }
        
        if (self.enableRefrenceFrame == YES) {
            [referenceLinesPath moveToPoint:CGPointMake(0, self.frame.size.height - self.frameOffset)];
            [referenceLinesPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - self.frameOffset)];
            
            [referenceLinesPath moveToPoint:CGPointMake(0+self.lineWidth/4, self.frame.size.height - self.frameOffset)];
            [referenceLinesPath addLineToPoint:CGPointMake(0+self.lineWidth/4, 0)];
        }
        
        [referenceLinesPath closePath];
    } else referenceLinesPath = nil;
    
    
    // ---------------------------//
    // ----- Draw Graph Line -----//
    // ---------------------------//
    CGPoint CP1;
    CGPoint CP2;
    
     // BEZIER CURVE
    if (self.bezierCurveIsEnabled == YES) {
        
        // First control point
        CP1 = CGPointMake(self.P1.x + (self.P2.x - self.P1.x)/3,
                          self.P1.y - (self.P1.y - self.P2.y)/3 - (self.P0.y - self.P1.y)*0.3);
        
        // Second control point
        CP2 = CGPointMake(self.P1.x + 2*(self.P2.x - self.P1.x)/3,
                          (self.P1.y - 2*(self.P1.y - self.P2.y)/3) + (self.P2.y - self.P3.y)*0.3);
    }
    
    // LINE
    UIBezierPath *line = [UIBezierPath bezierPath];
    UIBezierPath *fillTop = [UIBezierPath bezierPath];
    UIBezierPath *fillBottom = [UIBezierPath bezierPath];
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    CGFloat tensionBezier = 0.3;
    
    if (self.xAxisBackgroundColor == self.bottomColor && self.xAxisBackgroundAlpha == self.bottomAlpha) {
        [fillBottom moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [fillBottom addLineToPoint:CGPointMake(0, self.frame.size.height)];
    } else {
        UIBezierPath *fillxAxis = [UIBezierPath bezierPath];
        [fillBottom moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - self.frameOffset)];
        [fillBottom addLineToPoint:CGPointMake(0, self.frame.size.height - self.frameOffset)];

        [fillxAxis moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - self.frameOffset)];
        [fillxAxis addLineToPoint:CGPointMake(0, self.frame.size.height - self.frameOffset)];
        [fillxAxis addLineToPoint:CGPointMake(0, self.frame.size.height)];
        [fillxAxis addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [self.xAxisBackgroundColor set];
        [fillxAxis fillWithBlendMode:kCGBlendModeNormal alpha:self.xAxisBackgroundAlpha];
    }
    
    
    [fillTop moveToPoint:CGPointMake(self.frame.size.width, 0)];
    [fillTop addLineToPoint:CGPointMake(0, 0)];
    
    for (int i = 0; i<[self.arrayOfPoints count]-1; i++) {
        p1 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*i, [[self.arrayOfPoints objectAtIndex:i] floatValue]);
        p2 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i+1), [[self.arrayOfPoints objectAtIndex:i+1] floatValue]);
        
        [line moveToPoint:p1];
        [fillBottom addLineToPoint:p1];
        [fillTop addLineToPoint:p1];
        
        if (self.bezierCurveIsEnabled == YES) {
            if (i > 0) { // Exception for first line because there is no previous point
                p0 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i-1), [[self.arrayOfPoints objectAtIndex:i-1] floatValue]);
            } else p0 = p1;
            
            if (i<[self.arrayOfPoints count] - 2) { // Exception for last line because there is no next point
                p3 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i+2), [[self.arrayOfPoints objectAtIndex:i+2] floatValue]);
            } else p3 = p2;
            
            if (p2.y - p1.y == p1.y - p0.y || p3.y - p2.y == p2.y - p1.y) { // Exception for line to be expected to be straight (see issue #21)
                tensionBezier = 0.0;
            }
            
            // First control point
            CP1 = CGPointMake(p1.x + (p2.x - p1.x)/3,
                              p1.y - (p1.y - p2.y)/3 - (p0.y - p1.y)*tensionBezier);
            
            // Second control point
            CP2 = CGPointMake(p1.x + 2*(p2.x - p1.x)/3,
                              (p1.y - 2*(p1.y - p2.y)/3) + (p2.y - p3.y)*tensionBezier);
            
            [line addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillBottom addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillTop addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            
        } else {
            [line addLineToPoint:p2];
            [fillBottom addLineToPoint:p2];
            [fillTop addLineToPoint:p2];
        }
    }
    
    
    // ---------------------------//
    // ---- Draw Fill Colors -----//
    // ---------------------------//
    [self.topColor set];
    [fillTop fillWithBlendMode:kCGBlendModeNormal alpha:self.topAlpha];
    
    [self.bottomColor set];
    [fillBottom fillWithBlendMode:kCGBlendModeNormal alpha:self.bottomAlpha];
    
    
    // ---------------------------//
    // ----- Animate Drawing -----//
    // ---------------------------//
    if (self.animationTime == 0) {
        [self.color set];
        
        [line setLineWidth:self.lineWidth];
        [line strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
        
        if (self.enableRefrenceLines == YES) {
            [referenceLinesPath setLineWidth:self.lineWidth/2];
            [referenceLinesPath strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha/2];
        }
    } else {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = line.CGPath;
        pathLayer.strokeColor = self.color.CGColor;
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = self.lineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
        pathLayer.lineCap = kCALineCapRound;
        [self animateForLayer:pathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        [self.layer addSublayer:pathLayer];
        
        if (self.enableRefrenceLines == YES) {
            CAShapeLayer *referenceLinesPathLayer = [CAShapeLayer layer];
            referenceLinesPathLayer.frame = self.bounds;
            referenceLinesPathLayer.path = referenceLinesPath.CGPath;
            referenceLinesPathLayer.opacity = self.lineAlpha/2;
            referenceLinesPathLayer.strokeColor = self.color.CGColor;
            referenceLinesPathLayer.fillColor = nil;
            referenceLinesPathLayer.lineWidth = self.lineWidth/2;
            [self animateForLayer:referenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
            [self.layer addSublayer:referenceLinesPathLayer];
        }
    }
}

- (void)animateForLayer:(CAShapeLayer *)shapeLayer withAnimationType:(BEMLineAnimation)animationType isAnimatingReferenceLine:(BOOL)shouldHalfOpacity {
    if (animationType == BEMLineAnimationNone) return;
    else if (animationType == BEMLineAnimationFade) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        if (shouldHalfOpacity == YES) pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha/2];
        else pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha];
        [shapeLayer addAnimation:pathAnimation forKey:@"opacity"];
        
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

@end
