//
// MSColorSelectionView.m
//
// Created by Maksym Shcheglov on 2015-04-12.
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

#import "MSColorSelectionView.h"
#import "MSRGBView.h"
#import "MSHSBView.h"

@interface MSColorSelectionView () <MSColorViewDelegate>

@property (nonatomic, strong) UIView <MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView <MSColorView> *hsbColorView;
@property (nonatomic, assign) MSSelectedColorView selectedIndex;

@end

@implementation MSColorSelectionView

@synthesize color = _color;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil) {
        [self ms_init];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self != nil) {
        [self ms_init];
    }

    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [[self selectedView] setColor:color];
}

- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated
{
    self.selectedIndex = index;
    if (self.color) self.selectedView.color = self.color;
    [UIView animateWithDuration:animated ? .5 : 0.0 animations:^{
         self.rgbColorView.alpha = index == 0 ? 1.0 : 0.0;
         self.hsbColorView.alpha = index == 1 ? 1.0 : 0.0;
     } completion:nil];
}

- (UIView<MSColorView> *)selectedView
{
    return self.selectedIndex == 0 ? self.rgbColorView : self.hsbColorView;
}

- (void)addColorView:(UIView<MSColorView> *)view
{
    view.delegate = self;
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
}

- (void)updateConstraints
{
    [self.rgbColorView setNeedsUpdateConstraints];
    [self.hsbColorView setNeedsUpdateConstraints];
    [super updateConstraints];
}

// MARK: - FBColorViewDelegate methods

- (void)colorView:(id<MSColorView>)colorView didChangeColor:(UIColor *)color
{
    self.color = color;
    [self.delegate colorView:self didChangeColor:self.color];
}

// MARK: - Private

- (void)ms_init
{
    self.accessibilityLabel = @"color_selection_view";

    self.backgroundColor = [UIColor whiteColor];
    self.rgbColorView = [[MSRGBView alloc] init];
    self.hsbColorView = [[MSHSBView alloc] init];
    [self addColorView:self.rgbColorView];
    [self addColorView:self.hsbColorView];
    [self setSelectedIndex:0 animated:NO];
}

@end
