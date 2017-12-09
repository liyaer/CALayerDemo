//
//  TransformVC.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/9.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "TransformVC.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface TransformVC ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *contentImgView;
@property (nonatomic,strong) UIImageView *coverImgView;

@property (nonatomic,strong) UIView *animateCube;
@property (nonatomic,strong) NSTimer *timer;

@end




@implementation TransformVC

-(UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 180)];
        _bgView.backgroundColor = [UIColor redColor];
    }
    return _bgView;
}

-(UIImageView *)contentImgView
{
    if (!_contentImgView)
    {
        _contentImgView = [[UIImageView alloc] initWithFrame:_bgView.bounds];
        _contentImgView.image = [UIImage imageNamed:@"2"];
    }
    return _contentImgView;
}

-(UIImageView *)coverImgView
{
    if (!_coverImgView)
    {
        _coverImgView = [[UIImageView alloc] initWithFrame:_bgView.bounds];
        _coverImgView.layer.anchorPoint = CGPointMake(0, 0.5);
        _coverImgView.frame = _bgView.bounds;//1，改变了anchorPoint，但又不希望frame发生改变，所以重新设置一下
        _coverImgView.image = [UIImage imageNamed:@"1"];
    }
    return _coverImgView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self.view addSubview:self.bgView];
    //    [_bgView addSubview:self.contentImgView];
    //    [_contentImgView addSubview:self.coverImgView];//2，这个不能加在bgView上，会影响旋转的动画效果
    
    [self animationCube];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^
     {
         //3，这一步是为了将bgView.layer的anchorPoint和self.View的anchorPoint重合，因为layer的平移、旋转、缩放都是基于anchorPoint而言的
         //        [self.bgView setFrame:CGRectMake((kScreenWidth -self.bgView.bounds.size.width)/2, (kScreenHeight -self.bgView.bounds.size.height)/2, self.bgView.bounds.size.width, self.bgView.bounds.size.height)];
         self.bgView.layer.position = self.view.center;//和上面那句代码效果一样
         
         
         //CATransform3D 写法一：键值对方式设置transform
         //        [self.bgView.layer setValue:@(kScreenWidth / self.bgView.bounds.size.width) forKeyPath:@"transform.scale.x"];
         //        [self.bgView.layer setValue:@(kScreenHeight / self.bgView.bounds.size.height) forKeyPath:@"transform.scale.y"];
         //        [self.coverImgView.layer setValue:@(M_PI_2) forKeyPath:@"transform.rotation.y"];
         
         //CATransform3D 写法二：layer.transform属性设置transform
         self.bgView.layer.transform = CATransform3DMakeScale(kScreenWidth / self.bgView.bounds.size.width, kScreenHeight / self.bgView.bounds.size.height, 1.0);
         self.coverImgView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
     }
                     completion:^(BOOL finished)
     {
         //查看完整效果的话，把上面CATransform3D代码注释掉
         //        [UIView animateWithDuration:2.0 animations:^
         //        {
         //            //CGAffineTransform只有这一种写法，通过属性设置
         //            self.bgView.transform = CGAffineTransformMakeTranslation(0, 20);
         //            self.contentImgView.transform = CGAffineTransformMakeScale(1, 0.8);
         //            self.coverImgView.transform = CGAffineTransformMakeRotation(M_PI_4);
         //        }];
     }];
}

-(void)animationCube
{
    CGRect targetBounds = (CGRect){CGPointZero,CGSizeMake(200, 200)};
    self.animateCube = [[UIView alloc] initWithFrame:targetBounds];
    _animateCube.center = self.view.center;
    [self.view addSubview:self.animateCube];
    
    UIView *test = [[UIView alloc] initWithFrame:targetBounds];// front
    test.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
    test.layer.transform = CATransform3DTranslate(test.layer.transform, 0, 0, 100);
    
    UIView *test1 = [[UIView alloc] initWithFrame:targetBounds];// back
    test1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    test1.layer.transform = CATransform3DTranslate(test1.layer.transform, 0, 0, -100);
    
    UIView *test2 = [[UIView alloc] initWithFrame:targetBounds];// left
    test2.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    test2.layer.transform = CATransform3DTranslate(test2.layer.transform, -100, 0, 0);
    test2.layer.transform = CATransform3DRotate(test2.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test3 = [[UIView alloc] initWithFrame:targetBounds];// right
    test3.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    test3.layer.transform = CATransform3DTranslate(test3.layer.transform, 100, 0, 0);
    test3.layer.transform = CATransform3DRotate(test3.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test4 = [[UIView alloc] initWithFrame:targetBounds];// head
    test4.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    test4.layer.transform = CATransform3DTranslate(test4.layer.transform, 0, 100, 0);
    test4.layer.transform = CATransform3DRotate(test4.layer.transform, M_PI_2, 1, 0, 0);
    
    UIView *test5 = [[UIView alloc] initWithFrame:targetBounds];// foot
    test5.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    test5.layer.transform = CATransform3DTranslate(test5.layer.transform, 0, -100, 0);
    test5.layer.transform = CATransform3DRotate(test5.layer.transform, M_PI_2, -1, 0, 0);
    
    [self.animateCube addSubview:test];
    [self.animateCube addSubview:test1];
    [self.animateCube addSubview:test2];
    [self.animateCube addSubview:test3];
    [self.animateCube addSubview:test4];
    [self.animateCube addSubview:test5];
    
    //CGAffineTransform 2D缩放
    self.animateCube.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    // Label
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectOffset(self.animateCube.frame, 0, - 100);
    label.text = @"AnimatedCube";
    [label sizeToFit];
    [self.view addSubview:label];
    
    //CATransform3DIdentity单位矩阵，不产生任何动画效果，常用于恢复原始效果，也可以看成初始化
    __block CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500;
    self.animateCube.layer.sublayerTransform = transform;
    float angle = M_PI / 360;
    //最好采用CADislink代替NSTimer,这里主要是为了传参方便使用了timer
    _timer = [NSTimer timerWithTimeInterval:1.0/60 repeats:YES block:^(NSTimer * _Nonnull timer)
      {
          //连续动画时用CATransform3DRotate，单次动画用CATransform3DMakeRotate即可
          transform = CATransform3DRotate(transform, angle, 1, 1, 0.5);
          self.animateCube.layer.sublayerTransform = transform;
      }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}




-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

-(void)dealloc
{
    NSLog(@"%@ release！",[self class]);
}


@end
