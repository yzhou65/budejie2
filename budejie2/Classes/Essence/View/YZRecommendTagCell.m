//
//  YZRecommendTagCell.m
//  budejie
//
//  Created by Yue on 8/7/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZRecommendTagCell.h"
#import "YZRecommendTag.h"
#import "UIImageView+WebCache.h"

@interface YZRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation YZRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommendTag:(YZRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    
    [self.imageListImageView setProfileImage:recommendTag.image_list];
    
    self.themeNameLabel.text = recommendTag.theme_name;
    
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommendTag.sub_number];
    }
    else {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number/10000.0];
    }
    self.subNumberLabel.text = subNumber;
}

/**
 重新设置cell的尺寸. 外面无论怎么设置cell的frame也会被这个方法覆盖。
 这样就可以达到左边出现空隙，cell和cell之间也有分隔线的效果
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1; //每个cell高度减去1，就多出一个分隔线效果
    
    [super setFrame:frame];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
