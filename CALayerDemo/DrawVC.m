//
//  DrawVC.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/9.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "DrawVC.h"
#import "KCView.h"


#define PHOTO_HEIGHT 150


@interface DrawVC ()<CALayerDelegate>
{
    CALayer *layer;
}
@end




@implementation DrawVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //CALayer的绘制操作
//    [self Demo2];
//    [self Demo2_1];
    [self Demo2_2];
//    [self Demo2_3];
    
    //继承于CALayer的子类的绘制操作，并且阐述了UIView drawRect绘制的本质
//    [self Demo3];
}

#pragma mark - 除了常用的drawRect和CAShapeLayer绘制外，CALayer也可以直接绘制（其实本质都是对图层的操作）
-(void)Demo2
{
    //自定义图层
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = PHOTO_HEIGHT/2;
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    layer.masksToBounds = YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    //设置边框
    layer.borderColor = [UIColor blackColor].CGColor;
    layer.borderWidth = 2;
    //设置图层代理
    layer.delegate = self;
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

#pragma mark - 解决设置masksToBounds=YES时无法显示阴影效果这一问题
-(void)Demo2_1
{
    CGPoint position = self.view.center;
    CGRect bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius = PHOTO_HEIGHT/2;
    CGFloat borderWidth = 2;
    
    //阴影图层
    CALayer *layerShadow = [[CALayer alloc]init];
    layerShadow.bounds = bounds;
    layerShadow.position = position;
    layerShadow.cornerRadius = cornerRadius;
    layerShadow.shadowColor = [UIColor redColor].CGColor;
    layerShadow.shadowOffset = CGSizeMake(2, 1);
    layerShadow.shadowOpacity = 1;
    layerShadow.borderColor = [UIColor whiteColor].CGColor;
    layerShadow.borderWidth = borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    layer = [[CALayer alloc] init];
    layer.bounds = bounds;
    layer.position = position;
    layer.backgroundColor = [UIColor greenColor].CGColor;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor blackColor].CGColor;
    layer.borderWidth = borderWidth;
    layer.delegate = self;//设置图层代理
    [self.view.layer addSublayer:layer];
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

//代理方法：绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)Demo2Demo2_1使用drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    /*
     *  注意：
     1，一般使用CGContextRef绘制我们会先写这句话，用来将CoreGraphics框架中默认的向上，向右为正方向的坐标轴转换为iOS中向下，向右为正方向的坐标轴
     CGContextRef context = UIGraphicsGetCurrentContext();
     2，如果没有明确的转换坐标系统，那么当前坐标系统是默认的向上，向右为正方向
     */
#warning 按理说，这里应该是默认的坐标系统（向上，向右正方向）；应该是系统做的优化处理，传进来的ctx直接是转换后的坐标系统（向下，向右正方向），方便我们直接绘制内容，而省去转换坐标系统的这一步操作。最下面两句代码可以证明这一说法
    
    //即将进行CTM（也有人叫矩阵操作）操作，保存变换前的状态
    CGContextSaveGState(ctx);
    
    //CTM操作，恢复Quarz2D默认坐标系统，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);//翻转Y轴，使坐标系变成向上，向右为正方向
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);//坐标轴向下平移PHOTO_HEIGHT（最开始也说了，绘制是相对于设置了代理的图层而言的，自然坐标系也是对于该图层而言，所以平移的距离是PHOTO_HEIGHT，就能保证坐标原点从左上角移动到左下角，满足Quarz2D的坐标系统）
    
    //开始绘制
    UIImage *image=[UIImage imageNamed:@"photo.png"];
    //注意这个位置是相对于图层而言的不是屏幕（如果不进行CTM操作，那么这个函数执行完最终展示出来的图片是倒立的，因为CoreGraphics默认的坐标系和iOS默认的坐标系Y轴相反的缘故）。
    //一句话总结：CGContextDrawImage绘制的图片想要正确显示，那么ctx的坐标体统一定要是默认的Quarz2D下的坐标系统。（如果当前不是，通过CTM转换，就像这里一样）
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    //改变CTM进行的绘制完毕，恢复之前的状态
    CGContextRestoreGState(ctx);
    
    //验证warning中的说法，传进来的ctx坐标系是转换后的（向下，向右正方向）
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 75, 75));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
}




#pragma mark - 利用图层形变解决图像倒立问题（Demo2是在绘制时通过翻转坐标系达到效果，这里是绘制完成后翻转图片达到效果）
-(void)Demo2_2
{
    [self Demo2_1];
    
    //利用图层形变解决图像倒立问题(2_1中是翻转了Y轴，对于图像来说，就是绕X轴做了个旋转)
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);和下面一句代码等效
//    [layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];
    
    //动画效果
    CABasicAnimation *rotationBase = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [rotationBase setToValue:@M_PI];
    rotationBase.duration = 3.0;
    rotationBase.repeatCount = MAXFLOAT;
    rotationBase.removedOnCompletion = NO;//设置无线循环记得设置成NO
    rotationBase.autoreverses = YES;
    [layer addAnimation:rotationBase forKey:@"rotation_x"];
}

//代理方法：绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIImage *image=[UIImage imageNamed:@"photo.png"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
}




#pragma mark - 事实上如果仅仅就显示一张图片在图层中当然没有必要那么麻烦，直接设置图层contents就可以了，不牵涉到绘图也就没有倒立的问题了（并且绘制的图片没有这样设置清晰）
-(void)Demo2_3
{
    [self Demo2_1];
    layer.delegate = nil;//清空Demo2_1中设置的delegate
    
    UIImage *iamge = [UIImage imageNamed:@"photo"];
    layer.contents = (id)iamge.CGImage;
}




#pragma mark - 继承于CALayer的子类的绘制操作，并且阐述了UIView drawRect绘制的本质
-(void)Demo3
{
    KCView *view = [[KCView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor brownColor];
    [self.view addSubview:view];
}




-(void)dealloc
{
    if (layer)
    {
        //这两句随便写一句，即可解决CALayer设置了delelgate popVC时崩溃的问题，但是不知道崩溃原理
//        layer.delegate = nil;
        [layer removeFromSuperlayer];
    }
    NSLog(@"%@ release！",[self class]);
}

@end
