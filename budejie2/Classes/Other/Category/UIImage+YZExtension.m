//
//  UIImage+YZExtension.m
//  budejie2
//
//  Created by Yue on 8/14/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "UIImage+YZExtension.h"


@implementation UIImage (YZExtension)
/**
 通过裁减，将调用者对象转为圆形
 */
- (UIImage *)circleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁减
    CGContextClip(ctx);
    
    //将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
