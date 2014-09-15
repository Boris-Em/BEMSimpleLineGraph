//
//  ViewController.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "ViewController.h"


@interface ViewController () {
    int previousStepperValue;
    int totalNumber;
}

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    
    previousStepperValue = self.graphObjectIncrement.value;
    totalNumber = 0;
    
    for (int i = 0; i < 9; i++) {
        [self.ArrayOfValues addObject:@( [self getInteger])]; // Random values for the graph
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code.
     BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
     myGraph.delegate = self;
     myGraph.dataSource = self;
     [self.view addSubview:myGraph]; */
    
    // Customization of the graph
    self.myGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorLine = [UIColor whiteColor];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.colorYaxisLabel = [UIColor whiteColor];
    self.myGraph.widthLine = 3.0;
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableBezierCurve = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    //setup initial selectet segment
    self.curveChoice.selectedSegmentIndex = self.myGraph.enableBezierCurve;

    // The labels to report the values of the graph when the user touches it
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = @"between 2000 and 2010";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Graph Actions

- (IBAction)refresh:(id)sender {
    [self.ArrayOfValues removeAllObjects];
    [self.ArrayOfDates removeAllObjects];
    
    for (int i = 0; i < self.graphObjectIncrement.value; i++) {
        NSInteger i1 = [self getInteger];
        [self.ArrayOfValues addObject:@(i1)]; // Random values for the graph
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"Jan %@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [(self.ArrayOfValues)[i] intValue]; // All of the values added together
    }
    UIColor *color;
    if (self.graphColorChoice.selectedSegmentIndex == 0) color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    else if (self.graphColorChoice.selectedSegmentIndex == 1) color = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1.0];
    else if (self.graphColorChoice.selectedSegmentIndex == 2) color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    self.myGraph.enableBezierCurve = (BOOL) self.curveChoice.selectedSegmentIndex;
    self.myGraph.colorTop = color;
    self.myGraph.colorBottom = color;
    self.myGraph.backgroundColor = color;
    self.view.tintColor = color;
    self.labelValues.textColor = color;
    self.navigationController.navigationBar.tintColor = color;
    
    self.myGraph.animationGraphStyle = BEMLineAnimationFade;
    [self.myGraph reloadGraph];
}

- (NSInteger)getInteger
{
    NSInteger i1 = (int)(arc4random() % 10000);
    return i1;
}

- (IBAction)addOrRemoveLineFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > previousStepperValue) {
        // Add line
        [self.ArrayOfValues addObject:@([self getInteger])];
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%i", (int)[[self.ArrayOfDates lastObject] integerValue]+1]];
        [self.myGraph reloadGraph];
    } else if (self.graphObjectIncrement.value < previousStepperValue) {
        // Remove line
        [self.ArrayOfValues removeObjectAtIndex:0];
        [self.ArrayOfDates removeObjectAtIndex:0];
        [self.myGraph reloadGraph];
    }
    
    previousStepperValue = self.graphObjectIncrement.value;
}

- (IBAction)displayStatistics:(id)sender {
    [self performSegueWithIdentifier:@"showStats" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showStats"]) {
        StatsViewController *controller = segue.destinationViewController;
        controller.standardDeviation = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateLineGraphStandardDeviation] floatValue]];
        controller.average = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueAverage] floatValue]];
        controller.median = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueMedian] floatValue]];
        controller.mode = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueMode] floatValue]];
        controller.minimum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMinimumPointValue] floatValue]];
        controller.maximum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMaximumPointValue] floatValue]];
        controller.snapshotImage = [self.myGraph graphSnapshotImage];
    }
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self.ArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
}

@end