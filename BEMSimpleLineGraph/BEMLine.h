//
//  BEMLine.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//


@import UIKit;

/// Class to draw the line of the graph
@interface BEMLine : UIView

@property (assign, nonatomic) CGPoint  firstPoint;
@property (assign, nonatomic) CGPoint  secondPoint;

// COLORS
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;


// ALPHA
@property (nonatomic) float topAlpha;
@property (nonatomic) float bottomAlpha;
@property (nonatomic) float lineAlpha;

@property (nonatomic) float lineWidth;

@end