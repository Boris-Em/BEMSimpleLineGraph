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
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // FILL TOP
    
    CGContextSetFillColorWithColor(ctx, [self.topColor CGColor]);
    CGContextSetAlpha(ctx, self.topAlpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, round(self.P1.x), self.P1.y);
    if (self.bezierCurveIsEnabled == YES) {
        CGContextAddCurveToPoint(ctx, CP1.x, CP1.y, CP2.x, CP2.y, round(self.P2.x), self.P2.y);
    } else {
        CGContextAddLineToPoint(ctx, round(self.P2.x), self.P2.y);
    }
    CGContextAddLineToPoint(ctx, round(self.P2.x), self.frame.origin.y);
    CGContextAddLineToPoint(ctx, round(self.P1.x), self.frame.origin.x);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    // FILL BOTOM
    CGContextSetFillColorWithColor(ctx, [self.bottomColor CGColor]);
    CGContextSetAlpha(ctx, self.bottomAlpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, round(self.P1.x), self.P1.y);
    if (self.bezierCurveIsEnabled == YES) {
        CGContextAddCurveToPoint(ctx, CP1.x, CP1.y, CP2.x, CP2.y, round(self.P2.x), self.P2.y);
    } else {
        CGContextAddLineToPoint(ctx, round(self.P2.x), self.P2.y);
    }
    CGContextAddLineToPoint(ctx, round(self.P2.x), self.frame.size.height);
    CGContextAddLineToPoint(ctx, round(self.P1.x), self.frame.size.height);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    //LINE
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:self.lineWidth];
    [path1 moveToPoint:self.P1];
    if (self.bezierCurveIsEnabled == YES) { // BEZIER CURVE
        [path1 addCurveToPoint:self.P2 controlPoint1:CP1 controlPoint2:CP2];
    } else { // SIMPLE LINE
        [path1 addLineToPoint:self.P2];
    }
    path1.lineCapStyle = kCGLineCapSquare;
    [self.color set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}

@end