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

#import "BEMAverageLine.h"


/// The type of animation used to display the graph
typedef NS_ENUM(NSInteger, BEMLineAnimation) {
    /// The draw animation draws the lines from left to right and bottom to top.
    BEMLineAnimationDraw,
    /// The fade animation fades in the lines from 0% opaque to 100% opaque (based on the \p lineAlpha property).
    BEMLineAnimationFade,
    /// The expand animation expands the lines from a small point to their full width (based on the \p lineWidth property).
    BEMLineAnimationExpand,
    /// No animation is used to display the graph
    BEMLineAnimationNone
};

/// The drawing direction of the gradient used to draw the graph line (if any)
typedef NS_ENUM(NSUInteger, BEMLineGradientDirection) {
    /// The gradient is drawn from left to right
    BEMLineGradientDirectionHorizontal = 0,
    /// The gradient is drawn from top to bottom
    BEMLineGradientDirectionVertical = 1
};


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

/// All of the Y-axis values for the points
@property (nonatomic) NSArray *arrayOfPoints;

/// All of the X-Axis coordinates used to draw vertical lines through
@property (nonatomic) NSArray *arrayOfVerticalRefrenceLinePoints;

/// The value used to offset the fringe vertical reference lines when the x-axis labels are on the edge
@property (assign, nonatomic) CGFloat verticalReferenceHorizontalFringeNegation;

/// All of the Y-Axis coordinates used to draw horizontal lines through
@property (nonatomic) NSArray *arrayOfHorizontalRefrenceLinePoints;

/// All of the point values
@property (nonatomic) NSArray *arrayOfValues;

/** Draw thin, translucent, reference lines using the provided X-Axis and Y-Axis coordinates.
 @see Use \p arrayOfVerticalRefrenceLinePoints to specify vertical reference lines' positions. Use \p arrayOfHorizontalRefrenceLinePoints to specify horizontal reference lines' positions. */
@property (nonatomic) BOOL enableRefrenceLines;

/** Draw a thin, translucent, frame on the edge of the graph to separate it from the labels on the X-Axis and the Y-Axis. */
@property (nonatomic) BOOL enableRefrenceFrame;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (nonatomic) BOOL enableLeftReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (nonatomic) BOOL enableBottomReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (nonatomic) BOOL enableRightReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (nonatomic) BOOL enableTopReferenceFrameLine;

/** Dash pattern for the references line on the X axis */
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceXAxisLines;

/** Dash pattern for the references line on the Y axis */
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceYAxisLines;

/** If a null value is present, interpolation would draw a best fit line through the null point bound by its surrounding points.  Default: YES */
@property (nonatomic) BOOL interpolateNullValues;

/** Draws everything but the main line on the graph; correlates to the \p displayDotsOnly property.  Default: NO */
@property (nonatomic) BOOL disableMainLine;



//----- COLORS -----//

/// The line color. A single, solid color which is applied to the entire line. If the \p gradient property is non-nil this property will be ignored.
@property (strong, nonatomic) UIColor *color;

/// The color of the area above the line, inside of its superview
@property (strong, nonatomic) UIColor *topColor;

/// A color gradient applied to the area above the line, inside of its superview. If set, it will be drawn on top of the fill from the \p topColor property.
@property (assign, nonatomic) CGGradientRef topGradient;

/// The color of the area below the line, inside of its superview
@property (strong, nonatomic) UIColor *bottomColor;

/// A color gradient applied to the area below the line, inside of its superview. If set, it will be drawn on top of the fill from the \p bottomColor property.
@property (assign, nonatomic) CGGradientRef bottomGradient;

/// A color gradient to be applied to the line. If this property is set, it will mask (override) the \p color property.
@property (assign, nonatomic) CGGradientRef lineGradient;

/// The drawing direction of the line gradient color
@property (nonatomic) BEMLineGradientDirection lineGradientDirection;

/// The reference line color. Defaults to `color`.
@property (strong, nonatomic) UIColor *refrenceLineColor;



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

/// The line is drawn with smooth curves rather than straight lines when set to YES.
@property (nonatomic) BOOL bezierCurveIsEnabled;



//----- ANIMATION -----//

/// The entrance animation period in seconds.
@property (nonatomic) CGFloat animationTime;

/// The type of entrance animation.
@property (nonatomic) BEMLineAnimation animationType;



//----- AVERAGE -----//

/// The average line
@property (strong, nonatomic) BEMAverageLine *averageLine;

/// The average line's y-value translated into the coordinate system
@property (nonatomic) CGFloat averageLineYCoordinate;



@end
