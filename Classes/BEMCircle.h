//
//  BEMCircle.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;


/// Class to draw the circle for the points.
@interface BEMCircle : UIView

/// Set to YES if the data point circles should be constantly displayed. NO if they should only appear when relevant.
@property (assign, nonatomic) BOOL shouldDisplayConstantly;

/// The point's color
@property (strong, nonatomic, nullable) UIColor *color;

/** The point color
 @deprecated This property is no longer in use. Please use the \p color property instead. */
@property (strong, nonatomic, null_unspecified) UIColor *Pointcolor __deprecated_msg("Use color instead");

/// The value of the point
@property (nonatomic) CGFloat absoluteValue;

@end