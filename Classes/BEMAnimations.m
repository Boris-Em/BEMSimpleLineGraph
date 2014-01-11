//
//  BEMAnimations.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMAnimations.h"

@implementation BEMAnimations

- (void)animationForDot:(NSInteger)dotIndex circleDot:(BEMCircle *)circleDot animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        circleDot.alpha = 0;
    } else {
        [UIView animateWithDuration:0.5 delay:dotIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            circleDot.alpha = 0.7;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                circleDot.alpha = 0;
            } completion:nil];
        }];
    }
}

- (void)animationForLine:(NSInteger)lineIndex line:(BEMLine *)line animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        line.alpha = 1.0;
    } else {
        [UIView animateWithDuration:1.0 delay:lineIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            line.alpha = 1.0;
        } completion:nil];
    }
}

@end