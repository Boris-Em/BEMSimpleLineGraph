//
//  BEMAnimations.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

//Class for the animation when the graph first gets created.

#import <Foundation/Foundation.h>
#import "BEMCircle.h"
#import "BEMLine.h"

@protocol BEMAnimationDelegate <NSObject>

@end

@interface BEMAnimations : NSObject

- (void)animationForDot:(NSInteger)dotIndex circleDot:(BEMCircle *)circleDot animationSpeed:(NSInteger)speed;
- (void)animationForLine:(NSInteger)lineIndex line:(BEMLine *)line animationSpeed:(NSInteger)speed;

@property (assign) id <BEMAnimationDelegate> delegate;

@end