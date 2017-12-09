//
//  CAReplicatorLayerVC.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/9.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CAReplicatorLayerVC.h"

@interface CAReplicatorLayerVC ()

@end

@implementation CAReplicatorLayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //--------------------------------CAReplicatorLayer--------------------------
    
    [self Demo9];
}

#pragma mark - 还没理解透彻，前半部分是按指定路径进行动画，后半部分是不断复制新的layer并修改颜色
-(void)Demo9
{
    //前半部分
    CGMutablePathRef ms = CGPathCreateMutable();
    CGPathAddEllipseInRect(ms, nil, CGRectInset(CGRectMake(0, 50, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width), 50,50));
    // 具体的layer
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    tView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - 50, 300);
    tView.layer.cornerRadius = 5;
    tView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // 动作效果
    CAKeyframeAnimation *loveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    loveAnimation.path = ms;
    loveAnimation.duration = 8;
    loveAnimation.repeatCount = MAXFLOAT;
    [tView.layer addAnimation:loveAnimation forKey:@"loveAnimation"];
    
    
    //后半部分
    CAReplicatorLayer *loveLayer = [CAReplicatorLayer layer];
    loveLayer.instanceCount = 4;                // 40个layer
    loveLayer.instanceDelay = 2;               // 每隔0.2出现一个layer
    loveLayer.instanceColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    loveLayer.instanceGreenOffset = -0.03;       // 颜色值递减。
    loveLayer.instanceRedOffset = -0.02;         // 颜色值递减。
    loveLayer.instanceBlueOffset = -0.01;        // 颜色值递减。
    [loveLayer addSublayer:tView.layer];
    [self.view.layer addSublayer:loveLayer];
}





-(void)dealloc
{
    NSLog(@"%@ release！",[self class]);
}


@end
