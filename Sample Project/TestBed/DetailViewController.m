//
//  DetailViewController.m
//  SimpleLineChart
//
//  Created by Hugh Mackworth on 5/19/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

#import "DetailViewController.h"
#import "StatsViewController.h"
#import "BEMGraphCalculator.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;
@property (nonatomic) NSInteger previousStepperValue;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property (strong, nonatomic) IBOutlet UILabel *labelValues;
@property (strong, nonatomic) IBOutlet UILabel *labelDates;

@property (nonatomic) NSInteger totalNumber;

@property (strong, nonatomic) IBOutlet UIView * customView;
@property (weak, nonatomic) IBOutlet UILabel * customViewLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;

    self.maxValue = -1.0;
    self.minValue = -1.0;
    self.staticPaddingValue = -1.0;
    self.numberOfGapsBetweenLabels = NSNotFound;
    self.baseIndexForXAxis = NSNotFound;
    self.incrementIndexForXAxis = NSNotFound;
    self.numberOfYAxisLabels = NSNotFound;
    self.baseValueForYAxis = -1.0;
    self.incrementValueForYAxis = -1.0;
    // Do any additional setup after loading the view.


    [self hydrateDatasets];

    [self updateLabelsBelowGraph:self.myGraph];
}

// MARK: - Data management
- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];

    self.totalNumber = 0;
    NSDate *baseDate = [NSDate date];
    BOOL showNullValue = YES;
    self.graphObjectIncrement.value = 9;
    self.previousStepperValue = self.graphObjectIncrement.value;

    // Add objects to the array based on the stepper value
    for (int i = 0; i < 9; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloat])]; // Random values for the graph
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
        }
        if (showNullValue && (i % 4 == 0)) {
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            self.totalNumber = self.totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }

    }
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

// MARK: - Graph Actions

// Refresh the line graph using the specified properties
- (IBAction)refresh:(id)sender {
    [self hydrateDatasets];
    [self.myGraph reloadGraph];
}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}

- (IBAction)addOrRemovePointFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > self.previousStepperValue) {
        [self addPointToGraph];
    } else if (self.graphObjectIncrement.value < self.previousStepperValue) {
        [self removePointFromGraph];
    }
    self.previousStepperValue = self.graphObjectIncrement.value;
}

- (void) addPointToGraph {
    // Add point
    NSNumber * newValue ;
    if (self.arrayOfValues.count % 4 == 0) {
        newValue = @(BEMNullGraphValue);
    } else {
        newValue = @([self getRandomFloat]);
    }
    [self.arrayOfValues addObject:newValue];
    NSDate *lastDate = self.arrayOfDates.count > 0 ? [self.arrayOfDates lastObject]: [NSDate date];
    NSDate *newDate = [self dateForGraphAfterDate:lastDate];
    [self.arrayOfDates addObject:newDate];
    [self.myGraph reloadGraph];
}

- (void) removePointFromGraph {
    if (self.arrayOfValues.count > 0) {
        // Remove point
        [self.arrayOfValues removeObjectAtIndex:0];
        [self.arrayOfDates removeObjectAtIndex:0];
        [self.myGraph reloadGraph];
    }
}
- (NSString *)formatNumber: (NSNumber *) number {
    return [NSNumberFormatter localizedStringFromNumber:number
                                                         numberStyle:NSNumberFormatterDecimalStyle];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"showStats"]) {
        BEMGraphCalculator * calc = [BEMGraphCalculator sharedCalculator];
        StatsViewController *controller = (StatsViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        controller.standardDeviation =  [self formatNumber:[calc calculateStandardDeviationOnGraph:self.myGraph]];
        controller.average =            [self formatNumber:[calc calculatePointValueAverageOnGraph:self.myGraph]];
        controller.median =             [self formatNumber:[calc calculatePointValueMedianOnGraph: self.myGraph]];
        controller.mode =               [self formatNumber:[calc calculatePointValueModeOnGraph:   self.myGraph]];
        controller.minimum =            [self formatNumber:[calc calculateMinimumPointValueOnGraph:self.myGraph]];
        controller.maximum =            [self formatNumber:[calc calculateMaximumPointValueOnGraph:self.myGraph]];
        controller.snapshotImage =      [self.myGraph graphSnapshotImage];
    }
}


// MARK: - SimpleLineGraph Data Source

