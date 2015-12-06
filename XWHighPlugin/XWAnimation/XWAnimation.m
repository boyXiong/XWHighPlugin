//
//  XWAnimation.m
//  XWHighPlugin
//
//  Created by xiong wei on 15/12/6.
//  Copyright © 2015年 猫爪. All rights reserved.
//  个人博客地址:http://www.jianshu.com/users/538cc0206202/latest_articles

#import "XWAnimation.h"
#import "XWHighPlugin.h"

static id imageContent = nil;


@implementation XWAnimation

- (CAEmitterLayer *)emitterLayer{
    
    if (nil == _emitterLayer) {
        
        
        CAEmitterLayer *emitterLayer = [[CAEmitterLayer alloc] init];
        
        emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);    // 坐标
        
        //运动的轨迹
        //    emitterLayer.emitterSize = CGSizeMake(self.bounds.size.width, 0);               // 粒子大小
        emitterLayer.renderMode = kCAEmitterLayerAdditive;      // 递增渲染模式
        emitterLayer.emitterMode = kCAEmitterLayerOutline;      // 粒子发射模式（向线外发射）
        emitterLayer.emitterShape = kCAEmitterLayerLine;        // 粒子形状（线）
        
        //随机参数的种子
        emitterLayer.seed = (arc4random()%100) + 1;
        
        //     爆炸后的散射星星例子
        CAEmitterCell *starCell = [CAEmitterCell emitterCell];
        
        starCell.emissionLongitude = 0;
        starCell.emissionLatitude = 0;
        
        
        
        //粒子的个数 每秒
        starCell.birthRate = 500;
        
        //粒子速度
        starCell.velocity = 100;
        
        //生命周期
        starCell.lifetime = 1;
        
        starCell.lifetimeRange = 0.5;
        starCell.emissionRange = M_PI * 2;    // 发射角度范围
        starCell.yAcceleration = 75;
        
        if (!imageContent) {
            
            NSString *path = [[XWHighPlugin shared].bundle pathForResource:@"star1" ofType:@"png"];
            
            NSData *data =  [NSData dataWithContentsOfFile:path];
            imageContent = (id)[self dataToCGImageRef:data];
        }
       
        
        starCell.contents = imageContent;
        
        
        starCell.color = [NSColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
        starCell.alphaSpeed = -0.8;
        starCell.scale = 0.15;
        starCell.scaleRange = 0.1;
        
        //旋转
        starCell.spin = 2*M_PI;;
        
        //颜色范围
        starCell.redRange = 0.5;
        starCell.greenRange = 0.5;
        starCell.blueRange = 0.5;
        
        emitterLayer.emitterCells = @[starCell];
        
        _emitterLayer = emitterLayer;
        
    }
    return _emitterLayer;
}


- (CGImageRef)dataToCGImageRef:(NSData *)imageData{
    
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource =
        CGImageSourceCreateWithData(
                                    (CFDataRef)imageData,  NULL);
        
        imageRef = CGImageSourceCreateImageAtIndex(
                                                   imageSource, 0, NULL);
    }
    
    
    return imageRef;
    
    
}

- (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    
    
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource =
        CGImageSourceCreateWithData(
                                    (CFDataRef)imageData,  NULL);
        
        imageRef = CGImageSourceCreateImageAtIndex(
                                                   imageSource, 0, NULL);
    }
    
    
    return imageRef;
}


- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
        
    }
    return self;
}

- (void)setup{
    
    self.birthRate = 1;
    [self setWantsLayer:YES];
    [self.layer addSublayer:self.emitterLayer];
    
    
}


- (void)updatePosition:(NSPoint)position
{
    self.emitterLayer.emitterPosition = CGPointMake(position.x + 3, position.y);
}



@end
