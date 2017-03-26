//
// MSThumbView.h
//
// Created by Maksym Shcheglov on 2016-05-25.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSThumbView : UIControl
@property (nonatomic, strong, readonly) UIGestureRecognizer *gestureRecognizer;
@end
