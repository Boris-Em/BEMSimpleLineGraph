//
//  ViewController.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#import "ViewController.h"

int totalNumber;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    
    totalNumber = 0;
    
    for (int i=0; i < 11; i++)
    {
        [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 50000)]]; // Random values for the graph
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1900 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
                    //Initialization of the graph
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, 250)];
    self.myGraph.delegate = self;
    [self.view addSubview:self.myGraph];
    
                    //Customization of the graph
    self.myGraph.enableTouchReport = YES;
    self.myGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorLine = [UIColor whiteColor];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.widthLine = 3.0;
    self.myGraph.enableTouchReport = YES;
    
                    //The labels to report the values of the graph when the user touches it
    self.labelValues = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.myGraph.frame.origin.y + self.myGraph.frame.size.height + [[UIScreen mainScreen] bounds].size.height)/2 - 50, 320, 40)];
    self.labelValues.textAlignment = 1;
    self.labelValues.textColor = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.labelValues.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
    self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
    [self.view addSubview:self.labelValues];
    
    self.labelDates = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.myGraph.frame.origin.y + self.myGraph.frame.size.height + [[UIScreen mainScreen] bounds].size.height)/2 + 20, 320, 20)];
    self.labelDates.textAlignment = 1;
    self.labelDates.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    self.labelDates.text = @"between 1900 and 1910";
    [self.view addSubview:self.labelDates];
}

- (int)numberOfPointsInGraph
{
    return (int)[self.ArrayOfValues count];
}

- (float)valueForIndex:(NSInteger)index
{
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

- (int)numberOfGapsBetweenLabels
{
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index
{
    return [self.ArrayOfDates objectAtIndex:index];
}

- (void)didTouchGraphWhithClosestIndex:(int)index
{
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    
    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)didReleaseGraphWhithClosestIndex:(float)index;
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.labelValues.alpha = 0.0;
                         self.labelDates.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
                         self.labelDates.text = @"between 1900 and 1910";
                         
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.labelValues.alpha = 1.0;
                                              self.labelDates.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end