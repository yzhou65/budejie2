//
//  YZRecommendCategoryCell.m
//  百思不得姐
//
//  Created by Yue on 8/6/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZRecommendCategoryCell.h"
#import "YZRecommendCategory.h"

@interface YZRecommendCategoryCell ()

/** 选中时显示的指示器  */
@property (weak, nonatomic) IBOutlet UIView *selectIndicator;

@end

@implementation YZRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.backgroundColor = YZRGBColor(244, 244, 244);
    self.selectIndicator.backgroundColor = YZRGBColor(219, 21, 26);
    
    //当cell的selection为None时，即使cell被选中，内部子控件也不会进入高亮状态
//    self.textLabel.textColor = YZRGBColor(78, 78, 78);
//    self.textLabel.highlightedTextColor = YZRGBColor(219, 21, 26);
//
//    UIView *bg = [[UIView alloc] init];
//    self.selectedBackgroundView = bg;
    
}

- (void)setCategory:(YZRecommendCategory *)category
{
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //重新调整内部textLabel的frame，否则字会挡住自制分割线（其实就是一个height＝1的UIView）
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

/**
 当一个cell被选中的时候会调用。
 重写此方法可以监听cell的选中和取消选中
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.selectIndicator.hidden = !selected;
    
    if (selected) {
        self.textLabel.textColor = self.selectIndicator.backgroundColor;
    } else {
        self.textLabel.textColor = YZRGBColor(78, 78, 78);
    }
    
}

@end
