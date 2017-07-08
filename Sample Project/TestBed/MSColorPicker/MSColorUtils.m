//
// MSColorUtils.m
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

#import "MSColorUtils.h"

CGFloat const MSRGBColorComponentMaxValue = 255.0f;
CGFloat const MSAlphaComponentMaxValue = 100.0f;
CGFloat const MSHSBColorComponentMaxValue = 1.0f;

extern HSB MSRGB2HSB(RGB rgb)
{
    HSB hsb = { 0.0f, 0.0f, 0.0f, 0.0f };
    double rd = (double)rgb.red;
    double gd = (double)rgb.green;
    double bd = (double)rgb.blue;
    double max = fmax(rd, fmax(gd, bd));
    double min = fmin(rd, fmin(gd, bd));
    double h = 0, s, b = max;

    double d = max - min;

    s = max <= 0 ? 0 : d / max;

    if (max <= min) {
        h = 0; // achromatic
    } else {
        if (max <= rd) {
            h = (gd - bd) / d + (gd < bd ? 6 : 0);
        } else if (max <= gd) {
            h = (bd - rd) / d + 2;
        } else if (max <= bd) {
            h = (rd - gd) / d + 4;
        }

        h /= 6;
    }

    hsb.hue = h;
    hsb.saturation = s;
    hsb.brightness = b;
    hsb.alpha = rgb.alpha;
    return hsb;
}

extern RGB MSHSB2RGB(HSB hsb)
{
    RGB rgb = { 0.0f, 0.0f, 0.0f, 0.0f };
    double r, g, b;

    int i = hsb.hue * 6;
    double f = hsb.hue * 6 - i;
    double p = hsb.brightness * (1 - hsb.saturation);
    double q = hsb.brightness * (1 - f * hsb.saturation);
    double t = hsb.brightness * (1 - (1 - f) * hsb.saturation);

    switch (i % 6) {
        case 0: r = hsb.brightness; g = t; b = p; break;

        case 1: r = q; g = hsb.brightness; b = p; break;

        case 2: r = p; g = hsb.brightness; b = t; break;

        case 3: r = p; g = q; b = hsb.brightness; break;

        case 4: r = t; g = p; b = hsb.brightness; break;

        case 5:
        default:
            r = hsb.brightness; g = p; b = q; break;
    }

    rgb.red = r;
    rgb.green = g;
    rgb.blue = b;
    rgb.alpha = hsb.alpha;
    return rgb;
}

extern RGB MSRGBColorComponents(UIColor *color)
{
    RGB result = {0.0, 0.0, 0.0, 0.0};
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));

    if (colorSpaceModel != kCGColorSpaceModelRGB && colorSpaceModel != kCGColorSpaceModelMonochrome) {
        return result;
    }

    const CGFloat *components = CGColorGetComponents(color.CGColor);

    if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
        result.red = result.green = result.blue = components[0];
        result.alpha = components[1];
    } else {
        result.red = components[0];
        result.green = components[1];
        result.blue = components[2];
        result.alpha = components[3];
    }

    return result;
}

extern NSString * MSHexStringFromColor(UIColor *color)
{
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));

    if (colorSpaceModel != kCGColorSpaceModelRGB && colorSpaceModel != kCGColorSpaceModelMonochrome) {
        return nil;
    }

    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat red, green, blue, alpha;

    if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
        red = green = blue = components[0];
        alpha = components[1];
    } else {
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }

    NSString *hexColorString = [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
                                (unsigned long)(red * MSRGBColorComponentMaxValue),
                                (unsigned long)(green * MSRGBColorComponentMaxValue),
                                (unsigned long)(blue * MSRGBColorComponentMaxValue),
                                (unsigned long)(alpha * MSRGBColorComponentMaxValue)];
    return hexColorString;
}

extern UIColor * MSColorFromHexString(NSString *hexColor)
{
    if (![hexColor hasPrefix:@"#"]) {
        return nil;
    }

    NSScanner *scanner = [NSScanner scannerWithString:hexColor];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

    unsigned hexNum;

    if (![scanner scanHexInt:&hexNum]) return nil;

    int r = (hexNum >> 24) & 0xFF;
    int g = (hexNum >> 16) & 0xFF;
    int b = (hexNum >> 8) & 0xFF;
    int a = (hexNum) & 0xFF;

    return [UIColor colorWithRed:r / MSRGBColorComponentMaxValue
                           green:g / MSRGBColorComponentMaxValue
                            blue:b / MSRGBColorComponentMaxValue
                           alpha:a / MSRGBColorComponentMaxValue];
}
