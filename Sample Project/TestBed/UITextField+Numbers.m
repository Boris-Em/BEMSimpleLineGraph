//
//  UITextField+Numbers.m
//  SimpleLineChart
//
//  Created by Hugh Mackworth on 5/14/17.
//  Copyright © 2017 Boris Emorine. All rights reserved.
//

#import "UITextField+Numbers.h"

@implementation UITextField (Numbers)

- (void)setFloatValue:(CGFloat) num {
    if (num < 0.0) {
        self.text = @"";
    } else if (num >= NSNotFound ) {
        self.text = @"oopsf";
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",num];
    }
}

- (void)setIntValue:(NSUInteger) num {
    if (num == NSNotFound ) {
        self.text = @"";
    } else if (num == (NSUInteger)-1 ) {
        self.text = @"oops";
    }else {
        self.text = [NSString stringWithFormat:@"%d",(int)num];
    }
}

- (CGFloat)floatValue {
    if (self.text.length ==0) {
        return -1.0;
    } else {
        return (CGFloat) self.text.floatValue;
    }
}

- (NSUInteger)intValue {
    if (self.text.length ==0) {
        return NSNotFound;
    } else {
        return (NSUInteger) self.text.integerValue;
    }

}

@end
