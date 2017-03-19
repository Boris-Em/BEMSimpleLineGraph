//
//  DetailViewController.h
//  SimpleLineChart
//
//  Created by Hugh Mackworth on 5/19/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

@import UIKit;
#import "BEMSimpleLineGraphView.h"

@interface DetailViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

- (void) addPointToGraph;
- (void) removePointFromGraph;

- (IBAction)refresh:(id)sender;

//data needed to implement delegate methods
//@"" or negative float or NSNotFound or FALSE to indicate don't provide a delegate method
@property (strong, nonatomic)  NSString *popUpText;
@property (strong, nonatomic)  NSString *popUpPrefix;
@property (strong, nonatomic)  NSString *popUpSuffix;
@property (assign, nonatomic)  BOOL      testAlwaysDisplayPopup;
@property (assign, nonatomic)  CGFloat   maxValue;
@property (assign, nonatomic)  CGFloat   minValue;
@property (assign, nonatomic)  BOOL      noDataLabel;
@property (strong, nonatomic)  NSString *noDataText;
@property (assign, nonatomic)  CGFloat   staticPaddingValue;
@property (assign, nonatomic)  BOOL      provideCustomView;
@property (assign, nonatomic)  NSUInteger numberOfGapsBetweenLabels;
@property (assign, nonatomic)  NSUInteger baseIndexForXAxis;
@property (assign, nonatomic)  NSUInteger incrementIndexForXAxis;
@property (assign, nonatomic)  BOOL      provideIncrementPositionsForXAxis;
@property (assign, nonatomic)  NSUInteger numberOfYAxisLabels;
@property (strong, nonatomic)  NSString  *yAxisPrefix;
@property (strong, nonatomic)  NSString  *yAxisSuffix;
@property (assign, nonatomic)  CGFloat    baseValueForYAxis;
@property (assign, nonatomic)  CGFloat    incrementValueForYAxis;

@end
