//
//  BEMGraphCalculator.h
//  SimpleLineChart
//
//  Created by Sam Spencer on 1/26/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

@import Foundation;

#import "BEMSimpleLineGraphView.h"

/** There are multiple ways to find the area under the curve of a graph; \p BEMIntegrationMethod describes available methods for calculating this area.
 @discussion Finding the area under the curve of a graph becomes especially useful when charting rate over time. For example, finding the area of a graph that displays the speed of a cyclist at certain times would produce the total distance the cyclist traveled.
 @abstract Integration is a concept in calculus allowing one to find the area under a curve. However, integration requires manipulating the function of a graph. Because \p BEMSimpleLineGraphView objects rely on data points and not functions, other area-finding methods (with varying levels of accuracy) are employed here.
 @note As a general rule, the more accurate an integration method, the more computationally intense it may be. */
typedef NS_ENUM (NSInteger, BEMIntegrationMethod) {
    /// Calculates area by finding the sum of all left–hand rectangles under each data point. This method gives the exact area when the graph's curve is constant. Low intensity computation.
    BEMIntegrationMethodLeftReimannSum = 0,
    /// Calculates area by finding the sum of all right–hand rectangles under each data point. This method gives the exact area when the graph's curve is constant. Low intensity computation.
    BEMIntegrationMethodRightReimannSum = 1,
    /// Calculates area by finding the sum of all trapezoids under each data point. This method gives the exact area when the graph's curve is constant or linear. Moderate intensity computation.
    BEMIntegrationMethodTrapezoidalSum = 2,
    /// Calculates area by finding the sum of all parabolas under each data point. This method gives the exact area when the graph's curve is constant, linear, quadratic, or cubic. Moderate intensity computation.
    BEMIntegrationMethodParabolicSimpsonSum = 3
};

NS_ASSUME_NONNULL_BEGIN

/** Makes calculations given for a specific graph object. 
 @discussion Supply a graph object to the calculator to perform operations with that graph's data. Calculations may include the following:  
   - Average value of points
   - Sum of points  
   - Median of points  
   - Mode of points  
   - Graph standard deviation  
   - Minimum point value on graph  
   - Maximum point value on graph  
   - Area under the curve of a graph */
@interface BEMGraphCalculator : NSObject

+ (BEMGraphCalculator *)sharedCalculator;

/** Calculates the average (mean) of all points on the line graph.
 @return The average (mean) number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueAverageOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the sum of all points on the line graph.
 @return The sum of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueSumOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the median of all points on the line graph.
 @return The median number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueMedianOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the mode of all points on the line graph.
 @return The mode number of the points on the graph. Originally a float. */
- (NSNumber *)calculatePointValueModeOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the standard deviation of all points on the line graph.
 @return The standard deviation of the points on the graph. Originally a float. */
- (NSNumber *)calculateStandardDeviationOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the minimum value of all points on the line graph.
 @return The minimum number of the points on the graph. Originally a float. */
- (NSNumber *)calculateMinimumPointValueOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the maximum value of all points on the line graph.
 @return The maximum value of the points on the graph. Originally a float. */
- (NSNumber *)calculateMaximumPointValueOnGraph:(BEMSimpleLineGraphView *)graph;


/** Calculates the area under the curve of the graph.
 @return The area under the curve of the graph. Accuracy varies based on selected inetrgation method. Originally a float. */
- (NSNumber *)calculateAreaUsingIntegrationMethod:(BEMIntegrationMethod)integrationMethod onGraph:(BEMSimpleLineGraphView *)graph xAxisScale:(NSNumber *)scale;

@end

NS_ASSUME_NONNULL_END
