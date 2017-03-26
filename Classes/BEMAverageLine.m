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
        _alpha = 1.0;
        _width = 3.0;
        _yValue = NAN;
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder {

#define RestoreProperty(property, type) {\
if ([coder containsValueForKey:@#property]) { \
self.property = [coder decode ## type ##ForKey:@#property ]; \
}\
}
    self = [self init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullable-to-nonnull-conversion"

    RestoreProperty (enableAverageLine, Bool);
    RestoreProperty (color, Object);
    RestoreProperty (yValue, Double);
    RestoreProperty (alpha, Double);
    RestoreProperty (width, Double);
    RestoreProperty (dashPattern, Object);
    RestoreProperty (title, Object);
#pragma clang diagnostic pop

    //AverageLine
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {

#define EncodeProperty(property, type) [coder encode ## type: self.property forKey:@#property]
    EncodeProperty (enableAverageLine, Bool);
    EncodeProperty (color, Object);
    EncodeProperty (yValue, Float);
    EncodeProperty (alpha, Float);
    EncodeProperty (width, Float);
    EncodeProperty (dashPattern, Object);
    EncodeProperty (title, Object);
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
