//
//  UIControl+ContinuousClickLimit.h
//  UIControlTest
//
//  Created by zhaolei on 2019/1/16.
//  Copyright © 2019 zhaolei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ContinuousClickLimit)

@property (nonatomic, assign) NSTimeInterval wy_eventInterval;

@end

NS_ASSUME_NONNULL_END
