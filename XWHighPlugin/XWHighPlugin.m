//
//  XWHighPlugin.m
//  XWHighPlugin
//
//  Created by xiong wei  on 15/12/5.
//  Copyright © 2015年 猫爪. All rights reserved.
//  个人博客地址:http://www.jianshu.com/users/538cc0206202/latest_articles

#import "XWHighPlugin.h"
#import "XWEmitter.h"
#import <AppKit/AppKit.h>

@interface XWHighPlugin ()

@property (nonatomic, strong) XWEmitter * emitter;

/** 启动勾选 */
@property (nonatomic, weak) NSMenuItem * enabledMenuItem;

@property (nonatomic, assign) BOOL enable;




@end

@implementation XWHighPlugin

+ (void)pluginDidLoad:(NSBundle*)plugin {
    
     [[self shared] setBundle: plugin];

}

#pragma mark - shared 单例对象
+(id) shared {
    static XWHighPlugin * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}


- (XWEmitter *)emitter{
    if (nil == _emitter) {
        _emitter= [[XWEmitter alloc] init];
    }
    return _emitter;
}


- (instancetype)init{
    if (self = [super init]) {
        /** 添加一个通知 Xcode 的已经完全加载，并调用 applicationDidFinishLaunching: 这个方法*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
        
    }
    return self;
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    
    //移除，监听一次就够了
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    
    [self addSettingMenu];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
    
}

- (void)addSettingMenu{
    
    //1. 获取到Xcode 导航条的Windows 选项菜单
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    
    //2. 如果获取到
    if (editMenuItem) {
//        
        //2.1 增加一条划线
        [editMenuItem.submenu addItem:[NSMenuItem separatorItem]];

        
        //2.2 添加用户偏好测试选项，并增加快捷键
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] init];
        newMenuItem.title = @"XWHigthPlugin";
        [editMenuItem.submenu addItem: newMenuItem];
        
        
        //2.3.1添加 子标题 启动与不启动效果
        NSMenu * menu = [[NSMenu alloc] init];
        
        newMenuItem.submenu = menu;

        NSMenuItem * enabledMenuItem = [[NSMenuItem alloc] init];
        enabledMenuItem.title = @"Enable  ✓";
        enabledMenuItem.action = @selector(toggleEnabled:);
        enabledMenuItem.target = self;
        [menu addItem:enabledMenuItem];
        self.enabledMenuItem = enabledMenuItem;
        
        self.enable = YES;
    }
}


- (void)textDidChange:(NSNotification *)notification{
    
    
    if ( [notification.object isKindOfClass:NSClassFromString(@"IDEConsoleTextView")])
        return;
    
    if ( [notification.object isKindOfClass:NSClassFromString(@"DVTSourceTextView")] )
    {
        NSTextView * textView = (NSTextView *)notification.object;
        
        NSInteger editingLocation = [[[textView selectedRanges] objectAtIndex:0] rangeValue].location;
        NSUInteger count = 0;
        NSRect targetRect = *[textView.layoutManager rectArrayForCharacterRange:NSMakeRange(editingLocation, 0)
                                                   withinSelectedCharacterRange:NSMakeRange(editingLocation, 0)
                                                                inTextContainer:textView.textContainer
                                                                      rectCount:&count];
        
        //emitter 发射体
        
        [self.emitter atPoint:targetRect.origin onView:textView];
        
    }
    
}

#pragma mark - 启动效果
- (void)toggleEnabled:(id)sender
{
    self.enable = !self.enable;
    
    [self enableHighXcode:self.enable];
}


- (void)enableHighXcode:(BOOL)enable{
    
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:NSTextDidChangeNotification
                                                   object:nil];
        
        self.enabledMenuItem.title = @"Enable  ✓";
    }else{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextDidChangeNotification object:nil];
        
        self.enabledMenuItem.title = @"Enable  ✕";

    }
    
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







@end
