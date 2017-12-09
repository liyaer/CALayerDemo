//
//  MaskVC.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/9.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "MaskVC.h"


static CGFloat num;


@interface MaskVC ()
{
    CALayer *layer;
    CAShapeLayer *circle;
}
@property (nonatomic, strong) CADisplayLink *link;

@end




@implementation MaskVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//--------------------------CALayer的mask属性的应用----------------------------
    //实现Label文字颜色渐变
//    [self Demo4];
//    [self Demo4_1];
//    [self Demo4_2];
//    
    //模拟两张内容一样单颜色不同的图片，用户点击区域显示彩色，未点击区域灰色
//    [self Demo5];
    
    //【图片内容】虚化渐变显示
//    [self Demo6];
//    [self Demo6_1];
    
    //【图片边缘内容】虚化显示
//    [self Demo7];
    
//    动画效果
    [self Demo8];
}

#pragma mark - CAGradientLayer 系统提供的CALayer的子类，用来生成两种或更多颜色平滑渐变的
-(void)Demo4
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(10, 200, 300, 25);
    //设置渐变梯度（水平，垂直，对角）
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
    //这里设置了三种颜色，但是注意：CAGradientLayer作用就是让颜色平滑过渡，也就是说从我们设置的上个颜色到下一个颜色，中间会有很多其他颜色，这些由系统帮我们实现平滑的过渡效果
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor];
    [self.view.layer addSublayer:gradientLayer];//这里必须绘制，因为它不是作为mask层，而是要作为被设置mask层的layer（作为mask层的layer无需绘制其本身内容，Demo6中有说明）
    
    //作为mask层显示的坐标是相对于设置mask的View来说的
    UILabel *label = [[UILabel alloc] initWithFrame:gradientLayer.bounds];
    label.text = @"红黄绿渐变!@#$%&QWERTYU";
    label.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:label];
    
    gradientLayer.mask = label.layer;
}

#pragma mark - 注意和Demo4的区别，这里模拟的是iOS8上的滑动解锁动画效果
-(void)Demo4_1
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 150, 25);
    //设置渐变梯度（水平，垂直，对角）
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
    //这里设置了三种颜色，但是注意：CAGradientLayer作用就是让颜色平滑过渡，也就是说从我们设置的上个颜色到下一个颜色，中间会有很多其他颜色，这些由系统帮我们实现平滑的过渡效果
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    
    //简单模拟个动画效果
    CABasicAnimation *positionBase = [CABasicAnimation animationWithKeyPath:@"position"];
    [positionBase setToValue:[NSValue valueWithCGPoint:CGPointMake(225, 25/2)]];
    positionBase.duration = 3.0;
    positionBase.repeatCount = MAXFLOAT;
    positionBase.removedOnCompletion = NO;//设置无线循环记得设置成NO
    positionBase.autoreverses = YES;
    [gradientLayer addAnimation:positionBase forKey:@"positionBase"];
    
    
    //作为mask层显示的坐标是相对于设置mask的View来说的
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 25)];
    label.text = @"红黄绿渐变!@#$%&QWERTYU";
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor redColor];
    label.layer.mask = gradientLayer;
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark - iOS8以后出现maskView,是对layer的mask属性在UIKit层面的一次封装。因此maskView可以使用UIView的动画效果，本质上和设置layer的mask属性是一样的
-(void)Demo4_2
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 150, 25);
    //设置渐变梯度（水平，垂直，对角）
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
    //这里设置了三种颜色，但是注意：CAGradientLayer作用就是让颜色平滑过渡，也就是说从我们设置的上个颜色到下一个颜色，中间会有很多其他颜色，这些由系统帮我们实现平滑的过渡效果
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    
    [maskView.layer addSublayer:gradientLayer];
    
    
    //作为mask层显示的坐标是相对于设置mask的View来说的
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 25)];
    label.text = @"红黄绿渐变!@#$%&QWERTYU";
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor redColor];
    label.maskView = maskView;
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor blackColor];
    //模拟动画的实现
    [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^
     {
         //使用UIView对象实现动画
         //        CGRect Frame = maskView.frame;
         //        Frame.origin.x = 250;
         //        maskView.frame = Frame;
         
#warning 虽然maskView.layer 和 gradientLayer是一个对象，但是下面只能使用maskView.layer，只有这样才会受上面3秒动画的约束
         //使用CALayer对象实现动画
         //[maskView.layer setValue:[NSValue valueWithCGPoint:CGPointMake(225, 25/2)] forKey:@"position"];
         maskView.layer.position = CGPointMake(225, 25/2);//和上面键值对设置达到效果一样
         
     } completion:nil];
}




#pragma mark - 模拟两张内容一样单颜色不同的图片，用户点击区域显示彩色，未点击区域灰色
-(void)Demo5
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImgView setImage:[UIImage imageNamed:@"photo"]];
    [self.view addSubview:bgImgView];
    
    layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = self.view.center;
    layer.cornerRadius = 50;
    layer.backgroundColor = [UIColor redColor].CGColor;//默认是透明的，这里随便设置个背景色（不会影响设置mask的View的显示），作为mask的图层不能是透明的
    
    UIImageView *maskImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    maskImgView.image = [UIImage imageNamed:@"bg"];
    maskImgView.layer.mask = layer;
    [self.view addSubview:maskImgView];
}

//针对Demo5设计的，其他Demo运行时若产生影响，请注释掉
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.view];
    layer.position = position;
}




