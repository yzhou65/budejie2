//
//  YZConst.h
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YZTopicTypeAll = 1,
    YZTopicTypePicture = 10,
    YZTopicTypeWord = 29,
    YZTopicTypeVoice = 31,
    YZTopicTypeVideo = 41
} YZTopicType;

/** 百思不得姐的网路请求的url */
UIKIT_EXTERN NSString * const budejie_url;

/** 精华－顶部标题的高度 */
UIKIT_EXTERN CGFloat const YZTitlesViewH;

/** 精华－顶部标题的Y */
UIKIT_EXTERN CGFloat const YZTitlesViewY;

/** 精华－cell间距 */
UIKIT_EXTERN CGFloat const YZTopicCellMargin;


/** 精华－cell文字内容的Y值 */
UIKIT_EXTERN CGFloat const YZTopicCellTextY;

/** 精华－底部工具条的高度 */
UIKIT_EXTERN CGFloat const YZTopicCellBottomBarH;

/** 精华－cell－图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const YZTopicCellPictureMaxH;

/** 精华－cell－图片帖子一旦超过最大高度1000，就设置为此高度 */
UIKIT_EXTERN CGFloat const YZTopicCellPictureLimitH;

/** YZUser模型－性别属性值 */
UIKIT_EXTERN NSString * const YZUserSexMale;
UIKIT_EXTERN NSString * const YZUserSexFemale;

/** 精华－cell－“最热评论”4个字的高度 */
UIKIT_EXTERN CGFloat const YZTopicCellTopCmtTitleH;

/** tabBar被点击的通知 */
UIKIT_EXTERN NSString * const YZTabBarDidSelectNotification;

/** tabBar被选中的通知 － 被选中的控制器的index key */
UIKIT_EXTERN NSString * const YZSelectedControllerIndexKey;

/** tabBar被选中的通知 － 被选中的控制器key */
UIKIT_EXTERN NSString * const YZSelectedControllerKey;

/** 标签－高度 */
UIKIT_EXTERN CGFloat const YZTagH;
/** 标签－间距 */
UIKIT_EXTERN CGFloat const YZTagMargin;