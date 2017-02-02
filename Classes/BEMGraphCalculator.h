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

/** There are multiple methods to determine the correlation between points on a graph; \p BEMCorrelationMethod describes available methods for determining this coefficient.
 @discussion Discussion on data correlation to be added.
 @abstract Abstract on data correlation to be added.
 @note The greater the number of points on the given graph, the longer it may take to determine a correlation for those points.  */
typedef NS_ENUM (NSInteger, BEMCorrelationMethod) {
    /// Calculates the correlation coefficent for the graph using the common Pearson Correlation Method.
    BEMCorrelationMethodPearson = 0
};

/** When calculating a correlation coefficient with the Pearson Correlation Method, \p BEMGraphCalculator can provide more general feedback as to the strength of the correlation. */
typedef NS_ENUM (NSInteger, BEMPearsonCorrelationStrength) {
    /// Positive correlation value: 1.00 : 0.95
    BEMPearsonCorrelationPerfectPositive = 0,
    /// Positive correlation value: 0.94 : 0.50
    BEMPearsonCorrelationStrongPositive = 1,
    /// Positive correlation value: 0.49 : 0.06
    BEMPearsonCorrelationWeakPositive = 2,
    /// Positive correlation value: 0.05 : -0.05
    BEMPearsonCorrelationNone = 3,
    /// Positive correlation value: -0.06 : -0.49
    BEMPearsonCorrelationWeakNegative = 4,
    /// Positive correlation value: -0.50 : -0.94
    BEMPearsonCorrelationStrongNegative = 5,
    /// Positive correlation value: -0.95 : -1.00
    BEMPearsonCorrelationPerfectNegative = 6
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
   - Area under the curve of a graph  
   - Correlation of data points */
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
 @return The area under the curve of the graph. Accuracy varies based on selected integration method. Originally a float. */
- (NSNumber *)calculateAreaUsingIntegrationMethod:(BEMIntegrationMethod)integrationMethod onGraph:(BEMSimpleLineGraphView *)graph xAxisScale:(NSNumber *)scale;


/** Calculates a correlation coefficient for the data points on the graph.
 @return A correlation coefficient, calculated from the graph's data points. Float value between -1.0 and 1.0. A value of -1.0 is a perfect negative correlation. A value of 1.0 is a perfect positive correlation. A value of 0.0 means that no correlation exists. */
- (NSNumber *)calculateCorrelationCoefficientUsingCorrelationMethod:(BEMCorrelationMethod)correlationMethod onGraph:(BEMSimpleLineGraphView *)graph xAxisScale:(nonnull NSNumber *)scale;


/** Calculates a correlation coefficient and returns the general strength of the correlation, based on the data points on the given graph object.
 @return The strength of the calculated correlation coefficient; calculated from the graph's data points. This method assumes the Pearson Correlation Method. */
- (BEMPearsonCorrelationStrength)calculatePearsonCorrelationStrengthOnGraph:(BEMSimpleLineGraphView *)graph xAxisScale:(nonnull NSNumber *)scale;


/** Calculates a correlation coefficient and returns the general strength of the correlation, based on the data points on the given graph object.
 @return The strength of the calculated correlation coefficient; calculated from the graph's data points. This method assumes the Pearson Correlation Method. */
- (BEMPearsonCorrelationStrength)calculatePearsonCorrelationStrengthOnGraph:(BEMSimpleLineGraphView *)graph;

@end

NS_ASSUME_NONNULL_END
