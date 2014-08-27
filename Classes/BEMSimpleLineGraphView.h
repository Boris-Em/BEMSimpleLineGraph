//
//  BEMSimpleLineGraphView.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#if __has_feature(objc_modules)
// We recommend enabling Objective-C Modules in your project Build Settings for numerous benefits over regular #imports. Read more from the Modules documentation: http://clang.llvm.org/docs/Modules.html
@import Foundation;
@import UIKit;
@import CoreGraphics;
#else
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#endif

#import "BEMCircle.h"
#import "BEMLine.h"


@protocol BEMSimpleLineGraphDelegate;
@protocol BEMSimpleLineGraphDataSource;

/// Simple line graph / chart UIView subclass for iOS apps. Creates beautiful line graphs (without huge memory impacts) using QuartzCore.
@interface BEMSimpleLineGraphView : UIView <UIGestureRecognizerDelegate>



//------------------------------------------------------------------------------------//
//----- DELEGATE ---------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/** The object that acts as the delegate of the receiving line graph.
 
 @abstract The BEMSimpleLineGraphView delegate object plays a key role in changing the appearance of the graph and receiving graph events. Use the delegate to provide appearance changes, receive touch events, and receive graph events. The delegate can be set from the interface or from code.
 @discussion The delegate must adopt the \p BEMSimpleLineGraphDelegate protocol. The delegate is not retained.*/
@property (nonatomic, assign) IBOutlet id <BEMSimpleLineGraphDelegate> delegate;



//------------------------------------------------------------------------------------//
//----- DATA SOURCE ------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/** The object that acts as the data source of the receiving line graph.
 
 @abstract The BEMSimpleLineGraphView data source object is essential to the line graph. Use the data source to provide the graph with data (data points and x-axis labels). The delegate can be set from the interface or from code.
 @discussion The data source must adopt the \p BEMSimpleLineGraphDataSource protocol. The data source is not retained.*/
@property (nonatomic, assign) IBOutlet id <BEMSimpleLineGraphDataSource> dataSource;



//------------------------------------------------------------------------------------//
//----- METHODS ----------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/// Reload the graph, all delegate methods are called again and the graph is reloaded. Similar to calling reloadData on a UITableView.
- (void)reloadGraph;


/** Calculates the distance between the touch input and the closest point on the graph.
 @return The distance between the touch input and the closest point on the graph. */
- (CGFloat)distanceToClosestPoint;


/** Takes a snapshot of the graph.
 @return The snapshot of the graph as a UIImage object. */
- (UIImage *)graphSnapshotImage NS_AVAILABLE_IOS(7_0);


/** Calculates the average (mean) of all points on the line graph.
 @return The average (mean) number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueAverage;


/** Calculates the sum of all points on the line graph.
 @return The sum of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueSum;


/** Calculates the median of all points on the line graph.
 @return The median number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueMedian;


/** Calculates the mode of all points on the line graph.
 @return The mode number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueMode;


/** Calculates the standard deviation of all points on the line graph.
 @return The standard deviation of the points on the graph. Originally a float. */
- (NSNumber *)calculateLineGraphStandardDeviation;


/** Calculates the minimum value of all points on the line graph.
 @return The minimum number of the points on the graph. Originally a float. */
- (NSNumber *)calculateMinimumPointValue;


/** Calculates the maximum value of all points on the line graph.
 @return The maximum value of the points on the graph. Originally a float. */
- (NSNumber *)calculateMaximumPointValue;


/** All the displayed values of the X-Axis.
 @return An array of NSStrings, one for each displayed X-Axis label. The array is sorted from the left side of the graph to the right side. */
- (NSArray *)graphValuesForXAxis;


/** All the data points on the graph.
 @return An array of NSNumbers, one for each data point. The array is sorted from the left side of the graph to the right side. */
- (NSArray *)graphValuesForDataPoints;


/** All the labels of the X-Axis.
 @return An array of UILabels, one for each displayed X-Axis label. The array is sorted from the left side of the graph to the right side. */
- (NSArray *)graphLabelsForXAxis;



