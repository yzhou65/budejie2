//
//  YZAddTagViewController.m
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZAddTagViewController.h"
#import "YZTagButton.h"
#import "YZTagTextField.h"
#import "SVProgressHUD.h"

@interface YZAddTagViewController () <UITextFieldDelegate>
/** 内容 */
@property(nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property(nonatomic, weak) YZTagTextField *textField;
/** 添加按钮 */
@property(nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property(nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation YZAddTagViewController

#pragma mark - 懒加载
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        YZTagButton *addButton = [YZTagButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        addButton.backgroundColor = YZTagBg;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        addButton.contentMode = UIViewContentModeLeft; //contentMode一般只用于image，文字不合用
        
        //让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, YZTagMargin, 0, YZTagMargin);
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
    
    [self setupTags];
}

- (void)setupTags
{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self addButtonClick];
    }
}

/**
 制作一个contentView来容纳textField
 */
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = YZTagMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + YZTagMargin;
    contentView.height = YZScreenH;
    
//    contentView.backgroundColor = [UIColor redColor]; //For debugging
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextField
{
    __weak typeof(self) weakSelf = self;
    YZTagTextField *textField = [[YZTagTextField alloc] init];
    textField.width = self.contentView.width;
    
    textField.deleteBlock = ^{
        if(weakSelf.textField.hasText) return;
        
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
    
    textField.delegate = self;
    
    
    //textField的监听不宜使用代理，因为漏洞多且中文适配差。textField继承自UIControll，所以可以直接使用addTarget
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)done
{
    //传递数据给上一个控制器
//    NSMutableArray *tags = [NSMutableArray array];
//    for (YZTagButton *tagButton in self.tagButtons) {
//        [tags addObject:tagButton.currentTitle];
//    }
    
    //也可以用kvc
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    
    //传递tags给这个block
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听文字改变
/**
 监听文字改变
 */
- (void)textDidChange
{
    //更新标签和文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) { //有文字
        
        //显示添加标签的按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + YZTagMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签:%@", self.textField.text] forState:UIControlStateNormal];
        
        //获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","] || [lastLetter isEqualToString:@"，"]) {
            //去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            [self addButtonClick];
        }
        
    } else { //没有文字了
        //隐藏添加标签的按钮
        self.addButton.hidden = YES;
    }
}

#pragma mark - 监听按钮点击
/**
 "添加标签"
 */
- (void)addButtonClick
{
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    //添加一个“标签按钮”
    YZTagButton *tagButton = [YZTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    //清空textField文字
    self.textField.text = nil;
    self.textField.hidden = YES;
    
    //更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
    
}

/**
 标签按钮的点击监听
 */
- (void)tagButtonClick:(YZTagButton *)tagButton
{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    //重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{;
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 子控件的frame处理
/**
 更新tag标签按钮的frame
 */
- (void)updateTagButtonFrame
{
    for (int i = 0; i < self.tagButtons.count; i++) {
        YZTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { //最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else { //其他标签按钮
            YZTagButton *lastTagButton = self.tagButtons[i - 1];
            
            //计算当前行剩余的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + YZTagMargin;
            CGFloat rightWidth = self.contentView.width - leftWidth;
            
            if (rightWidth >= tagButton.width) { //按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { //按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + YZTagMargin;
            }
        }
    }
    
}

- (void)updateTextFieldFrame
{
    //最后一个标签按钮
    YZTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + YZTagMargin;
    
    //更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = CGRectGetMaxX(lastTagButton.frame) + YZTagMargin;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + YZTagMargin;
    }
}

/**
 textField的文字宽度
 */
- (CGFloat)textFieldWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
/**
 监听键盘最右下角按钮的点击（return key，比如“换行”“下一步”）
 */
- (BOOL)textFieldShouldReturn:(YZTagTextField *)textField
{
    if (textField.hash) {
        [self addButtonClick];
    }
    return YES;
}
@end
