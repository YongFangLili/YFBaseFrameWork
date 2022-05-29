//
//  UIControl+ContinuousClickLimit.m
//  UIControlTest
//
//  Created by zhaolei on 2019/1/16.
//  Copyright © 2019 zhaolei. All rights reserved.
//

#import "UIControl+ContinuousClickLimit.h"
#import <objc/runtime.h>

static char * const wy_eventIntervalKey = "wy_eventIntervalKey";
static char * const wy_actionDicKey = "WY_ACTIONDICKEY";


@interface UIControl ()

@property (nonatomic, strong) NSMutableDictionary * wy_actionDic;

@end

@implementation UIControl (ContinuousClickLimit)


+ (void)load {
    
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method wy_method = class_getInstanceMethod(self, @selector(wy_sendAction:to:forEvent:));
    method_exchangeImplementations(method, wy_method);
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        if(!self.wy_actionDic) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [self setWy_actionDic:dict];
        }
        self.wy_eventInterval = 0.5;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        if(!self.wy_actionDic) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [self setWy_actionDic:dict];
        }
        self.wy_eventInterval = 0.5;
    }
    return self;
}

#pragma mark - Action functions

- (void)wy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    NSString * key = NSStringFromSelector(action);
    if ([[self.wy_actionDic objectForKey:key] boolValue] == NO) {
        [self.wy_actionDic setObject:@(YES) forKey:key];
        [self wy_sendAction:action to:target forEvent:event];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.wy_eventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.wy_actionDic setObject:@(NO) forKey:key];
        });
    }
}

#pragma mark - Setter & Getter functions
- (NSMutableDictionary *)wy_actionDic {
    
    return objc_getAssociatedObject(self, wy_actionDicKey);
}

- (void)setWy_actionDic:(NSMutableDictionary *)wy_actionDic {
    
    objc_setAssociatedObject(self, wy_actionDicKey, wy_actionDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)wy_eventInterval {
    
    return [objc_getAssociatedObject(self, wy_eventIntervalKey) doubleValue];
}

- (void)setWy_eventInterval:(NSTimeInterval)wy_eventInterval {
    
    objc_setAssociatedObject(self, wy_eventIntervalKey, @(wy_eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
