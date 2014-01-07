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



//----- POINTS -----//

/// The starting point of the line
@property (assign, nonatomic) CGPoint firstPoint;

/// The ending point of the line
@property (assign, nonatomic) CGPoint secondPoint;




//----- COLORS -----//

/// The line color
@property (strong, nonatomic) UIColor *color;

/// The color of the area above the line, inside of its superview
@property (strong, nonatomic) UIColor *topColor;

/// The color of the area below the line, inside of its superview
@property (strong, nonatomic) UIColor *bottomColor;




//----- ALPHA -----//

/// The line alpha
@property (nonatomic) float lineAlpha;

/// The alpha value of the area above the line, inside of its superview
@property (nonatomic) float topAlpha;

/// The alpha value of the area below the line, inside of its superview
@property (nonatomic) float bottomAlpha;





//----- SIZE -----//

/// The width of the line
@property (nonatomic) float lineWidth;



@end
