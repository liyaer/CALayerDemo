//
//  ImplicitAnimationVC.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/9.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ImplicitAnimationVC.h"


#define WIDTH 50


@interface ImplicitAnimationVC ()
{
    CALayer *layer;
}
@end




@implementation ImplicitAnimationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //CALayer的隐式动画
    [self Demo1];
}

#pragma mark - 隐式动画（改变bounds和position属性形成的隐式动画）
-(void)Demo1
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    layer = [[CALayer alloc] init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    //设置中心点
    layer.position = CGPointMake(size.width/2, size.height/2);
    //设置大小
    layer.bounds = CGRectMake(0, 0, WIDTH,WIDTH);
    //设置圆角,图形的话无需设置maskToBounds即可正常显示圆角
    layer.cornerRadius = WIDTH/2;
    //设置阴影
    layer.shadowColor = [UIColor redColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = .9;
    //设置边框
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 3;
    //    //设置锚点
    //    layer.anchorPoint=CGPointZero;
    
    //    layer.masksToBounds = YES;这个属性设置为yes,会影响阴影效果的显示
    [self.view.layer addSublayer:layer];
}

// 点击放大、缩小
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGFloat width = layer.bounds.size.width;
    width = width==WIDTH ? WIDTH*4 : WIDTH;
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position = [touch locationInView:self.view];
    layer.cornerRadius = width/2;
}




-(void)dealloc
{
    NSLog(@"%@ release！",[self class]);
}


@end
