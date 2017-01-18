//
//  YZTopicCell.m
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTopicCell.h"
#import "YZTopic.h"
#import "UIImageView+WebCache.h"
#import "YZTopicPictureView.h"
#import "YZTopicVoiceView.h"
#import "YZTopicVideoView.h"
#import "YZComment.h"
#import "YZUser.h"
#import "YZLoginTool.h"

@interface YZTopicCell () <UIActionSheetDelegate>
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *CaiBtn;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sina_vView;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/** 图片帖子中间的内容 */
@property(nonatomic, weak) YZTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property(nonatomic, weak) YZTopicVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property(nonatomic, weak) YZTopicVideoView *videoView;
/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@end

@implementation YZTopicCell
+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (YZTopicPictureView *)pictureView
{
    if (!_pictureView) {
        YZTopicPictureView *pictureView = [YZTopicPictureView pictureView];
        [self.contentView addSubview:pictureView]; //弱指针，所以要先加入子视图，否则方法结束就销毁
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (YZTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        YZTopicVoiceView *voiceView = [YZTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView]; //弱指针，所以要先加入子视图，否则方法结束就销毁
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (YZTopicVideoView *)videoView
{
    if (!_videoView) {
        YZTopicVideoView *videoView = [YZTopicVideoView videoView];
        [self.contentView addSubview:videoView]; //弱指针，所以要先加入子视图，否则方法结束就销毁
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setTopic:(YZTopic *)topic
{
    _topic = topic;
    
    //新浪加V
    self.sina_vView.hidden = !topic.isSina_v;
    
    //设置头像
    [self.profileImageView setProfileImage:topic.profile_image];
    
    //设置名字
    self.nameLabel.text = topic.name;
    
    //设置帖子的创建时间
    self.createTimeLabel.text = topic.create_time;
    
    //设置按钮文字
    [self setupBtnTitle:self.dingBtn count:topic.ding placeholder:@"顶"];
    [self setupBtnTitle:self.CaiBtn count:topic.cai placeholder:@"踩"];
    [self setupBtnTitle:self.shareBtn count:topic.share placeholder:@"分享"];
    [self setupBtnTitle:self.commentBtn count:topic.comment placeholder:@"评论"];
    
    //设置帖子的文字内容
    self.text_label.text = topic.text;
    
    //根据帖子类型添加对应的内容到cell的中间。在“全部”中，cell的循环利用可能导致图片声音视频和段子显示混乱，所以要显示自己，隐藏其他。
    if (topic.type == YZTopicTypePicture) { //图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == YZTopicTypeVoice) { //声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == YZTopicTypeVideo) { //视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
        
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else { //段子帖子
        //在全部中会循环利用cell，所以显示段子时要隐藏其他元素，然后在显示图片声音视频时再显示回来。
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    //处理最热评论
    YZComment *cmt = topic.top_cmt;
    if (cmt) {
        self.topCmtView.hidden = NO; //循环利用：隐藏过的要重新显现
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@: %@", cmt.user.username, cmt.content];
    } else {
        self.topCmtView.hidden = YES;
    }
}

/**
 处理时间的测试例子。For debugging。
 */
- (void)testDate:(NSString *)create_time
{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss"; //指定解析日期格式
    
    //当前时间
    NSDate *now = [NSDate date];
    //发帖时间
    NSDate *create = [fmt dateFromString:create_time];
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //比较时间. NSCalendar的components：方法能直接计算两个时间的年月日时分秒差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:create toDate:now options:0];
    
    //使用NSCalendar获取年月日
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:now];
//    NSInteger month =[calendar component:NSCalendarUnitMonth fromDate:now];
//    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:now];
//    
//    NSDateComponents *cmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
//    YZLog(@"%zd %zd %zd", cmps.year, cmps.month, cmps.day);
}

/**
 处理顶、踩、分享和评论的个数的格式。
 */
- (void)setupBtnTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    }
    else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
//    frame.size.height -= YZTopicCellMargin; //隐患：如果不停调用setFrame，那么其高度会不断减少
    
    frame.size.height = self.topic.cellHeight - YZTopicCellMargin;
    frame.origin.y += YZTopicCellMargin;
    
    [super setFrame:frame];
}

/**
 弹出收藏举报的ActionSheet
 */
- (IBAction)more:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) return;
    
    if ([YZLoginTool getUid] == nil) return;
    
    //开始执行举报／收藏操作
}
@end
