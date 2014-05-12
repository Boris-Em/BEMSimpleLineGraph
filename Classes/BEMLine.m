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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint CP1;
    CGPoint CP2;
    
    if (self.bezierCurveIsEnabled == YES) { // BEZIER CURVE
        CP1 = CGPointMake(self.P1.x + (self.P2.x - self.P1.x)/3, self.P1.y - (self.P1.y - self.P2.y)/3 - (self.P0.y - self.P1.y)*0.3); // First control point
        CP2 = CGPointMake(self.P1.x + 2*(self.P2.x - self.P1.x)/3, (self.P1.y - 2*(self.P1.y - self.P2.y)/3) + (self.P2.y - self.P3.y)*0.3); // Second control point
    }
    
    //LINE
    UIBezierPath *line = [UIBezierPath bezierPath];
    UIBezierPath *fillTop = [UIBezierPath bezierPath];
    UIBezierPath *fillBottom = [UIBezierPath bezierPath];
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    CGPoint p3;
    
    [fillTop moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [fillTop addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    [fillBottom moveToPoint:CGPointMake(self.frame.size.width, 0)];
    [fillBottom addLineToPoint:CGPointMake(0, 0)];
    
    for (int i = 0; i<[self.arrayOfPoints count]-1; i++) {
        p1 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*i, [[self.arrayOfPoints objectAtIndex:i] floatValue]);
        p2 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i+1), [[self.arrayOfPoints objectAtIndex:i+1] floatValue]);
        [line moveToPoint:p1];
        [fillTop addLineToPoint:p1];
        [fillBottom addLineToPoint:p1];
        if (self.bezierCurveIsEnabled == YES) {
            if (i > 0) {
                p0 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i-1), [[self.arrayOfPoints objectAtIndex:i-1] floatValue]);
            } else p0 = p1;
            if (i<[self.arrayOfPoints count] - 2) {
                p3 = CGPointMake((self.frame.size.width/([self.arrayOfPoints count] - 1))*(i+2), [[self.arrayOfPoints objectAtIndex:i+2] floatValue]);
            } else p3 = p2;
            
            CP1 = CGPointMake(p1.x + (p2.x - p1.x)/3, p1.y - (p1.y - p2.y)/3 - (p0.y - p1.y)*0.3); // First control point
            CP2 = CGPointMake(p1.x + 2*(p2.x - p1.x)/3, (p1.y - 2*(p1.y - p2.y)/3) + (p2.y - p3.y)*0.3); // Second control point
            
            [line addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillTop addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            [fillBottom addCurveToPoint:p2 controlPoint1:CP1 controlPoint2:CP2];
            
        } else {
            [line addLineToPoint:p2];
            [fillTop addLineToPoint:p2];
            [fillBottom addLineToPoint:p2];
        }
    }
    
    [self.topColor set];
    [fillTop fillWithBlendMode:kCGBlendModeNormal alpha:self.topAlpha];
    
    [self.bottomColor set];
    [fillBottom fillWithBlendMode:kCGBlendModeNormal alpha:self.bottomAlpha];
    
    if (self.animationTime == 0) {
        [self.color set];
        [line setLineWidth:self.lineWidth];
        [line strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
    } else {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = line.CGPath;
        pathLayer.strokeColor = self.color.CGColor;
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = self.lineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
    
        [self.layer addSublayer:pathLayer];
    
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.5;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

@end