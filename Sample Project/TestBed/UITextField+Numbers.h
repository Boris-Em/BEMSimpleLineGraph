//
//  UITextField+Numbers.h
//  SimpleLineChart
//
//  Created by Hugh Mackworth on 5/14/17.
//  Copyright © 2017 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>

//some convenience extensions for setting and reading
@interface UITextField (Numbers)
@property (nonatomic) CGFloat floatValue;
@property (nonatomic) NSUInteger intValue;

@end
