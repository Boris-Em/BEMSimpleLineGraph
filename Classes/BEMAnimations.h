//
//  BEMAnimations.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#if __has_feature(objc_modules)
    // We recommend enabling Objective-C Modules in your project Build Settings for numerous benefits over regular #imports
    @import Foundation;
    @import UIKit;
    @import CoreGraphics;
#else
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #import <CoreGraphics/CoreGraphics.h>
#endif

#import "BEMCircle.h"
#import "BEMLine.h"



@protocol BEMAnimationDelegate <NSObject>

@end


/// Class for the animation when the graph first gets created.
@interface BEMAnimations : NSObject



/// Animation of the dots
- (void)animationForDot:(NSInteger)dotIndex circleDot:(BEMCircle *)circleDot animationSpeed:(NSInteger)speed;


/// Animation of the graph
- (void)animationForLine:(NSInteger)lineIndex line:(BEMLine *)line animationSpeed:(NSInteger)speed;



/// Animation Delegate
@property (assign) id <BEMAnimationDelegate> delegate;



@end
