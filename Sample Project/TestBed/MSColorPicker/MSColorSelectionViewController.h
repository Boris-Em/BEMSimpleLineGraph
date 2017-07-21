//
// MSColorSelectionViewController.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MSColorSelectionViewController;

/**
 *  The delegate of a MSColorSelectionViewController object must adopt the MSColorSelectionViewController protocol.
 *  Methods of the protocol allow the delegate to handle color value changes.
 */
@protocol MSColorSelectionViewControllerDelegate <NSObject>

@required

/**
 *  Tells the data source to return the color components.
 *
 *  @param colorViewCntroller The color view.
 *  @param color The new color value.
 */
- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color;

@end

@interface MSColorSelectionViewController : UIViewController

/**
 *  The controller's delegate. Controller notifies a delegate on color change.
 */
@property (nonatomic, weak, nullable) id<MSColorSelectionViewControllerDelegate> delegate;
/**
 *  The current color value.
 */
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
