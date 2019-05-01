//
//  BEMDelegate.swift
//  SimpleLineChart-Swift
//
//  Created by Sam Spencer on 4/30/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import Foundation

/// Line Graph Data Source. Used to populate the graph with data, similar to how a UITableView works.
public protocol LineGraphDataSource {

    //----- DATA POINTS -----//

    /** The number of points along the X-axis of the graph.
     
    - parameter graph: The graph object requesting the total number of points.
    - returns: The total number of points in the line graph. */
    func numberOfPoints(inLineGraph graph: LineGraph) -> Int

    /** The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
    - parameter graph: The graph object requesting the point value.
     - parameter index: The index from left to right of a given point (X-axis). The first value for the index is 0.
    - returns: The Y-axis value at a given index. */
    func lineGraph(_ graph: LineGraph, valueForPointAt index: Int) -> CGFloat

    
    //------- X AXIS -------//

    /** The string to display on the label on the X-axis at a given index.
     
    The number of strings to be returned should be equal to the number of points in the graph (returned in `numberOfPointsInLineGraph`). Otherwise, an exception may be thrown.
     
    - parameter graph: The graph object which is requesting the label on the specified X-Axis position.
    - parameter index: The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
    func lineGraph(_ graph: LineGraph, labelOnXAxisFor index: Int) -> String
}

/// Line Graph Delegate. Used to change the graph's appearance and recieve events, similar to how a UITableView works.
public protocol LineGraphDelegate {

    //----- GRAPH EVENTS -----//

    /** Sent to the delegate each time the line graph is loaded or reloaded.
    - seealso: lineGraphDidFinishLoading:
    - parameter graph: The graph object that is about to be loaded or reloaded. */
    func lineGraphDidBeginLoading(_ graph: LineGraph)

    /** Sent to the delegate each time the line graph finishes loading or reloading.
     The respective graph object's data has been loaded at this time. However, the graph may not be fully rendered. Use this method to update any content with the new graph object's data.
    - seealso: lineGraphDidBeginLoading: lineGraphDidFinishDrawing:
    - parameter graph: The graph object that finished loading or reloading. */
    func lineGraphDidFinishLoading(_ graph: LineGraph)

    /** Sent to the delegate each time the line graph finishes animating and drawing.
     The respective graph object has been completely drawn and animated at this point. It is safe to use \p graphSnapshotImage after recieving this method call on the delegate.
     This method may be called in addition to the \p lineGraphDidFinishLoading: method, after drawing has completed. \p animationGraphEntranceTime is taken into account when calling this method.
    - seealso: lineGraphDidFinishLoading:
    - parameter graph: The graph object that finished drawing. */
    func lineGraphDidFinishDrawing(_ graph: LineGraph)

    //----- CUSTOMIZATION -----//

    /** The optional text for the popup report.
    - parameter graph: The graph object requesting the total number of points.
    - returns: The text to substitute for the popup. If nil is returned, the popup text will be derived using the given data point and any supplied suffix and / or prefix. */
    func popUpTextForlineGraph(_ graph: LineGraph, at index: Int) -> String?

    /** The optional suffix to append to the popup report.
    - parameter graph: The graph object requesting the suffix.
    - returns: The suffix to append to the popup report. */
    func popUpSuffixForlineGraph(_ graph: LineGraph) -> String

    /** The optional prefix to append to the popup report.
    - parameter graph: The graph object requesting the prefix.
    - returns: The prefix to prepend to the popup report. */
    func popUpPrefixForlineGraph(_ graph: LineGraph) -> String

    /** Optional method to always display some of the pop up labels on the graph.
    - seealso: `alwaysDisplayPopUpLabels` must be set to true for this method to have any effect.
    - parameter graph: The graph object requesting the total number of points.
    - parameter index: The index from left to right of the points on the graph. The first value for the index is 0.
    - returns: Return true if you want the popup label to be displayed for this index. */
    func lineGraph(_ graph: LineGraph, alwaysDisplayPopUpAt index: Int) -> Bool

    /** Optional method to set the maximum value of the Y-Axis. If not implemented, the maximum value will be the biggest point of the graph.
    - parameter graph: The graph object requesting the maximum value.
    - returns: The maximum value of the Y-Axis. */
    func maxValue(forLineGraph graph: LineGraph) -> CGFloat

    /** Optional method to set the minimum value of the Y-Axis. If not implemented, the minimum value will be the smallest point of the graph.
    - parameter graph: The graph object requesting the minimum value.
    - returns: The minimum value of the Y-Axis. */
    func minValue(forLineGraph graph: LineGraph) -> CGFloat

    /** Optional method to set the average value for the Average line. If not implemented, the value will be the average point of the graph.
    - parameter graph: The graph object requesting the average value.
    - returns: The average value of the Y-Axis. */
    func averageValue(forLineGraph graph: LineGraph) -> CGFloat

    /** Optional method to control the text to be displayed on NO DATA label
    - parameter graph: The graph object for the NO DATA label
    - returns: The text to show on the NO DATA label. */
    func noDataLabelText(forLineGraph graph: LineGraph) -> String

    /** Optional method to set the static padding distance between the graph line and the whole graph
    - parameter graph: The graph object requesting the padding value.
    - returns: The padding value of the graph. */
    func staticPadding(forLineGraph graph: LineGraph) -> CGFloat

