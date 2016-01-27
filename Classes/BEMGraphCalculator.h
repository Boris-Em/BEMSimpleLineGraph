//
//  BEMGraphCalculator.h
//  SimpleLineChart
//
//  Created by Sam Spencer on 1/26/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

@import Foundation;

#import "BEMSimpleLineGraphView.h"


/// Makes calculations given a specific graph object
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

@end
