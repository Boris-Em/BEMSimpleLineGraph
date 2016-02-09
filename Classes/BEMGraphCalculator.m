//
//  BEMGraphCalculator.m
//  SimpleLineChart
//
//  Created by Sam Spencer on 1/26/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import "BEMGraphCalculator.h"

@interface BEMGraphCalculator ()
@property (nonatomic, strong) NSOperationQueue *calculationQueue;
@end

@implementation BEMGraphCalculator

+ (BEMGraphCalculator *)sharedCalculator {
    static BEMGraphCalculator *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _calculationQueue = [[NSOperationQueue alloc] init];
        _calculationQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    }
    return self;
}

- (nonnull NSArray *)calculationDataPointsOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSNumber *value = (NSNumber *)evaluatedObject;
        BOOL retVal = ![value isEqualToNumber:@(BEMNullGraphValue)];
        return retVal;
    }];
    NSArray *filteredArray = [[graph graphValuesForDataPoints] filteredArrayUsingPredicate:filter];
    return filteredArray;
}

- (nonnull NSNumber *)calculatePointValueAverageOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"average:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (nonnull NSNumber *)calculatePointValueSumOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (nonnull NSNumber *)calculatePointValueMedianOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"median:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (nonnull NSNumber *)calculatePointValueModeOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"mode:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSMutableArray *value = [expression expressionValueWithObject:nil context:nil];
    
    return [value firstObject];
}

- (nonnull NSNumber *)calculateStandardDeviationOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"stddev:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (nonnull NSNumber *)calculateMinimumPointValueOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    return value;
}

