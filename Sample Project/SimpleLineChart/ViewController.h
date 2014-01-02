//
//  ViewController.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface ViewController : UIViewController <BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;

@property (strong, nonatomic) UILabel *labelValues;
@property (strong, nonatomic) UILabel *labelDates;

@end