//
//  BEMSimpleLineGraphView.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

#import "BEMCircle.h"
#import "BEMLine.h"
#import "BEMPermanentPopupView.h"
#import "BEMAverageLine.h"

@protocol BEMSimpleLineGraphDelegate;
@protocol BEMSimpleLineGraphDataSource;
@protocol BEMSimpleLineGraphPopoverProtocol;


extern const CGFloat BEMNullGraphValue;

// Tell the compiler to assume that no method should have a NULL value
NS_ASSUME_NONNULL_BEGIN

/// Simple line graph / chart UIView subclass for iOS apps. Creates beautiful line graphs (without huge memory impacts) using QuartzCore.
IB_DESIGNABLE @interface BEMSimpleLineGraphView : UIView <UIGestureRecognizerDelegate>



//------------------------------------------------------------------------------------//
//----- DELEGATE ---------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/** The object that acts as the delegate of the receiving line graph.
 
 @abstract The BEMSimpleLineGraphView delegate object plays a key role in changing the appearance of the graph and receiving graph events. Use the delegate to provide appearance changes, receive touch events, and receive graph events. The delegate can be set from the interface or from code.
 @discussion The delegate must adopt the \p BEMSimpleLineGraphDelegate protocol. The delegate is not retained.*/
@property (nonatomic, weak, nullable) IBOutlet id <BEMSimpleLineGraphDelegate> delegate;



//------------------------------------------------------------------------------------//
//----- DATA SOURCE ------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/** The object that acts as the data source of the receiving line graph.
 
 @abstract The BEMSimpleLineGraphView data source object is essential to the line graph. Use the data source to provide the graph with data (data points and x-axis labels). The delegate can be set from the interface or from code.
 @discussion The data source must adopt the \p BEMSimpleLineGraphDataSource protocol. The data source is not retained.*/
@property (nonatomic, weak) IBOutlet id <BEMSimpleLineGraphDataSource> dataSource;



//------------------------------------------------------------------------------------//
//----- METHODS ----------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/// Reload the graph, all delegate methods are called again and the graph is reloaded. Similar to calling reloadData on a UITableView.
- (void)reloadGraph;


/** Calculates the distance between the touch input and the closest point on the graph.
 @return The distance between the touch input and the closest point on the graph. */
- (CGFloat)distanceToClosestPoint __deprecated;


/** Takes a snapshot of the graph while the app is in the foreground.
 @return The snapshot of the graph as a UIImage object. */
- (UIImage *)graphSnapshotImage NS_AVAILABLE_IOS(7_0);


/** Takes a snapshot of the graph.
 @param appIsInBackground If your app is currently in the background state, pass YES to \p appIsInBackground. Otherwise, when your app is in the foreground you should take advantage of more efficient APIs by passing NO to \p appIsInBackground.
 @return The snapshot of the graph as a UIImage object. */
- (UIImage *)graphSnapshotImageRenderedWhileInBackground:(BOOL)appIsInBackground NS_AVAILABLE_IOS(7_0);


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
- (nullable NSArray *)graphValuesForXAxis;


/** All the data points on the graph.
 @return An array of NSNumbers, one for each data point. The array is sorted from the left side of the graph to the right side. */
- (nullable NSArray *)graphValuesForDataPoints;


/** All the labels of the X-Axis.
 @return An array of UILabels, one for each displayed X-Axis label. The array is sorted from the left side of the graph to the right side. */
- (nullable NSArray *)graphLabelsForXAxis;



//------------------------------------------------------------------------------------//
//----- PROPERTIES -------------------------------------------------------------------//
//------------------------------------------------------------------------------------//


/// The graph's label font used on various axis. This property may be privately overwritten, do not expect full functionality from this property.
@property (strong, nonatomic, nullable) UIFont *labelFont;


/// Time of the animation when the graph appears in seconds. Default value is 1.5.
@property (nonatomic) CGFloat animationGraphEntranceTime;


/** Animation style used when the graph appears. Default value is BEMLineAnimationDraw.
 @see Refer to \p BEMLineAnimation for a complete list of animation styles. */
@property (nonatomic) BEMLineAnimation animationGraphStyle;


