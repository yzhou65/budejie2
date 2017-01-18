//
//  YZCommentHeaderView.m
//  budejie2
//
//  Created by Yue on 8/13/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZCommentHeaderView.h"

@interface YZCommentHeaderView ()
/** 文字标签 */
@property(nonatomic, weak) UILabel *label;
@end

@implementation YZCommentHeaderView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    YZCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[YZCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = YZGlobalBg;
        
        //创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = YZRGBColor(67, 67, 67);
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.label.text = title;
}

@end