//------------------------------------------------------------------------------------//
//----- PROPERTIES -------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/// The graph's label font used on various axis. This property may be privately overwritten, do not expect full functionality from this property.
@property (strong, nonatomic) UIFont *labelFont;


/// Time of the animation when the graph appears in seconds. Default value is 1.5.
@property (nonatomic) CGFloat animationGraphEntranceTime;


/** Animation style used when the graph appears. Default value is BEMLineAnimationDraw.
 @see Refer to \p BEMLineAnimation for a complete list of animation styles. */
@property (nonatomic) BEMLineAnimation animationGraphStyle;


/// If set to YES, the graph will report the value of the closest point from the user current touch location. The 2 methods for touch event bellow should therefore be implemented. Default value is NO.
@property (nonatomic) BOOL enableTouchReport;


/// If set to YES, a label will pop up on the graph when the user touches it. It will be displayed on top of the closest point from the user current touch location. Default value is NO.
@property (nonatomic) BOOL enablePopUpReport;


/// The way the graph is drawn, with or without bezier curved lines. Default value is NO.
@property (nonatomic) BOOL enableBezierCurve;


/** Show Y-Axis label on the side. Default value is NO.
 @see  autoScaleYAxis - When set YES, Y-Axis will show minimum, maximum and middle label only.
 @todo Could enhance further by specifying the position of Y-Axis, i.e. Left or Right of the view.  Also auto detection on label overlapping. */
@property (nonatomic) BOOL enableYAxisLabel;

/** When set to YES, the points on the Y-axis will be set to all fit in the graph view. When set to NO, the points on the Y-axis will be set with their absolute value (which means that certain points might not be visible because they are outside of the view). Default value is YES. */
@property (nonatomic) BOOL autoScaleYAxis;


/// Draws a translucent vertical lines along the graph for each X-Axis label, when set to YES. Default value is NO.
@property (nonatomic) BOOL enableReferenceAxisLines;

/** Draws a translucent frame between the graph and any enabled axis, when set to YES. Default value is NO.
 @see enableReferenceAxisLines must be set to YES for this property to have any affect.  */
@property (nonatomic) BOOL enableReferenceAxisFrame;


/// If set to YES, the dots representing the points on the graph will always be visible. Default value is NO.
@property (nonatomic) BOOL alwaysDisplayDots;


/// If set to YES, pop up labels with the Y-value of the point will always be visible. Default value is NO.
@property (nonatomic) BOOL alwaysDisplayPopUpLabels;


/// Color of the bottom part of the graph (between the line and the X-axis).
@property (strong, nonatomic) UIColor *colorBottom;


/// Alpha of the bottom part of the graph (between the line and the X-axis).
@property (nonatomic) CGFloat alphaBottom;


/// Color of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (strong, nonatomic) UIColor *colorTop;


/// Alpha of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (nonatomic) CGFloat alphaTop;


/// Color of the line of the graph.
@property (strong, nonatomic) UIColor *colorLine;


/// Alpha of the line of the graph.
@property (nonatomic) CGFloat alphaLine;


/// Width of the line of the graph. Default value is 1.0.
@property (nonatomic) CGFloat widthLine;


/// The size of the circles that represent each point. Default is 10.0.
@property (nonatomic) CGFloat sizePoint;


/// The color of the circles that represent each point. Default is white.
@property (strong, nonatomic) UIColor *colorPoint;


/// The color of the line that appears when the user touches the graph.
@property (strong, nonatomic) UIColor *colorTouchInputLine;


/// The alpha of the line that appears when the user touches the graph.
@property (nonatomic) CGFloat alphaTouchInputLine;


/// The width of the line that appears when the user touches the graph.
@property (nonatomic) CGFloat widthTouchInputLine;


/// Color of the label's text displayed on the X-Axis. Defaut value is blackColor.
@property (strong, nonatomic) UIColor *colorXaxisLabel;


/// Color of the background of the X-Axis
@property (strong, nonatomic) UIColor *colorBackgroundXaxis;