/// If set to YES, the graph will report the value of the closest point from the user current touch location. The 2 methods for touch event bellow should therefore be implemented. Default value is NO.
@property (nonatomic) BOOL enableTouchReport;


/** The number of fingers required to report touches to the graph's delegate. The default value is 1.
 @discussion Setting this value to greater than 1 might be beneficial in interfaces that allow the graph to scroll and still want to use touch reporting. */
@property (nonatomic) NSInteger touchReportFingersRequired;


/// If set to YES, a label will pop up on the graph when the user touches it. It will be displayed on top of the closest point from the user current touch location. Default value is NO.
@property (nonatomic) BOOL enablePopUpReport;


/// The way the graph is drawn, with or without bezier curved lines. Default value is NO.
@property (nonatomic) IBInspectable BOOL enableBezierCurve;


/** Show Y-Axis label on the side. Default value is NO.
 @todo Could enhance further by specifying the position of Y-Axis, i.e. Left or Right of the view.  Also auto detection on label overlapping. */
@property (nonatomic) IBInspectable BOOL enableYAxisLabel;


/** Show X-Axis label at the bottom of the graph. Default value is YES.
 @see \p labelOnXAxisForIndex */
 @property (nonatomic) IBInspectable BOOL enableXAxisLabel;


/** When set to YES, the points on the Y-axis will be set to all fit in the graph view. When set to NO, the points on the Y-axis will be set with their absolute value (which means that certain points might not be visible because they are outside of the view). Default value is YES. */
@property (nonatomic) BOOL autoScaleYAxis;


/// The horizontal line across the graph at the average value.
@property (strong, nonatomic) BEMAverageLine *averageLine;


/// Draws a translucent vertical lines along the graph for each X-Axis when set to YES. Default value is NO.
@property (nonatomic) BOOL enableReferenceXAxisLines;


/// Draws a translucent horizontal lines along the graph for each Y-Axis label, when set to YES. Default value is NO.
@property (nonatomic) BOOL enableReferenceYAxisLines;


/** Draws a translucent frame between the graph and any enabled axis, when set to YES. Default value is NO.
 @see enableReferenceXAxisLines or enableReferenceYAxisLines must be set to YES for this property to have any effect.  */
@property (nonatomic) BOOL enableReferenceAxisFrame;


