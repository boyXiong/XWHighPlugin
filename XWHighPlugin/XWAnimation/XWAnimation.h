//
//  XWAnimation.h
//  XWHighPlugin
//
//  Created by xiong wei on 15/12/6.
//  Copyright © 2015年 猫爪. All rights reserved.
//  个人博客地址:http://www.jianshu.com/users/538cc0206202/latest_articles

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface XWAnimation : NSView

@property (nonatomic, assign) CGFloat birthRate;

- (void)updatePosition:(NSPoint)position;

@property (nonatomic, strong) CAEmitterLayer * emitterLayer;

@end
