//
// MSColorSelectionView.h
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

#import "MSColorView.h"

/**
 *  The enum to define the MSColorView's types.
 */
typedef NS_ENUM(NSUInteger, MSSelectedColorView) {
    /**
     *  The RGB color view type.
     */
    MSSelectedColorViewRGB,
    /**
     *  The HSB color view type.
     */
    MSSelectedColorViewHSB
};

/**
 *  The MSColorSelectionView aggregates views that should be used to edit color components.
 */
@interface MSColorSelectionView : UIView <MSColorView>

/**
 *  The selected color view
 */
@property (nonatomic, assign, readonly) MSSelectedColorView selectedIndex;

/**
 *  Makes a color component view (rgb or hsb) visible according to the index.
 *
 *  @param index    This index define a view to show.
 *  @param animated If YES, the view is being appeared using an animation.
 */
- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated;

@end
