//
//  UIButton+Switch.m
//  SimpleLineChart
//
//  Created by Hugh Mackworth on 5/14/17.
//  Copyright © 2017 Boris Emorine. All rights reserved.
//

#import "UIButton+Switch.h"

@implementation UIButton (Switch)
static NSString * checkOff = @"☐";
static NSString * checkOn = @"☒";

- (void)setOn: (BOOL) on {
    [self setTitle: (on ? checkOn : checkOff) forState:UIControlStateNormal];
}

- (BOOL)on {
    if (!self.currentTitle) return NO;
    return [checkOff isEqualToString: ( NSString * _Nonnull )self.currentTitle ];
}

@end
