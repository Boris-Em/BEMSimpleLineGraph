//
// MSRGBView.m
//
// Created by Maksym Shcheglov on 2014-02-16.
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

#import "MSRGBView.h"
#import "MSColorComponentView.h"
#import "MSSliderView.h"
#import "MSColorUtils.h"

extern CGFloat const MSRGBColorComponentMaxValue;

static CGFloat const MSColorSampleViewHeight = 30.0f;
static CGFloat const MSViewMargin = 20.0f;
static CGFloat const MSSliderViewMargin = 30.0f;
static NSUInteger const MSRGBColorComponentsSize = 3;

@interface MSRGBView ()
{
    @private

    UIView *_colorSample;
    NSArray *_colorComponentViews;
    RGB _colorComponents;
}

@end

@implementation MSRGBView

@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self ms_baseInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self ms_baseInit];
    }

    return self;
}

- (void)reloadData
{
    [_colorSample setBackgroundColor:self.color];
    [_colorSample setAccessibilityValue:MSHexStringFromColor(self.color)];
    [self ms_reloadColorComponentViews:_colorComponents];
}

- (void)setColor:(UIColor *)color
{
    _colorComponents = MSRGBColorComponents(color);
    [self reloadData];
}

- (UIColor *)color
{
    return [UIColor colorWithRed:_colorComponents.red green:_colorComponents.green blue:_colorComponents.blue alpha:_colorComponents.alpha];
}

#pragma mark - Private methods

- (void)ms_baseInit
{
    self.accessibilityLabel = @"rgb_view";

    _colorSample = [[UIView alloc] init];
    _colorSample.accessibilityLabel = @"color_sample";
    _colorSample.layer.borderColor = [UIColor blackColor].CGColor;
    _colorSample.layer.borderWidth = .5f;
    _colorSample.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_colorSample];

    NSMutableArray *tmp = [NSMutableArray array];
    NSArray *titles = @[NSLocalizedString(@"Red", ), NSLocalizedString(@"Green", ), NSLocalizedString(@"Blue", )];
    NSArray *maxValues = @[@(MSRGBColorComponentMaxValue), @(MSRGBColorComponentMaxValue), @(MSRGBColorComponentMaxValue)];

    for (NSUInteger i = 0; i < MSRGBColorComponentsSize; ++i) {
        UIControl *colorComponentView = [self ms_colorComponentViewWithTitle:titles[i] tag:i maxValue:[maxValues[i] floatValue]];
        [self addSubview:colorComponentView];
        [colorComponentView addTarget:self action:@selector(ms_colorComponentDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        [tmp addObject:colorComponentView];
    }

    _colorComponentViews = [tmp copy];
    [self ms_installConstraints];
}

- (IBAction)ms_colorComponentDidChangeValue:(MSColorComponentView *)sender
{
    [self ms_setColorComponentValue:sender.value / sender.maximumValue atIndex:sender.tag];
    [self.delegate colorView:self didChangeColor:self.color];
    [self reloadData];
}

- (void)ms_setColorComponentValue:(CGFloat)value atIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            _colorComponents.red = value;
            break;

        case 1:
            _colorComponents.green = value;
            break;

        case 2:
            _colorComponents.blue = value;
            break;

        default:
            _colorComponents.alpha = value;
            break;
    }
}

- (UIControl *)ms_colorComponentViewWithTitle:(NSString *)title tag:(NSUInteger)tag maxValue:(CGFloat)maxValue
{
    MSColorComponentView *colorComponentView = [[MSColorComponentView alloc] init];

    colorComponentView.title = title;
    colorComponentView.translatesAutoresizingMaskIntoConstraints = NO;
    colorComponentView.tag  = tag;
    colorComponentView.maximumValue = maxValue;
    return colorComponentView;
}

- (void)ms_installConstraints
{
    NSDictionary *metrics = @{ @"margin": @(MSViewMargin),
                               @"height": @(MSColorSampleViewHeight),
                               @"slider_margin": @(MSSliderViewMargin) };

    __block NSDictionary *views = NSDictionaryOfVariableBindings(_colorSample);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_colorSample]-margin-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_colorSample(height)]" options:0 metrics:metrics views:views]];

    __block UIView *previousView = _colorSample;
    [_colorComponentViews enumerateObjectsUsingBlock:^(UIView *colorComponentView, NSUInteger idx, BOOL *stop) {
         views = NSDictionaryOfVariableBindings(previousView, colorComponentView);
         [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[colorComponentView]-margin-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
         [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-slider_margin-[colorComponentView]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
         previousView = colorComponentView;
     }];
    views = NSDictionaryOfVariableBindings(previousView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-(>=margin)-|" options:0 metrics:metrics views:views]];
}

- (NSArray *)ms_colorComponentsWithRGB:(RGB)rgb
{
    return @[@(rgb.red), @(rgb.green), @(rgb.blue), @(rgb.alpha)];
}

- (void)ms_reloadColorComponentViews:(RGB)colorComponents
{
    NSArray *components = [self ms_colorComponentsWithRGB:colorComponents];

    [_colorComponentViews enumerateObjectsUsingBlock:^(MSColorComponentView *colorComponentView, NSUInteger idx, BOOL *stop) {
         [colorComponentView setColors:[self ms_colorsWithColorComponents:components
                                                        currentColorIndex:colorComponentView.tag]];
         colorComponentView.value = [components[idx] floatValue] * colorComponentView.maximumValue;
     }];
}

- (NSArray *)ms_colorsWithColorComponents:(NSArray *)colorComponents currentColorIndex:(NSUInteger)colorIndex
{
    CGFloat currentColorValue = [colorComponents[colorIndex] floatValue];
    CGFloat colors[12];

    for (NSUInteger i = 0; i < MSRGBColorComponentsSize; i++) {
        colors[i] = [colorComponents[i] floatValue];
        colors[i + 4] = [colorComponents[i] floatValue];
        colors[i + 8] = [colorComponents[i] floatValue];
    }

    colors[colorIndex] = 0;
    colors[colorIndex + 4] = currentColorValue;
    colors[colorIndex + 8] = 1.0;
    UIColor *start = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:1.0f];
    UIColor *middle = [UIColor colorWithRed:colors[4] green:colors[5] blue:colors[6] alpha:1.0f];
    UIColor *end = [UIColor colorWithRed:colors[8] green:colors[9] blue:colors[10] alpha:1.0f];
    return @[(id)start.CGColor, (id)middle.CGColor, (id)end.CGColor];
}

@end