- (nonnull NSNumber *)calculateMaximumPointValueOnGraph:(nonnull BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (nonnull NSNumber *)calculateAreaUsingIntegrationMethod:(BEMIntegrationMethod)integrationMethod onGraph:(nonnull BEMSimpleLineGraphView *)graph xAxisScale:(nonnull NSNumber *)scale {
    NSArray *fixedDataPoints = [self calculationDataPointsOnGraph:graph];
    if (integrationMethod == BEMIntegrationMethodLeftReimannSum) return [self integrateUsingLeftReimannSum:fixedDataPoints xAxisScale:scale];
    else if (integrationMethod == BEMIntegrationMethodRightReimannSum) return [self integrateUsingRightReimannSum:fixedDataPoints xAxisScale:scale];
    else if (integrationMethod == BEMIntegrationMethodTrapezoidalSum) return [self integrateUsingTrapezoidalSum:fixedDataPoints xAxisScale:scale];
    else if (integrationMethod == BEMIntegrationMethodParabolicSimpsonSum) return [self integrateUsingParabolicSimpsonSum:fixedDataPoints xAxisScale:scale];
    else return [NSNumber numberWithInt:0];
}

- (NSNumber *)integrateUsingLeftReimannSum:(nonnull NSArray *)graphPoints xAxisScale:(nonnull NSNumber *)scale {
    NSNumber *totalArea = [NSNumber numberWithInt:0];
    
    NSMutableArray *leftSumPoints = graphPoints.mutableCopy;
    [leftSumPoints removeLastObject];
    
    for (NSNumber *yValue in leftSumPoints) {
        NSNumber *newAreaUnit = [NSNumber numberWithFloat:yValue.floatValue * scale.floatValue];
        totalArea = [NSNumber numberWithFloat:totalArea.floatValue + newAreaUnit.floatValue];
    }
    
    return totalArea;
}

- (NSNumber *)integrateUsingRightReimannSum:(nonnull NSArray *)graphPoints xAxisScale:(nonnull NSNumber *)scale {
    NSNumber *totalArea = [NSNumber numberWithInt:0];
    
    NSMutableArray *rightSumPoints = graphPoints.mutableCopy;
    [rightSumPoints removeObjectAtIndex:0];
    
    for (NSNumber *yValue in rightSumPoints) {
        NSNumber *newAreaUnit = [NSNumber numberWithFloat:yValue.floatValue * scale.floatValue];
        totalArea = [NSNumber numberWithFloat:totalArea.floatValue + newAreaUnit.floatValue];
    }
    
    return totalArea;
}

- (NSNumber *)integrateUsingTrapezoidalSum:(nonnull NSArray *)graphPoints xAxisScale:(nonnull NSNumber *)scale {
    NSNumber *left = [self integrateUsingLeftReimannSum:graphPoints xAxisScale:scale];
    NSNumber *right = [self integrateUsingRightReimannSum:graphPoints xAxisScale:scale];
    NSNumber *trapezoidal = [NSNumber numberWithFloat:(left.floatValue+right.floatValue)/2];
    return trapezoidal;
}

- (NSNumber *)integrateUsingParabolicSimpsonSum:(nonnull NSArray *)points xAxisScale:(nonnull NSNumber *)scale {
    // Get all the points from the graph into a mutable array
    NSMutableArray *graphPoints = points.mutableCopy;
    
    // If there are two or fewer points on the graph, no parabolic curve can be created. Thus, the next most accurate method will be employed: a trapezoidal summation
    if (graphPoints.count <= 2) return [self integrateUsingTrapezoidalSum:points xAxisScale:scale];
    
    // If there are only three points in the array, do a simple single parabolic calculation
    if (graphPoints.count == 3) {
        NSNumber *firstPoint = graphPoints.firstObject;
        NSNumber *thirdPoint = graphPoints.lastObject;
        NSNumber *midPoint = [graphPoints objectAtIndex:1];
        
        NSNumber *graphArea = [NSNumber numberWithFloat:((firstPoint.floatValue + (midPoint.floatValue * thirdPoint.floatValue) + thirdPoint.floatValue)/3) * scale.floatValue];
        return graphArea;
    }
    
    // The submitted graph has not met the above two conditions and thus has more than three points
    NSNumber *totalArea = [NSNumber numberWithFloat:0];
    
    // Because the parabolic calculation works in sets of threes, we need to check if the data set has any remainders after dividing by three
    if (graphPoints.count % 3 == 1) {
        NSNumber *firstPoint = graphPoints.firstObject;
        NSNumber *newAreaUnit = [NSNumber numberWithFloat:firstPoint.floatValue * scale.floatValue];
        totalArea = [NSNumber numberWithFloat:totalArea.floatValue + newAreaUnit.floatValue];
        
        // Now that we've used the first point and added it up, remove it from the array
        [graphPoints removeObjectAtIndex:0];
    } else if (graphPoints.count % 3 == 2) {
        NSNumber *firstPoint = graphPoints.firstObject;
        NSNumber *secondPoint = [graphPoints objectAtIndex:1];
        NSNumber *newAreaUnit = [NSNumber numberWithFloat:((firstPoint.floatValue + secondPoint.floatValue) * scale.floatValue)/2];
        totalArea = [NSNumber numberWithFloat:totalArea.floatValue + newAreaUnit.floatValue];
        
        // Now that we've used the first and second points and added them up, remove them from the array
        [graphPoints removeObjectAtIndex:0];
        [graphPoints removeObjectAtIndex:0];
    }
    
    // Loop through the data points three at a time
    for (NSInteger index = 0; index < graphPoints.count; index = index + 3) {
        NSNumber *firstPoint = [graphPoints objectAtIndex:index];
        NSNumber *thirdPoint = [graphPoints objectAtIndex:index+2];
        NSNumber *midPoint = [graphPoints objectAtIndex:index+1];
        
        NSNumber *parabolaArea = [NSNumber numberWithFloat:((firstPoint.floatValue + (midPoint.floatValue * thirdPoint.floatValue) + thirdPoint.floatValue)/3) * scale.floatValue];
        totalArea = [NSNumber numberWithFloat:totalArea.floatValue + parabolaArea.floatValue];
    }
    
    return totalArea;
}

@end
