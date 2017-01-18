//
//  YZTagTextField.m
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTagTextField.h"

@implementation YZTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        
        //设置了占位文字内容以后，才能设置占位位子的颜色，因为懒加载
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = YZTagH;
    }
    return self;
}

/**
 重写此方法也能监听键盘的输入，比如输入“换行”
 */
//- (void)insertText:(NSString *)text
//{
//    [super insertText:text];
//    
//    YZLog(@"%d", [text isEqualToString:@"\n"]);
//}

/**
 监听删除按钮
 */
- (void)deleteBackward
{
    !self.deleteBlock ? : self.deleteBlock();
    [super deleteBackward];
    
}
@end