/** If reference frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (nonatomic) BOOL enableLeftReferenceAxisFrameLine;


/** If reference frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (nonatomic) BOOL enableBottomReferenceAxisFrameLine;


/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (nonatomic) BOOL enableRightReferenceAxisFrameLine;


/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (nonatomic) BOOL enableTopReferenceAxisFrameLine;


/// If set to YES, the dots representing the points on the graph will always be visible. Default value is NO.
@property (nonatomic) BOOL alwaysDisplayDots;

/// If set to YES, the dots will be drawn during the animation.  If NO, dots won't show up for the animation if alwaysDisplayDots if false.  Default value is YES
@property (nonatomic) BOOL displayDotsWhileAnimating;


/// If set to YES, pop up labels with the Y-value of the point will always be visible. Default value is NO.
@property (nonatomic) BOOL alwaysDisplayPopUpLabels;


/// Color of the bottom part of the graph (between the line and the X-axis).
@property (strong, nonatomic) IBInspectable UIColor *colorBottom;


/// Alpha of the bottom part of the graph (between the line and the X-axis).
@property (nonatomic) IBInspectable CGFloat alphaBottom;


/// Fill gradient of the bottom part of the graph (between the line and the X-axis). When set, it will draw a gradient over top of the fill provided by the \p colorBottom and \p alphaBottom properties.
@property (assign, nonatomic) CGGradientRef gradientBottom;


/// Color of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (strong, nonatomic) IBInspectable UIColor *colorTop;


/// Alpha of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (nonatomic) IBInspectable CGFloat alphaTop;


/// Fill gradient of the top part of the graph (between the line and the top of the view the graph is drawn in). When set, it will draw a gradient over top of the fill provided by the \p colorTop and \p alphaTop properties.
@property (assign, nonatomic) CGGradientRef gradientTop;


/// Color of the line of the graph.
@property (strong, nonatomic) IBInspectable UIColor *colorLine;


/// Fill gradient of the line of the graph, which will be scaled to the length of the graph. Overrides the line color provided by \p colorLine
@property (assign, nonatomic) CGGradientRef gradientLine;


/// The drawing direction of the line gradient color, which defaults to horizontal
@property (nonatomic) BEMLineGradientDirection gradientLineDirection;


/// Alpha of the line of the graph.
@property (nonatomic) IBInspectable CGFloat alphaLine;


/// Width of the line of the graph. Default value is 1.0.
@property (nonatomic) IBInspectable CGFloat widthLine;


/// Width of the reference lines of the graph. Default is the value of widthLine/2.
@property (nonatomic) IBInspectable CGFloat widthReferenceLines;


/// Color of the reference lines of the graph. Default is same color as `colorLine`.
@property (strong, nonatomic) UIColor *colorReferenceLines;


/// The size of the circles that represent each point. Default is 10.0.
@property (nonatomic) IBInspectable CGFloat sizePoint;


/// The color of the circles that represent each point. Default is white at 70% alpha.
@property (strong, nonatomic) IBInspectable UIColor *colorPoint;


/// The color of the line that appears when the user touches the graph.
@property (strong, nonatomic) UIColor *colorTouchInputLine;


/// The alpha of the line that appears when the user touches the graph.
@property (nonatomic) CGFloat alphaTouchInputLine;


/// The width of the line that appears when the user touches the graph.
@property (nonatomic) CGFloat widthTouchInputLine;


/// Color of the label's text displayed on the X-Axis. Defaut value is blackColor.
@property (strong, nonatomic) IBInspectable UIColor *colorXaxisLabel;


/// Color of the background of the X-Axis
@property (strong, nonatomic) UIColor *colorBackgroundXaxis;


/// Alpha of the background of the X-Axis
@property (nonatomic) CGFloat alphaBackgroundXaxis;


/// Color of the background of the Y-Axis
@property (strong, nonatomic) UIColor *colorBackgroundYaxis;


/// Alpha of the background of the Y-Axis
@property (nonatomic) CGFloat alphaBackgroundYaxis;


/// Color of the label's text displayed on the Y-Axis. Defaut value is blackColor.
@property (strong, nonatomic) IBInspectable UIColor *colorYaxisLabel;


/// Color of the pop up label's background displayed when the user touches the graph.
@property (strong, nonatomic) UIColor *colorBackgroundPopUplabel;


/// Position of the y-Axis in relation to the chart (Default: NO)
@property (nonatomic) BOOL positionYAxisRight;


/// A line dash patter to be applied to X axis reference lines.  This allows you to draw a dotted or hashed line
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceXAxisLines;


/// A line dash patter to be applied to Y axis reference lines.  This allows you to draw a dotted or hashed line
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceYAxisLines;


/// Color to be used for the no data label on the chart
@property (nonatomic, strong) UIColor *noDataLabelColor;


/// Font to be used for the no data label on the chart
@property (nonatomic, strong) UIFont *noDataLabelFont;


/// Float format string to be used when formatting popover and y axis values
@property (nonatomic, strong) NSString *formatStringForValues;


/** If a null value is present, interpolation would draw a best fit line through the null point bound by its surrounding points.  Default: YES*/
@property (nonatomic) BOOL interpolateNullValues;


/// When set to YES, dots will be displayed at full opacity and no line will be drawn through the dots. Default value is NO.
@property (nonatomic) BOOL displayDotsOnly;


@end



