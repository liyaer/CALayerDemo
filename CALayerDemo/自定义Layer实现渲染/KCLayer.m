//
//  Dlayer.m
//  CALayerDemo
//
//  Created by 杜文亮 on 2017/12/2.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "KCLayer.h"

@implementation KCLayer

-(void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"3-drawInContext:");
    NSLog(@"CGContext:%@",ctx);
    
    // Star Drawing
    CGContextMoveToPoint(ctx, 94.5, 33.5);
    CGContextAddLineToPoint(ctx,104.02, 47.39);
    CGContextAddLineToPoint(ctx,120.18, 52.16);
    CGContextAddLineToPoint(ctx,109.91, 65.51);
    CGContextAddLineToPoint(ctx,110.37, 82.34);
    CGContextAddLineToPoint(ctx,94.5, 76.7);
    CGContextAddLineToPoint(ctx,78.63, 82.34);
    CGContextAddLineToPoint(ctx,79.09, 65.51);
    CGContextAddLineToPoint(ctx,68.82, 52.16);
    CGContextAddLineToPoint(ctx,84.98, 47.39);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


@end
