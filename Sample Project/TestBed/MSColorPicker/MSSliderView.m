//
// MSSliderView.m
//
// Created by Maksym Shcheglov on 2014-01-31.
//
// The MIT License (MIT)
// Copyright (c) 2015 Maksym Shcheglov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSSliderView.h"
#import "MSThumbView.h"
#import "UIControl+HitTestEdgeInsets.h"

static const CGFloat MSSliderViewHeight = 28.0f;
static const CGFloat MSSliderViewMinWidth = 150.0f;
static const CGFloat MSSliderViewTrackHeight = 3.0f;
static const CGFloat MSThumbViewEdgeInset = -10.0f;

@interface MSSliderView () {
    @private

    MSThumbView *_thumbView;
    CAGradientLayer *_trackLayer;
}

@end

@implementation MSSliderView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.accessibilityLabel = @"color_slider";

        _minimumValue = 0.0f;
        _maximumValue = 1.0f;
        _value = 0.0f;

        self.layer.delegate = self;

        _trackLayer = [CAGradientLayer layer];
        _trackLayer.cornerRadius = MSSliderViewTrackHeight / 2.0f;
        _trackLayer.startPoint = CGPointMake(0.0f, 0.5f);
        _trackLayer.endPoint = CGPointMake(1.0f, 0.5f);
        [self.layer addSublayer:_trackLayer];

        _thumbView = [[MSThumbView alloc] init];
        _thumbView.hitTestEdgeInsets = UIEdgeInsetsMake(MSThumbViewEdgeInset, MSThumbViewEdgeInset, MSThumbViewEdgeInset, MSThumbViewEdgeInset);
        [_thumbView.gestureRecognizer addTarget:self action:@selector(ms_didPanThumbView:)];
        [self addSubview:_thumbView];

        __attribute__((objc_precise_lifetime)) id color = (__bridge id)[UIColor blueColor].CGColor;
        [self setColors:@[color, color]];
    }

    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(MSSliderViewMinWidth, MSSliderViewHeight);
}

- (void)setValue:(CGFloat)value
{
    if (value < _minimumValue) {
        _value = _minimumValue;
    } else if (value > _maximumValue) {
        _value = _maximumValue;
    } else {
        _value = value;
    }

    [self ms_updateThumbPositionWithValue:_value];
}

- (void)setColors:(NSArray *)colors
{
    NSParameterAssert(colors);
    _trackLayer.colors = colors;
    [self ms_updateLocations];
}

- (void)layoutSubviews
{
    [self ms_updateThumbPositionWithValue:_value];
    [self ms_updateTrackLayer];
}

// MARK: - UIControl touch tracking events

- (void)ms_didPanThumbView:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan && gestureRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }

    CGPoint translation = [gestureRecognizer translationInView:self];
    [gestureRecognizer setTranslation:CGPointZero inView:self];

    [self ms_setValueWithTranslation:translation.x];
}

- (void)ms_updateTrackLayer
{
    CGFloat height = MSSliderViewHeight;
    CGFloat width = CGRectGetWidth(self.bounds);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _trackLayer.bounds = CGRectMake(0, 0, width, MSSliderViewTrackHeight);
    _trackLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, height / 2);
    [CATransaction commit];
}

// MARK: - Private methods

- (void)ms_setValueWithTranslation:(CGFloat)translation
{
    CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetWidth(_thumbView.bounds);
    CGFloat valueRange = (_maximumValue - _minimumValue);
    CGFloat value = _value + valueRange * translation / width;

    [self setValue:value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)ms_updateLocations
{
    NSUInteger size = [_trackLayer.colors count];

    if (size == [_trackLayer.locations count]) {
        return;
    }

    CGFloat step = 1.0f / (size - 1);
    NSMutableArray *locations = [NSMutableArray array];
    [locations addObject:@(0.0f)];

    for (NSUInteger i = 1; i < size - 1; ++i) {
        [locations addObject:@(i * step)];
    }

    [locations addObject:@(1.0f)];
    _trackLayer.locations = [locations copy];
}

- (void)ms_updateThumbPositionWithValue:(CGFloat)value
{
    CGFloat thumbWidth = CGRectGetWidth(_thumbView.bounds);
    CGFloat thumbHeight = CGRectGetHeight(_thumbView.bounds);
    CGFloat width = CGRectGetWidth(self.bounds) - thumbWidth;

    if (width <= 0) {
        return;
    }

    CGFloat percentage = (value - _minimumValue) / (_maximumValue - _minimumValue);
    CGFloat position = width * percentage;
    _thumbView.frame = CGRectMake(position, 0, thumbWidth, thumbHeight);
}

@end
