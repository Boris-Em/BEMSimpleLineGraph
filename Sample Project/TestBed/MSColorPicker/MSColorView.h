//
// MSColorView.h
//
// Created by Maksym Shcheglov on 2014-02-15.
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

@protocol MSColorViewDelegate;

/**
 *  The \c MSColorView protocol declares a view's interface for displaying and editing color value.
 */
@protocol MSColorView <NSObject>

@required

/**
 *  The object that acts as the delegate of the receiving color selection view.
 */
@property (nonatomic, weak) id<MSColorViewDelegate> delegate;
/**
 *  The current color.
 */
@property (nonatomic, strong) UIColor* color;

@end

/**
 *  The delegate of a MSColorView object must adopt the MSColorViewDelegate protocol.
 *  Methods of the protocol allow the delegate to handle color value changes.
 */
@protocol MSColorViewDelegate <NSObject>

@required

/**
 *  Tells the data source to return the color components.
 *
 *  @param colorView The color view.
 *  @param color The new color value.
 */
- (void)colorView:(id<MSColorView>)colorView didChangeColor:(UIColor *)color;

@end
