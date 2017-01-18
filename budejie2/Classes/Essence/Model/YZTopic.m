//
//  YZTopic.m
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//  帖子模型

#import "YZTopic.h"
#import "YZComment.h"
#import "YZUser.h"
#import "MJExtension.h"

@implementation YZTopic
{
    CGFloat _cellHeight; //因为header文件中声明其cellHeight为readonly，所以系统不再自动生成_cellHeight变量，所以为了方便下面的代码，要自定义一个_cellHeight成员变量。写在@implementation中或类扩展中都可以，必须用大括号括起。@implementation中不能写@property属性
//    CGRect _pictureFrame;
}

/**
 模型属性：服务器返回的key
 */
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]",  //top_cmt这个模型属性对应服务器返回的top_cmt数组的第0个元素
             @"ctime" : @"top_cmt[0].user.qzone_uid" //ctime模型属性映射为top_cmt第0个元素的ctime属性
             };
}

- (NSString *)create_time
{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss"; //指定解析日期格式
    
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { //今年
        if (create.isToday) {
            NSDateComponents *cmps =[[NSDate date] timeElapsedFrom:create];
            
            if (cmps.hour >= 1) { //时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { //昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else {
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { //非今年
        return _create_time;
    }
}

/**
 cellHeight的计算应该只做一次
 */
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * YZTopicCellMargin, MAXFLOAT);
        
        //计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //cell的高度
        _cellHeight = YZTopicCellTextY + textH + YZTopicCellMargin;
        
        //根据帖子的类型计算cell的高度
        if (self.type == YZTopicTypePicture) { //图片帖子
            if (self.width != 0 && self.height != 0) {
                CGFloat pictureW = maxSize.width;
                CGFloat pictureH = pictureW * self.height / self.width;
                
                if (pictureH >= YZTopicCellPictureMaxH) {
                    pictureH = YZTopicCellPictureLimitH;
                    self.bigPicture = YES; //大图
                }
                
                //计算图片控件的frame
                CGFloat pictureX = YZTopicCellMargin;
                CGFloat pictureY = YZTopicCellTextY + textH + YZTopicCellMargin;
                _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
                _cellHeight += pictureH + YZTopicCellMargin;
            }
        }
        else if (self.type == YZTopicTypeVoice) { //声音帖子
            CGFloat voiceX = YZTopicCellMargin;
            CGFloat voiceY = YZTopicCellTextY + textH + YZTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + YZTopicCellMargin;
        }
        else if (self.type == YZTopicTypeVideo) { //声音帖子
            CGFloat videoX = YZTopicCellMargin;
            CGFloat videoY = YZTopicCellTextY + textH + YZTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + YZTopicCellMargin;
        }
        
        //如果有最热评论，还要将最热评论的高度计入，否则最热评论会挡住帖子内容
        YZComment *cmt = self.top_cmt;
        if (cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += YZTopicCellTopCmtTitleH + contentH + YZTopicCellMargin;
        }
    
        //cellHeight要加上底部工具条的高度
        _cellHeight += YZTopicCellBottomBarH + YZTopicCellMargin;
    }
    
    return _cellHeight;
}

//
@end