#pragma mark - 【图片内容】虚化渐变显示  通过透明度渐变的maskLayer实现
-(void)Demo6
{
    self.view.backgroundColor = [UIColor brownColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 300, 300);
    //设置渐变梯度（水平，垂直，对角）
    [gradientLayer setStartPoint:CGPointMake(1.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(0.0, 0.0)];
    gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    [self.view.layer addSublayer:gradientLayer];// --- 1 ---，展示绘制的图层
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
    imgView.image = [UIImage imageNamed:@"bg"];
    //    imgView.layer.mask = gradientLayer; // --- 2 ---
    [self.view addSubview:imgView];
    
    /*
     *   本来以为写了1，2效果会是看到绘制图和渐变图两张图片，可实际效果只有一张渐变图，因为2的缘故导致的。这里通过这样的方式展示过程，先分别看到原始图片和遮罩图片的样式，2秒后生成渐变图
     
     注意这里仅仅是为了便于理解才这样写，真正实现这一功能，只需打开注释2，注释掉1，3即可
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       imgView.layer.mask = gradientLayer;
                   });// --- 3 ---
}

#pragma mark - 倒影效果，但是看起来效果很渣渣啊
-(void)Demo6_1
{
    self.view.layer.backgroundColor = [UIColor brownColor].CGColor;
    
    UIImage *balloon = [UIImage imageNamed:@"bg"];//换图片即可
    
    //主要图层
    CALayer *topLayer = [[CALayer alloc] init];
    [topLayer setBounds:CGRectMake(0.0f, 0.0f, 320.0, 240.0)];
    [topLayer setPosition:CGPointMake(160.0f, 120.0f)];
    [topLayer setContents:(id)[balloon CGImage]];
    [[[self view] layer]addSublayer:topLayer];
    
    //倒影图层 + 虚化效果
    CALayer *reflectionLayer =[[CALayer alloc] init];
    [reflectionLayer setBounds:CGRectMake(0.0f, 0.0f,320.0, 240.0)];
    [reflectionLayer setPosition:CGPointMake(158.0f, 362.0f)];
    [reflectionLayer setContents:[topLayer contents]];
    [reflectionLayer setValue:DegreesToNumber(180.0f) forKeyPath:@"transform.rotation.x"];
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:[reflectionLayer bounds]];
    [gradientLayer setPosition:CGPointMake([reflectionLayer bounds].size.width/2, [reflectionLayer bounds].size.height/2)];
    [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor clearColor] CGColor],(id)[[UIColor blackColor]CGColor], nil]];
    //这里受到了上面绕x轴翻转的影响，可以把翻转代码注释掉，对比一下
    [gradientLayer setStartPoint:CGPointMake(0.5,0.35)];
    [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
    
    [reflectionLayer setMask:gradientLayer];
    [[[self view] layer]addSublayer:reflectionLayer];
}

NSNumber *DegreesToNumber(CGFloat degrees)
{
    return [NSNumber numberWithFloat: DegreesToRadians(degrees)];
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}




#pragma mark - 【图片边缘内容】虚化显示  通过maskLayer的shadow实现
-(void)Demo7
{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:image];
    image.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, CGRectInset(CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width), 50,50));//画圆
    //    CGPathAddRect(path, nil, CGRectInset(CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width), 50,50));//画方
    shape.path = path;
    shape.shadowOpacity = 1;//设置阴影必须设置的值，因为默认值是0
    shape.shadowRadius = 45;//值越大，阴影越大
    //    shape.shadowOffset = CGSizeMake(30, 30);不设置的话默认向四周等距离发散
    [self.view.layer addSublayer:shape];
    
    image.layer.mask = shape;
}




#pragma mark - maskLayer 动画效果
-(void)Demo8
{
    //创建一个CAShape
    CALayer *bgLayer = [CALayer layer];
    bgLayer.bounds          = CGRectMake(0, 0, 200, 200);
    bgLayer.backgroundColor = [UIColor redColor].CGColor;
    bgLayer.position        = self.view.center;
    
    //创建一个CAShapeLayer作为MaskLayer
    circle = [CAShapeLayer layer];
    circle.path      = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100)
                                                      radius:20
                                                  startAngle:0
                                                    endAngle:2 * M_PI
                                                   clockwise:YES].CGPath;
    circle.lineWidth = 5;
    circle.fillColor = [UIColor greenColor].CGColor;
    circle.fillRule  = kCAFillRuleEvenOdd;
    
    //设置maskLayer
    bgLayer.mask = circle;
    [self.view.layer addSublayer:bgLayer];
    
    //添加计时器（不延迟的话看不到效果，也许是因为动画间隔时间太短的缘故，这里直接等绘制完成在进行动画）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
   {
       //这里不考虑释放(因为是CADisplayLink的缘故，就算不及时释放也不影响dealloc,最终还是会释放，这一点可以查看NSTimerDemo)
       self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(action)];
       [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
   });
}

- (void)action
{
    num ++;
    NSLog(@"=======%.2f",num);
    circle.path      = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100)
                                                      radius:20 + num
                                                  startAngle:0
                                                    endAngle:2 * M_PI
                                                   clockwise:YES].CGPath;
    if (num > 130)
    {
        [self.link invalidate];
    }
}




-(void)dealloc
{
    num = 0;//静态变量存储在全局区，使用完记得及时回复默认值，否则会影响下一次的使用
    NSLog(@"%@ release！",[self class]);
}


@end
