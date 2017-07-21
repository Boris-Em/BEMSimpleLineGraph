//
// MSSliderView.h
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

#import <UIKit/UIKit.h>

/**
 *  The slider with a gradient track.
 */
@interface MSSliderView : UIControl

/**
 *  The slider's current value. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat value;
/**
 *  The minimum value of the slider. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat minimumValue;
/**
 *  The maximum value of the slider. The default value is 1.0.
 */
@property (nonatomic, assign) CGFloat maximumValue;
/**
 *  Sets the array of CGColorRef objects defining the color of each gradient stop on the track.
 *  The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
 *
 *  @param colors An array of CGColorRef objects.
 */
- (void)setColors:(NSArray *)colors __attribute__((nonnull(1)));

@end
