//
//  XWEmitter.m
//  XWHighPlugin
//
//  Created by xiong wei on 15/12/6.
//  Copyright © 2015年 猫爪. All rights reserved.
//  个人博客地址:http://www.jianshu.com/users/538cc0206202/latest_articles

#import "XWEmitter.h"
#import "XWAnimation.h"

@interface XWEmitter ()

@property (nonatomic, strong) XWAnimation * animationView;

@property (nonatomic, assign, getter=isGlaring) bool glaring;


@end

@implementation XWEmitter

- (XWAnimation *)animationView{
    
    if (nil == _animationView) {
        _animationView = [[XWAnimation alloc] init];
        
        _animationView.frame = CGRectMake(0, 0, 10000, 20000);
        
    }
    return _animationView;
}



- (void)atPoint:(NSPoint )position onView:(NSView *)currentView{
    
    [self beat];
    
    
    NSView *view = [currentView superview];
    
    if (!self.isGlaring) {
        
        [self startAtPosition:position onView:view];
        
    }
    
    [self updatePosition:position onView:view];
}

- (void)startAtPosition:(NSPoint)position onView:(NSView *)view
{
    if ( !self.isGlaring )
    {
        self.glaring = YES;
        
        self.animationView.emitterLayer.birthRate = self.animationView.birthRate;
        
        if ( ![view.subviews containsObject:self.animationView] )
        {
            [view addSubview:self.animationView];
        }
        
    }
}

- (void)updatePosition:(NSPoint)position onView:(NSView *)view
{
    position = [self.animationView convertPoint:position fromView:view];
    [self.animationView updatePosition:position];
}


- (void)beat
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop) object:nil];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.3];
}

- (void)stop
{
    if ( _animationView ) {
        
        self.animationView.emitterLayer.birthRate = 0;
        self.glaring = NO;
    }
}

- (void)dealloc{
    [self.animationView removeFromSuperview];
}

@end