@interface BEMSimpleLineGraphPopoverView : UIView


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
- (nullable NSString *)lineGraph:(nonnull BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index;


@end



/// Line Graph Delegate. Used to change the graph's appearance and recieve events, similar to how a UITableView works.
@protocol BEMSimpleLineGraphDelegate <NSObject>


@optional



//----- GRAPH EVENTS -----//


/** Sent to the delegate each time the line graph is loaded or reloaded.
 @seealso lineGraphDidFinishLoading:
 @param graph The graph object that is about to be loaded or reloaded. */
- (void)lineGraphDidBeginLoading:(BEMSimpleLineGraphView *)graph;


/** Sent to the delegate each time the line graph finishes loading or reloading.
 @discussion The respective graph object's data has been loaded at this time. However, the graph may not be fully rendered. Use this method to update any content with the new graph object's data.
 
 @seealso lineGraphDidBeginLoading: lineGraphDidFinishDrawing:
 @param graph The graph object that finished loading or reloading. */
- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph;


/** Sent to the delegate each time the line graph finishes animating and drawing.
 @discussion The respective graph object has been completely drawn and animated at this point. It is safe to use \p graphSnapshotImage after recieving this method call on the delegate.
 
 This method may be called in addition to the \p lineGraphDidFinishLoading: method, after drawing has completed. \p animationGraphEntranceTime is taken into account when calling this method.
 
 @seealso lineGraphDidFinishLoading:
 @param graph The graph object that finished drawing. */
- (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph;


//----- CUSTOMIZATION -----//


/** The optional suffix to append to the popup report.
 @param graph The graph object requesting the total number of points.
 @return The suffix to append to the popup report. */
- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph;


/** The optional prefix to append to the popup report.
 @param graph The graph object requesting the total number of points.
 @return The prefix to prepend to the popup report. */
- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph;


/** Optional method to always display some of the pop up labels on the graph.
 @see alwaysDisplayPopUpLabels must be set to YES for this method to have any effect.
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


/** Optional method to control whether a label indicating NO DATA will be shown while number of data is zero
 @param graph The graph object for the NO DATA label
 @return The boolean value indicating the availability of the NO DATA label. */
- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph;


/** Optional method to control the text to be displayed on NO DATA label
 @param graph The graph object for the NO DATA label
 @return The text to show on the NO DATA label. */
- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph;


/** Optional method to set the static padding distance between the graph line and the whole graph
 @param graph The graph object requesting the padding value.
 @return The padding value of the graph. */
- (CGFloat)staticPaddingForLineGraph:(BEMSimpleLineGraphView *)graph;


/** Optional method to return a custom popup view to be used on the chart 
 @param graph The graph object requesting the padding value.
 @return The custom popup view to use */
- (UIView *)popUpViewForLineGraph:(BEMSimpleLineGraphView *)graph;


/** Optional method that gets called if you are using a custom popup view.  This method allows you to modify your popup view for different graph indices
 @param graph The graph object requesting the padding value.
 @param popupView The popup view owned by the graph that needs to be modified
 @param index The index of the element associated with the popup view
 @return The custom popup view to use */
- (void)lineGraph:(BEMSimpleLineGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index;


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


/** The starting index to plot X-Axis values.  MUST ALSO IMPLEMENT incrementIndexForXAxisOnLineGraph FOR THIS TO TAKE EFFECT
 @discussion This allows you to specify a custom starting index for drawing x axis labels
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return The graph data index to begin drawing labels */
- (NSInteger)baseIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** The increment to apply when drawing X-Axis labels.  This increment is applied to the base x axis index.  MUST ALSO IMPLEMENT baseIndexForXAxisOnLineGraph FOR THIS TO TAKE EFFECT
 @discussion This allows you to set a custom interval in drawing x axis labels. When this is set in conjuction with baseIndexForXAxisOnLineGraph, `numberOfGapsBetweenLabelsOnLineGraph` is ignored
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return The increment between X-Axis labels */
- (NSInteger)incrementIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** An array of graph indices where X-Axis labels should be drawn
 @discussion This allows high customization over where X-Axis labels can be placed.  They can be placed in non-consistent intervals. Additionally,
    it allows you to draw the X-Axis labels based on traits of your data (eg. when the date corresponding to the data becomes a new day). 
    When this is set, `numberOfGapsBetweenLabelsOnLineGraph` is ignored
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return Array of graph indices to place X-Axis labels */
- (NSArray *)incrementPositionsForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph;



//----- Y AXIS -----//


/** The total number of Y-axis labels on the line graph.
 @discussion Calculates the total height of the graph and evenly spaces the labels based on the graph height. Default value is 3.
 @param graph The graph object which is requesting the number of labels.
 @return The number of labels displayed on the Y-axis. */
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** The optional prefix to append to the y axis.
 @param graph The graph object requesting the total number of points.
 @return The prefix to prepend to append to the y axis. */
- (NSString *)yAxisPrefixOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** The optional suffix to append to the y axis.
 @param graph The graph object requesting the total number of points.
 @return The suffix to prepend to append to the y axis. */
- (NSString *)yAxisSuffixOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** Starting value to begin drawing Y-Axis labels  MUST ALSO IMPLEMENT incrementValueForYAxisOnLineGraph FOR THIS TO TAKE EFFECT
 @discussion This allows you to finally hone the granularity of the data label.  Instead of drawing values like 11.24, 
    you can lock these values to draw 11.20 to make it more user friendly.  When this is set, `numberOfYAxisLabelsOnLineGraph` is ignored.
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return The base value to draw the first Y-Axis label */
- (CGFloat)baseValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph;


/** Increment value to apply to the base Y-Axis label.  MUST ALSO IMPLEMENT baseValueForYAxisOnLineGraph FOR THIS TO TAKE EFFECT
 @discussion This value tells the graph the interval to be applied to the base Y-Axis value.  This allows you to increment the Y-Axis via user-friendly values rather than values
    like 37.17.  This let's you enforce that your Y-Axis have values rounded to whatever granularity best fits your data.
 @param graph The graph object which is requesting the number of gaps between the labels.
 @return The increment value to add to the value returned from `baseValueForYAxisOnLineGraph` for future Y-Axis labels */
- (CGFloat)incrementValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph;




//----- DEPRECATED -----//


/** \b DEPRECATED. Use \p numberOfPointsInLineGraph: instead. The number of points along the X-axis of the graph.
 @warning This method will be removed in the next version with breaking changes.
 @deprecated Deprecated in 1.3. Use \p numberOfPointsInLineGraph: instead.
 @return Number of points. */
- (int)numberOfPointsInGraph __deprecated;


/** \b DEPRECATED. Use \p lineGraph:valueForPointAtIndex: instead.
 @warning This method will be removed in the next version with breaking changes.
 @deprecated Deprecated in 1.3. Use \p lineGraph:valueForPointAtIndex: instead.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (float)valueForIndex:(NSInteger)index __deprecated;


/** \b DEPRECATED. Use \p lineGraph:didTouchGraphWithClosestIndex: instead. Gets called when the user starts touching the graph. The property 'enableTouchReport' must be set to YES.
 @warning This method will be removed in the next version with breaking changes.
 @deprecated Deprecated in 1.3. Use \p lineGraph:didTouchGraphWithClosestIndex: instead.
 @param index The closest index (X-axis) from the location the user is currently touching. */
- (void)didTouchGraphWithClosestIndex:(int)index __deprecated;


/** \b DEPRECATED. Use \p lineGraph:didReleaseTouchFromGraphWithClosestIndex: instead. Gets called when the user stops touching the graph.
 @warning This method will be removed in the next version with breaking changes.
 @deprecated Deprecated in 1.3. Use \p lineGraph:didReleaseTouchFromGraphWithClosestIndex: instead.
 @param index The closest index (X-axis) from the location the user last touched. */
- (void)didReleaseGraphWithClosestIndex:(float)index __deprecated;


/** \b DEPRECATED. Use \p numberOfGapsBetweenLabelsOnLineGraph: instead. The number of free space between labels on the X-axis to avoid overlapping.
 @warning This method will be removed in the next version with breaking changes.
 @deprecated Deprecated in 1.3. Use \p numberOfGapsBetweenLabelsOnLineGraph: instead.
 @discussion For example returning '1' would mean that half of the labels on the X-axis are not displayed: the first is not displayed, the second is, the third is not etc. Returning '0' would mean that all of the labels will be displayed. Finally, returning a value equal to the number of labels will only display the first and last label.
 @return The number of labels to "jump" between each displayed label on the X-axis. */
- (int)numberOfGapsBetweenLabels __deprecated;


/** \b DEPRECATED. Use \p lineGraph:labelOnXAxisForIndex: instead. The string to display on the label on the X-axis at a given index. Please note that the number of strings to be returned should be equal to the number of points in the Graph.
 @warning This method will be removed in the next version with breaking changes.
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


NS_ASSUME_NONNULL_END

@end