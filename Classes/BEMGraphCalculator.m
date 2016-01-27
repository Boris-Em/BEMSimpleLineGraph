//
//  BEMGraphCalculator.m
//  SimpleLineChart
//
//  Created by Sam Spencer on 1/26/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import "BEMGraphCalculator.h"

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
    return self;
}

- (NSArray *)calculationDataPointsOnGraph:(BEMSimpleLineGraphView *)graph {
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSNumber *value = (NSNumber *)evaluatedObject;
        BOOL retVal = ![value isEqualToNumber:@(BEMNullGraphValue)];
        return retVal;
    }];
    NSArray *filteredArray = [[graph graphValuesForDataPoints] filteredArrayUsingPredicate:filter];
    return filteredArray;
}

- (NSNumber *)calculatePointValueAverageOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"average:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueSumOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueMedianOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"median:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueModeOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"mode:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSMutableArray *value = [expression expressionValueWithObject:nil context:nil];
    
    return [value firstObject];
}

- (NSNumber *)calculateStandardDeviationOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"stddev:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculateMinimumPointValueOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    return value;
}

- (NSNumber *)calculateMaximumPointValueOnGraph:(BEMSimpleLineGraphView *)graph {
    NSArray *filteredArray = [self calculationDataPointsOnGraph:graph];
    if (filteredArray.count == 0) return 0;
    
    NSExpression *expression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

@end
