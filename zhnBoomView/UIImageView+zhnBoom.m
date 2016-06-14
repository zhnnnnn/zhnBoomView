//
//  UIImageView+zhnBoom.m
//  zhnBoomView
//
//  Created by zhn on 16/6/14.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIImageView+zhnBoom.h"
#import <QuartzCore/QuartzCore.h>
// 粒子的大小
static const CGFloat boomLayerWidthHeight = 10;
@implementation UIImageView (zhnBoom)

- (void)boom{
    
    CAKeyframeAnimation * shakeAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    shakeAnima.delegate = self;
    CGPoint oldCenter = self.center;
    shakeAnima.duration = 0.15;
    shakeAnima.values = @[[NSValue valueWithCGPoint:CGPointMake(oldCenter.x - 5, oldCenter.y)],[NSValue valueWithCGPoint:CGPointMake(oldCenter.x, oldCenter.y)],[NSValue valueWithCGPoint:CGPointMake(oldCenter.x - 5, oldCenter.y)],[NSValue valueWithCGPoint:CGPointMake(oldCenter.x, oldCenter.y)]];
    [shakeAnima setValue:@"shakeAnima" forKey:@"shakeAnima"];
    [self.layer addAnimation:shakeAnima forKey:nil];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:@"shakeAnima"]isEqualToString:@"shakeAnima"]) {
        [self boomWithView:self];
    }
}

- (void)boomWithView:(UIImageView *)boomImageView{
    
    
    CGFloat yMax = boomImageView.frame.size.width / boomLayerWidthHeight;
    CGFloat xMax = boomImageView.frame.size.height / boomLayerWidthHeight;
    
    for(int yIndex = 0; yIndex < yMax; yIndex ++) {
        
        CGFloat ydelta = boomLayerWidthHeight;
        
        for(int xIndex = 0; xIndex < xMax; xIndex ++) {

            CGFloat xdelta            = boomLayerWidthHeight;
            CGFloat boomLayerX        = xIndex * xdelta;
            CGFloat boomLayerY        = yIndex * ydelta;
            CALayer * boomLayer       = [CALayer layer];
            boomLayer.cornerRadius    = boomLayerWidthHeight/2;
            

            boomLayer.frame           = CGRectMake(boomLayerX, boomLayerY, boomLayerWidthHeight, boomLayerWidthHeight);
            CGPoint boomCenter        = CGPointMake(boomLayer.frame.origin.x + (boomLayerWidthHeight/2), boomLayer.frame.origin.y + (boomLayerWidthHeight/2));
           
            CGFloat xPercent          = boomCenter.x / boomImageView.frame.size.width;
            CGFloat yPercent          = boomCenter.y / boomImageView.frame.size.height;

            boomLayer.backgroundColor = [self colorWithLayer:boomImageView.layer xPercent:xPercent yPercent:yPercent].CGColor;
            [boomImageView.layer addSublayer:boomLayer];
        }
    }
    boomImageView.image = nil;
    [self boomAnimation:boomImageView];
}

- (void)boomAnimation:(UIImageView *)boomImageView{
    
    for (CALayer * tempLayer in boomImageView.layer.sublayers) {
        // 运动动画
        CAKeyframeAnimation * positionAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnima.duration = (arc4random()%10) * 0.05 + 0.3;
        positionAnima.fillMode = kCAFillModeForwards;
        positionAnima.removedOnCompletion = false;
        positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        // 动画路径
        UIBezierPath * path = [self animationPathWithLayer:tempLayer supView:boomImageView];
        positionAnima.path = path.CGPath;
        
        // 透明动画
        CABasicAnimation * opacityAimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAimation.duration = positionAnima.duration;
        opacityAimation.fromValue = @1;
        opacityAimation.toValue = @0;
        opacityAimation.removedOnCompletion = false;
        opacityAimation.fillMode = kCAFillModeForwards;
        // 形变动画
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = @(0.5 + (arc4random()%10) * 0.2);
        scaleAnimation.duration = positionAnima.duration;
        
        [tempLayer addAnimation:scaleAnimation forKey:nil];
        [tempLayer addAnimation:opacityAimation forKey:nil];
        [tempLayer addAnimation:positionAnima forKey:nil];
    }
    
    [self performSelector:@selector(removeView) withObject:nil afterDelay:2];
}

- (void)removeView{
    
    [self removeFromSuperview];
    
}

- (UIBezierPath *)animationPathWithLayer:(CALayer *)boomLayer supView:(UIImageView *)boomImageView{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:boomLayer.position];
    CGFloat pathX       = (-0.5 * boomImageView.frame.size.width) + arc4random()%((int)(2 * boomImageView.frame.size.width));
    
    CGFloat pathY       = 1.5 * boomImageView.frame.size.height + arc4random()%((int)(0.8 * boomImageView.frame.size.height));
    CGPoint controlPoint;
    CGFloat controlY    = (-1.5 * boomImageView.frame.size.height) +  arc4random()%((int)boomImageView.frame.size.height);
    CGFloat controlX    = (pathX + boomLayer.position.x) / 2;
    controlPoint        = CGPointMake(controlX, controlY);
    
    [path addQuadCurveToPoint:CGPointMake(pathX, pathY) controlPoint:controlPoint];
    return path;
}



- (UIColor *)colorWithLayer:(CALayer *)showLayer xPercent:(CGFloat)xpercent yPercent:(CGFloat)ypercent{
    
    unsigned char pixel[4]     = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context       = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGFloat x                  = showLayer.frame.size.width * xpercent;
    CGFloat y                  = showLayer.frame.size.height * ypercent;
    
    CGContextTranslateCTM(context, -x, -y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end
