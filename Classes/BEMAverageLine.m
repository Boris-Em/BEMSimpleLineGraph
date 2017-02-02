//
//  BEMAverageLine.m
//  SimpleLineChart
//
//  Created by Sam Spencer on 4/7/15.
//  Copyright (c) 2015 Boris Emorine. All rights reserved.
//

#import "BEMAverageLine.h"

@implementation BEMAverageLine

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableAverageLine = NO;
        _color = [UIColor whiteColor];
        _alpha = 1.0;
        _width = 3.0;
        _yValue = NAN;
    }
    
    return self;
}
-(void) setLabel:(UILabel *)label {
    if (_label != label) {
        [_label removeFromSuperview];
        _label = label;
    }
}

-(void) dealloc {
    self.label= nil;
}
@end