- (NSUInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSUInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

// MARK: - SimpleLineGraph Delegate

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(popUpTextForlineGraph:atIndex:)) {
        return self.popUpText.length > 0;
    } else if (aSelector == @selector(popUpPrefixForlineGraph:)) {
        return self.popUpPrefix.length > 0;
    } else if (aSelector == @selector(popUpSuffixForlineGraph:)) {
        return self.popUpSuffix.length > 0;
    } else if (aSelector == @selector(lineGraph:alwaysDisplayPopUpAtIndex:)) {
        return self.testAlwaysDisplayPopup;
    } else if (aSelector == @selector(maxValueForLineGraph:)) {
        return self.maxValue >= 0.0;
    } else if (aSelector == @selector(minValueForLineGraph:)) {
        return self.minValue >= 0.0;
    } else if (aSelector == @selector(noDataLabelTextForLineGraph:)) {
        return self.noDataText.length > 0;
    } else if (aSelector == @selector(staticPaddingForLineGraph:)) {
        return self.staticPaddingValue > 0;
    } else if (aSelector == @selector(popUpViewForLineGraph:)) {
        return self.provideCustomView;
    } else if (aSelector == @selector(lineGraph:modifyPopupView:forIndex:)) {
        return self.provideCustomView;
    } else if (aSelector == @selector(numberOfGapsBetweenLabelsOnLineGraph:)) {
        return self.numberOfGapsBetweenLabels != NSNotFound;
    } else if (aSelector == @selector(baseIndexForXAxisOnLineGraph:)) {
        return self.baseIndexForXAxis != NSNotFound;
    } else if (aSelector == @selector(incrementIndexForXAxisOnLineGraph:)) {
        return self.incrementIndexForXAxis != NSNotFound;
    } else if (aSelector == @selector(incrementPositionsForXAxisOnLineGraph:)) {
        return self.provideIncrementPositionsForXAxis;
    } else if (aSelector == @selector(numberOfYAxisLabelsOnLineGraph:)) {
        return self.numberOfYAxisLabels != NSNotFound;
    } else if (aSelector == @selector(yAxisPrefixOnLineGraph:)) {
        return self.yAxisPrefix.length > 0;
    } else if (aSelector == @selector(yAxisSuffixOnLineGraph:)) {
        return self.yAxisSuffix.length > 0;
    } else if (aSelector == @selector(baseValueForYAxisOnLineGraph:)) {
        return self.baseValueForYAxis >= 0;
    } else if (aSelector == @selector(incrementValueForYAxisOnLineGraph:)) {
        return self.baseValueForYAxis >= 0.0;
    } else {
        return [super respondsToSelector:aSelector];
    }
}


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSUInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return self.popUpSuffix;
}

- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return self.popUpPrefix;
}

- (NSString *)popUpTextForlineGraph:(BEMSimpleLineGraphView *)graph atIndex:(NSUInteger)index {
    if (!self.popUpText) return @"Empty format string";
    @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"
        return [NSString stringWithFormat: self.popUpText, index];
#pragma clang diagnostic pop
    } @catch (NSException *exception) {
        return [NSString stringWithFormat:@"Invalid format string: %@", exception ];
    }

}

- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(NSUInteger)index {
    return (index % 3 != 0);
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.maxValue;
}

- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.minValue;
}

- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.noDataLabel;
}
- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.noDataText;
}

- (CGFloat)staticPaddingForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.staticPaddingValue;
}

- (UIView *)popUpViewForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.customView;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index {
    NSAssert (popupView == self.customView, @"View problem");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"
    if (!self.myGraph.formatStringForValues.length) return;
    self.customViewLabel.text = [NSString stringWithFormat:self.myGraph.formatStringForValues, [self lineGraph:graph valueForPointAtIndex:index] ];
#pragma pop
}

//----- X AXIS -----//

- (NSUInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.numberOfGapsBetweenLabels;
}

- (NSUInteger)baseIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.baseIndexForXAxis;
}

- (NSUInteger)incrementIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.incrementIndexForXAxis;
}

- (NSArray <NSNumber *> *)incrementPositionsForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    NSMutableArray * positions = [NSMutableArray array];
    NSUInteger index = 1;
    while (index < self.arrayOfValues.count) {
        if (arc4random() % 4 == 0) [positions addObject:@(index)];
        index +=1;
    }
    return positions;
}

//----- Y AXIS -----//

- (NSUInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.numberOfYAxisLabels;
}

- (NSString *)yAxisPrefixOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.yAxisPrefix;
}

- (NSString *)yAxisSuffixOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.yAxisSuffix;
}

- (CGFloat)baseValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.baseValueForYAxis;
}

- (CGFloat)incrementValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.incrementValueForYAxis;
}

// MARK: - Touch handling

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSUInteger)index {
    self.labelValues.text = [self formatNumber:[self.arrayOfValues objectAtIndex:index]];
    self.labelDates.text = [NSString stringWithFormat:@"on %@", [self labelForDateAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self updateLabelsBelowGraph:graph];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)updateLabelsBelowGraph: (BEMSimpleLineGraphView *)graph {
    if (self.arrayOfValues.count > 0) {
        NSNumber * sum = [[BEMGraphCalculator sharedCalculator] calculatePointValueSumOnGraph:graph];
        self.labelValues.text =[self formatNumber:sum];
        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
    } else {
        self.labelValues.text = @"No data";
        self.labelDates.text = @"";
    }
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    [self updateLabelsBelowGraph:graph];
}

@end
