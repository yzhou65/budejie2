//
//  YZTextField.m
//  budejie
//
//  Created by Yue on 8/8/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTextField.h"
#import <objc/runtime.h>

static NSString * const YZPlaceholderKeyPath = @"_placeholderLabel";

@implementation YZTextField

/**
 运行时（Runtime）：
 苹果官方一套C语言库
 能做很多底层操作（比如访问隐藏的一些成员变量／成员方法。。。）
 */

+ (void)initialize
{
    
}

+ (void)getProperties
{
    unsigned int count = 0;
    
    //拷贝出所有的成员变量列表
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        //打印成员变量名字
        YZLog(@"%s <---> %s", property_getName(property), property_getAttributes(property));
    }
    
    //释放
    free(properties);
}


+ (void)getIvars
{
    unsigned int count = 0;

    //拷贝出所有的成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);

    for (int i = 0; i < count; i++) {
        Ivar ivar = *(ivars + i);

        //打印成员变量名字
        YZLog(@"%s  %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    
    //释放
    free(ivars);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    UILabel *placeholder = [self valueForKey:@"_placeholder"];
//    placeholder.textColor = [UIColor redColor];
    
    //设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    //不成为第一响应者
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    //修改占位文字颜色
    UILabel *placeholderLabel = [self valueForKey:YZPlaceholderKeyPath];
    placeholderLabel.textColor = self.textColor;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    UILabel *placeholderLabel = [self valueForKey:YZPlaceholderKeyPath];
    placeholderLabel.textColor = [UIColor grayColor];
    
//    [self setValue:[UIColor grayColor] forKey:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    UILabel *placeholderLabel = [self valueForKey:YZPlaceholderKeyPath];
    placeholderLabel.textColor = placeholderColor;
}


/**
 绘制placeholder
 */
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25) withAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : self.font}];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