    /** Optional method to return a custom popup view to be used on the chart 
    - parameter graph: The graph object requesting the padding value.
    - returns: The custom popup view to use for the index. */
    func popUpView(forLineGraph graph: LineGraph) -> LineGraphPopupView

    /** Optional method that gets called if you are using a custom popup view.  This method allows you to modify your popup view for different graph indices.
    - parameter graph: The graph object requesting the padding value.
    - parameter popupView: The popup view owned by the graph that needs to be modified
    - parameter index: The index of the element associated with the popup view */
    func lineGraph(_ graph: LineGraph, modifyPopupView popupView: UIView, for index: Int)

    
    //----- TOUCH EVENTS -----//

    /** Sent to the delegate when the user starts touching the graph. The property 'enableTouchReport' must be set to YES.
    - parameter graph: The graph object which was touched by the user.
    - parameter index: The closest index (X-axis) from the location the user is currently touching. */
    func lineGraph(_ graph: LineGraph, didTouchGraphWithClosestIndex index: Int)

    /** Sent to the delegate when the user stops touching the graph.
    - parameter graph: The graph object which was touched by the user.
    - parameter index: The closest index (X-axis) from the location the user last touched. */
    func lineGraph(_ graph: LineGraph, didReleaseTouchFromGraphWithClosestIndex index: Int)

    
    //----- X AXIS -----//

    /** The number of free space between labels on the X-axis to avoid overlapping.
     For example returning '1' would mean that half of the labels on the X-axis are not displayed: the first is not displayed, the second is, the third is not etc. Returning '0' would mean that all of the labels will be displayed. Finally, returning a value equal to the number of labels will only display the first and last label.
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: The number of labels to "jump" between each displayed label on the X-axis. */
    func numberOfGapsBetweenLabels(onLineGraph graph: LineGraph) -> Int

    /** The starting index to plot X-Axis values.  MUST ALSO IMPLEMENT incrementIndexForXAxisOnLineGraph FOR THIS TO TAKE EFFECT
     This allows you to specify a custom starting index for drawing x axis labels
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: The graph data index to begin drawing labels */
    func baseIndexForXAxis(onLineGraph graph: LineGraph) -> Int

    /** The increment to apply when drawing X-Axis labels.  This increment is applied to the base x axis index.  MUST ALSO IMPLEMENT baseIndexForXAxisOnLineGraph FOR THIS TO TAKE EFFECT
     This allows you to set a custom interval in drawing x axis labels. When this is set in conjuction with baseIndexForXAxisOnLineGraph, `numberOfGapsBetweenLabelsOnLineGraph` is ignored
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: The increment between X-Axis labels */
    func incrementIndexForXAxis(onLineGraph graph: LineGraph) -> Int

    /** An array of graph indices where X-Axis labels should be drawn
     This allows high customization over where X-Axis labels can be placed.  They can be placed in non-consistent intervals. Additionally,
     it allows you to draw the X-Axis labels based on traits of your data (eg. when the date corresponding to the data becomes a new day).
     When this is set, `numberOfGapsBetweenLabelsOnLineGraph` is ignored
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: Array of graph indices to place X-Axis labels */
    func incrementPositionsForXAxis(onLineGraph graph: LineGraph) -> [NSNumber]

    //----- Y AXIS -----//

    /** The total number of Y-axis labels on the line graph.
     Calculates the total height of the graph and evenly spaces the labels based on the graph height. Default value is 3.
    - parameter graph: The graph object which is requesting the number of labels.
    - returns: The number of labels displayed on the Y-axis. */
    func numberOfYAxisLabels(onLineGraph graph: LineGraph) -> Int

    /** The optional prefix to append to the y axis.
    - parameter graph: The graph object requesting the total number of points.
    - returns: The prefix to prepend to append to the y axis. */
    func yAxisPrefix(onLineGraph graph: LineGraph) -> String

    /** The optional suffix to append to the y axis.
    - parameter graph: The graph object requesting the total number of points.
    - returns: The suffix to prepend to append to the y axis. */
    func yAxisSuffix(onLineGraph graph: LineGraph) -> String

    /** Starting value to begin drawing Y-Axis labels  MUST ALSO IMPLEMENT incrementValueForYAxisOnLineGraph FOR THIS TO TAKE EFFECT
     This allows you to finally hone the granularity of the data label.  Instead of drawing values like 11.24,
     you can lock these values to draw 11.20 to make it more user friendly.  When this is set, `numberOfYAxisLabelsOnLineGraph` is ignored.
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: The base value to draw the first Y-Axis label */
    func baseValueForYAxis(onLineGraph graph: LineGraph) -> CGFloat

    /** Increment value to apply to the base Y-Axis label.  MUST ALSO IMPLEMENT baseValueForYAxisOnLineGraph FOR THIS TO TAKE EFFECT
     This value tells the graph the interval to be applied to the base Y-Axis value.  This allows you to increment the Y-Axis via user-friendly values rather than values
     like 37.17.  This let's you enforce that your Y-Axis have values rounded to whatever granularity best fits your data.
    - parameter graph: The graph object which is requesting the number of gaps between the labels.
    - returns: The increment value to add to the value returned from `baseValueForYAxisOnLineGraph` for future Y-Axis labels */
    func incrementValueForYAxis(onLineGraph graph: LineGraph) -> CGFloat
}
