//
//  BEMAverageLine.h
//  SimpleLineChart
//
//  Created by Sam Spencer on 4/7/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

@import Foundation;
@import UIKit;


/// A line displayed horizontally across the graph at the average y-value
@interface BEMAverageLine : NSObject <NSCoding>


/// When set to YES, an average line will be displayed on the line graph
@property (nonatomic) BOOL enableAverageLine;


/// The color of the average line
@property (strong, nonatomic, nonnull) UIColor *color;


/// The Y-Value of the average line. This could be an average, a median, a mode, sum, etc.
@property (nonatomic) CGFloat yValue;


/// The alpha of the average line
@property (nonatomic) CGFloat alpha;


/// The width of the average line
@property (nonatomic) CGFloat width;


/// Dash pattern for the average line
@property (strong, nonatomic, nullable) NSArray <NSNumber *> *dashPattern;


//Label for average line in y axis. Default is blank.
@property (strong, nonatomic, nullable) NSString * title;


/// Title label on screen
@property (strong, nonatomic, nullable) UILabel *label;

@end