/// Alpha of the background of the X-Axis
@property (nonatomic) CGFloat alphaBackgroundXaxis;


/// Color of the background of the Y-Axis
@property (strong, nonatomic) UIColor *colorBackgroundYaxis;


/// Alpha of the backgrounf of the Y-Axis
@property (nonatomic) CGFloat alphaBackgroundYaxis;


/// Color of the label's text displayed on the Y-Axis. Defaut value is blackColor.
@property (strong, nonatomic) UIColor *colorYaxisLabel;


/// Color of the pop up label's background displayed when the user touches the graph.
@property (strong, nonatomic) UIColor *colorBackgroundPopUplabel;


@end



/// Line Graph Data Source. Used to populate the graph with data, similar to how a UITableView works.
@protocol BEMSimpleLineGraphDataSource <NSObject>


@required


//----- DATA POINTS -----//


/** The number of points along the X-axis of the graph.
 @param graph The graph object requesting the total number of points.
 @return The total number of points in the line graph. */
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph;


/** The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
 @param graph The graph object requesting the point value.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index;


@optional


//------- X AXIS -------//

/** The string to display on the label on the X-axis at a given index.
 @discussion The number of strings to be returned should be equal to the number of points in the graph (returned in \p numberOfPointsInLineGraph). Otherwise, an exception may be thrown.
 @param graph The graph object which is requesting the label on the specified X-Axis position.
 @param index The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index;


@end



/// Line Graph Delegate. Used to change the graph's appearance and recieve events, similar to how a UITableView works.
@protocol BEMSimpleLineGraphDelegate <NSObject>


@optional



//----- GRAPH EVENTS -----//


/** Sent to the delegate each time the line graph is loaded or reloaded.
 @param graph The graph object that is about to be loaded or reloaded. */
- (void)lineGraphDidBeginLoading:(BEMSimpleLineGraphView *)graph;


/** Sent to the delegate each time the line graph finishes loading or reloading.
 @param graph The graph object that finished loading or reloading. */
- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph;


//----- CUSTOMIZATION -----//


/** The optional suffix to append to the popup report.
 @param graph The graph object requesting the total number of points.
 @return The suffix to append to the popup report. */
- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph;

/** Optional method to always display some of the pop up labels on the graph.
 @see alwaysDisplayPopUpLabels must be set to YES for this method to have any affect.
 @param graph The graph object requesting the total number of points.
 @param index The index from left to right of the points on the graph. The first value for the index is 0.
 @return Return YES if you want the popup label to be displayed for this index. */
- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(CGFloat)index;

/** Optional method to set the maximum value of the Y-Axis. If not implemented, the maximum value will be the biggest point of the graph.
 @param graph The graph object requesting the maximum value.
 @return The maximum value of the Y-Axis. */
- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph;

/** Optional method to set the minimum value of the Y-Axis. If not implemented, the minimum value will be the smallest point of the graph.
 @param graph The graph object requesting the minimum value.
 @return The minimum value of the Y-Axis. */
- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView *)graph;


//----- TOUCH EVENTS -----//


/** Sent to the delegate when the user starts touching the graph. The property 'enableTouchReport' must be set to YES.
 @param graph The graph object which was touched by the user.
 @param index The closest index (X-axis) from the location the user is currently touching. */
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index;


/** Sent to the delegate when the user stops touching the graph.
 @param graph The graph object which was touched by the user.
 @param index The closest index (X-axis) from the location the user last touched. */
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index;


//----- X AXIS -----//


/** The number of free space between labels on the X-axis to avoid overlapping.
 @discussion For example returning '1' would mean that half of the labels on the X-axis are not displayed: the first is not displayed, the second is, the third is not etc. Returning '0' would mean that all of the labels will be displayed. Finally, returning a value equal to the number of labels will only display the first and last label.
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return The number of labels to "jump" between each displayed label on the X-axis. */
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph;



//----- Y AXIS -----//


/** The total number of Y-axis labels on the line graph.
 @discussion Called only when autoScaleYAxis set to NO. Calculates the total height of the graph and evenly spaces the labels based on the graph height. Default value is 3.
 @param graph The graph object which is requesting the number of labels.
 @return The number of labels displayed on the Y-axis. */
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph;




