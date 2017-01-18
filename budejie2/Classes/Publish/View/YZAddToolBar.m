//
//  YZAddToolBar.m
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZAddToolBar.h"
#import "YZAddTagViewController.h"

@interface YZAddToolBar ()
/** 顶部控件*/
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property(nonatomic, weak) UIButton *addButton;
/** 存放所有的标签label的数组 */
@property(nonatomic, strong) NSMutableArray *tagLabels;
@end

@implementation YZAddToolBar
- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
//    addButton.size = [addButton imageForState:UIControlStateNormal].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = YZTagMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
}

- (void)addButtonClick
{
    YZAddTagViewController *addTagVC = [[YZAddTagViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [addTagVC setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    addTagVC.tags = [self.tagLabels valueForKey:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //如果a modal出b
    //[a presentViewController:b animated:YES completion:nil]
    //a.presentedViewController == b。 b.presentingViewController == a
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:addTagVC animated:YES];
}

- (void)createTagLabels:(NSArray *)tags
{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i < tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = YZTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        
        //要先设置文字和字体，再进行计算
        tagLabel.font = YZTagFont;
        
        tagLabel.width += 2 * YZTagMargin;
        tagLabel.height = YZTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [tagLabel sizeToFit];
        
        [self.topView addSubview:tagLabel];
        
        //设置位置
        if (i == 0) { //最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { //其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            //计算当前行左边和右边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + YZTagMargin;
            CGFloat rightWidth = self.topView.width - leftWidth;
            
            if (rightWidth >= tagLabel.width) { //按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else {
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + YZTagMargin;
            }
        }
    }
    
    //最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + YZTagMargin;
    
    //更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + YZTagMargin;
    }
}
@end
