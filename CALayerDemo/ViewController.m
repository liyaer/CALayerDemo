//
//  ViewController.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/1.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import "KCView.h"


#define WIDTH 50
#define PHOTO_HEIGHT 150
static CGFloat num;


@interface ViewController ()<CALayerDelegate>
{
    CALayer *layer;
    CAShapeLayer *circle;
}
@property (nonatomic, strong) CADisplayLink *link;

@end




@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //CALayer的隐式动画
//    [self Demo1];
    
    //CALayer的绘制操作
//    [self Demo2];
//    [self Demo2_1];
//    [self Demo2_2];
//    [self Demo2_3];
    
    //继承于CALayer的子类的绘制操作，并且阐述了UIView drawRect绘制的本质
//    [self Demo3];
    
    
//--------------------------CALayer的mask属性的应用----------------------------
    
    //实现Label文字颜色渐变
    [self Demo4];
    [self Demo4_1];
    [self Demo4_2];
    
    //模拟两张内容一样单颜色不同的图片，用户点击区域显示彩色，未点击区域灰色
//    [self Demo5];
    
    //【图片内容】虚化渐变显示
//    [self Demo6];
//    [self Demo6_1];
    
    //【图片边缘内容】虚化显示
//    [self Demo7];
    
    //动画效果
//    [self Demo8];

//--------------------------------CAReplicatorLayer--------------------------
    
//    [self Demo9];
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
    //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
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




#pragma mark - 除了常用的drawRect和CAShapeLayer绘制外，CALayer也可以直接绘制（其实本质都是对图层的操作）
-(void)Demo2
{
    //自定义图层
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position = CGPointMake(PHOTO_HEIGHT/2, PHOTO_HEIGHT/2);
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
-(void)和下面代理方法重复二者只能存在一个drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
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

#pragma mark - 利用图层形变解决图像倒立问题
-(void)Demo2_2
{
    [self Demo2_1];
    
    //利用图层形变解决图像倒立问题(2_1中是翻转了Y轴，对于图像来说，就是绕X轴做了个旋转)
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);和下面一句代码等效
    [layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];
}

//代理方法：绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIImage *image=[UIImage imageNamed:@"photo.png"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
}

#pragma mark - 事实上如果仅仅就显示一张图片在图层中当然没有必要那么麻烦，直接设置图层contents就可以了，不牵涉到绘图也就没有倒立的问题了
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

#pragma mark - 注意和Demo4的区别，这里模拟的是iOS8上的滑动解锁动画效果，只不过这里动画比较生硬
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
//        gradientLayer.transform = CATransform3DMakeTranslation(150, 0, 0);
        gradientLayer.transform = CATransform3DTranslate(gradientLayer.transform, 150, 0, 0);
    });
    
    
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
    //模拟一次动画的实现
    [UIView animateWithDuration:3.0 animations:^
    {
        CGRect Frame = maskView.frame;
        Frame.origin.x = 250;
        maskView.frame = Frame;
    }];
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




#pragma mark - 【图片内容】虚化渐变显示  通过透明度渐变的maskLayer实现
-(void)Demo6
{
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


@end