//----- DEPRECATED -----//


/** \b DEPRECATED. Use \p numberOfPointsInLineGraph: instead. The number of points along the X-axis of the graph.
 @deprecated Deprecated in 1.3. Use \p numberOfPointsInLineGraph: instead.
 @return Number of points. */
- (int)numberOfPointsInGraph __deprecated;


/** \b DEPRECATED. Use \p lineGraph:valueForPointAtIndex: instead.
 @deprecated Deprecated in 1.3. Use \p lineGraph:valueForPointAtIndex: instead.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (float)valueForIndex:(NSInteger)index __deprecated;


/** \b DEPRECATED. Use \p lineGraph:didTouchGraphWithClosestIndex: instead. Gets called when the user starts touching the graph. The property 'enableTouchReport' must be set to YES.
 @deprecated Deprecated in 1.3. Use \p lineGraph:didTouchGraphWithClosestIndex: instead.
 @param index The closest index (X-axis) from the location the user is currently touching. */
- (void)didTouchGraphWithClosestIndex:(int)index __deprecated;


/** \b DEPRECATED. Use \p lineGraph:didReleaseTouchFromGraphWithClosestIndex: instead. Gets called when the user stops touching the graph.
 @deprecated Deprecated in 1.3. Use \p lineGraph:didReleaseTouchFromGraphWithClosestIndex: instead.
 @param index The closest index (X-axis) from the location the user last touched. */
- (void)didReleaseGraphWithClosestIndex:(float)index __deprecated;


/** \b DEPRECATED. Use \p numberOfGapsBetweenLabelsOnLineGraph: instead. The number of free space between labels on the X-axis to avoid overlapping.
 @deprecated Deprecated in 1.3. Use \p numberOfGapsBetweenLabelsOnLineGraph: instead.
 @discussion For example returning '1' would mean that half of the labels on the X-axis are not displayed: the first is not displayed, the second is, the third is not etc. Returning '0' would mean that all of the labels will be displayed. Finally, returning a value equal to the number of labels will only display the first and last label.
 @return The number of labels to "jump" between each displayed label on the X-axis. */
- (int)numberOfGapsBetweenLabels __deprecated;


/** \b DEPRECATED. Use \p lineGraph:labelOnXAxisForIndex: instead. The string to display on the label on the X-axis at a given index. Please note that the number of strings to be returned should be equal to the number of points in the Graph.
 @deprecated Deprecated in 1.3. Use \p lineGraph:labelOnXAxisForIndex: instead.
 @param index The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
- (NSString *)labelOnXAxisForIndex:(NSInteger)index __deprecated;


/** \b DEPRECATED. No longer available on \p BEMSimpleLineGraphDelegate. Implement this method on \p BEMSimpleLineGraphDataSource instead. The number of points along the X-axis of the graph.
 @deprecated Deprecated in 2.3. Implement with \p BEMSimpleLineGraphDataSource instead.
 
 @param graph The graph object requesting the total number of points.
 @return The total number of points in the line graph. */
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph __unavailable __deprecated;


/** \b DEPRECATED. No longer available on \p BEMSimpleLineGraphDelegate. Implement this method on \p BEMSimpleLineGraphDataSource instead. The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
 @deprecated Deprecated in 2.3. Implement with \p BEMSimpleLineGraphDataSource instead.
 
 @param graph The graph object requesting the point value.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index __unavailable __deprecated;


/** \b DEPRECATED. No longer available on \p BEMSimpleLineGraphDelegate. Implement this method on \p BEMSimpleLineGraphDataSource instead. The string to display on the label on the X-axis at a given index. Please note that the number of strings to be returned should be equal to the number of points in the Graph.
 @deprecated Deprecated in 2.3. Implement with \p BEMSimpleLineGraphDataSource instead.
 
 @param graph The graph object which is requesting the label on the specified X-Axis position.
 @param index The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index __unavailable __deprecated;


@end