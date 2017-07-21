//
// MSColorUtils.h
//
// Created by Maksym Shcheglov on 2014-02-13.
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
 *  The structure to represent a color in the Red-Green-Blue-Alpha color space.
 */
typedef struct { CGFloat red, green, blue, alpha; }              RGB;
/**
 *  The structure to represent a color in the hue-saturation-brightness color space.
 */
typedef struct { CGFloat hue, saturation, brightness, alpha; }   HSB;

/**
 *  The maximum value of the RGB color components.
 */
extern CGFloat const MSRGBColorComponentMaxValue;
/**
 *  The maximum value of the alpha component.
 */
extern CGFloat const MSAlphaComponentMaxValue;
/**
 *  The maximum value of the HSB color components.
 */
extern CGFloat const MSHSBColorComponentMaxValue;

/**
 * Converts an RGB color value to HSV.
 * Assumes r, g, and b are contained in the set [0, 1] and
 * returns h, s, and b in the set [0, 1].
 *
 *  @param rgb   The rgb color values
 *  @return The hsb color values
 */
extern HSB MSRGB2HSB(RGB rgb);

/**
 * Converts an HSB color value to RGB.
 * Assumes h, s, and b are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 *  @param hsb   The hsb color values
 *  @return The rgb color values
 */
extern RGB MSHSB2RGB(HSB hsb);

/**
 *  Returns the rgb values of the color components.
 *
 *  @param color The color value.
 *
 *  @return The values of the color components (including alpha).
 */
extern RGB MSRGBColorComponents(UIColor *color);

/**
 *  Converts hex string to the UIColor representation.
 *
 *  @param color The color value.
 *
 *  @return The hex string color value.
 */
extern NSString * MSHexStringFromColor(UIColor *color);

/**
 *  Converts UIColor value to the hex string.
 *
 *  @param hexString The hex string color value.
 *
 *  @return The color value.
 */
extern UIColor * MSColorFromHexString(NSString *hexString);
