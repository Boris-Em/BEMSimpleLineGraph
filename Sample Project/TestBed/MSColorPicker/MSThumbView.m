//
// MSThumbView.m
//
// Created by Maksym Shcheglov on 2016-05-25.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "MSThumbView.h"

static const CGFloat MSSliderViewThumbDimension = 28.0f;

@interface MSThumbView ()
@property (nonatomic, strong) CALayer *thumbLayer;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@end

@implementation MSThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, MSSliderViewThumbDimension, MSSliderViewThumbDimension)];

    if (self) {
        self.thumbLayer = [CALayer layer];

        self.thumbLayer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4].CGColor;
        self.thumbLayer.borderWidth = .5;
        self.thumbLayer.cornerRadius = MSSliderViewThumbDimension / 2;
        self.thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.thumbLayer.shadowColor = [UIColor blackColor].CGColor;
        self.thumbLayer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.thumbLayer.shadowRadius = 2;
        self.thumbLayer.shadowOpacity = 0.3f;
        [self.layer addSublayer:self.thumbLayer];
        self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:nil];
        [self addGestureRecognizer:self.gestureRecognizer];
    }

    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer != self.layer) {
        return;
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.thumbLayer.bounds = CGRectMake(0, 0, MSSliderViewThumbDimension, MSSliderViewThumbDimension);
    self.thumbLayer.position = CGPointMake(MSSliderViewThumbDimension / 2, MSSliderViewThumbDimension / 2);
    [CATransaction commit];
}

@end
