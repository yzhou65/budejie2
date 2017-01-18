
//
//  YZCommentCell.m
//  budejie2
//
//  Created by Yue on 8/13/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZCommentCell.h"
#import "YZComment.h"
#import "UIImageView+WebCache.h"
#import "YZUser.h"

@interface YZCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end

@implementation YZCommentCell
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}

- (void)setComment:(YZComment *)comment
{
    _comment = comment;
    
    [self.profileImageView setProfileImage:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:YZUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceuri.length) { //注意如果没有音频，服务器返回的voiceuri是个空串，而不是nil
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceBtn.hidden = YES;
    }
}

@end
