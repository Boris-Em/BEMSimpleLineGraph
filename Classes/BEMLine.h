//
//  BEMLine.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//


#if __has_feature(objc_modules)
    // We recommend enabling Objective-C Modules in your project Build Settings for numerous benefits over regular #imports
    @import Foundation;
    @import UIKit;
    @import CoreGraphics;
#else
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #import <CoreGraphics/CoreGraphics.h>
#endif



/// Class to draw the line of the graph
@interface BEMLine : UIView



//----- POINTS -----//

/// The previous point. Necessary for Bezier curve
@property (assign, nonatomic) CGPoint P0;

/// The starting point of the line
@property (assign, nonatomic) CGPoint P1;

/// The ending point of the line
@property (assign, nonatomic) CGPoint P2;

/// The next point. Necessary for Bezier curve
@property (assign, nonatomic) CGPoint P3;




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


//----- BEZIER CURVE -----//

@property (nonatomic) BOOL bezierCurveIsEnabled;

@end
