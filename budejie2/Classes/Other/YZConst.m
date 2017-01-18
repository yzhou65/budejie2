#import <UIKit/UIKit.h>

/** 网路请求的url */
NSString * const budejie_url = @"http://api.budejie.com/api/api_open.php";

/** 精华－顶部标题的高度 */
CGFloat const YZTitlesViewH = 35;

/** 精华－顶部标题的Y */
CGFloat const YZTitlesViewY = 64;

/** 精华－cell间距 */
CGFloat const YZTopicCellMargin = 10;

/** 标签－间距 */
CGFloat const YZTagMargin = 5;

/** 精华－cell文字内容的Y值 */
CGFloat const YZTopicCellTextY = 55;

/** 精华－底部工具条的高度 */
CGFloat const YZTopicCellBottomBarH = 35;

/** 精华－cell－图片帖子的最大高度 */
CGFloat const YZTopicCellPictureMaxH = 1000;

/** 精华－cell－图片帖子一旦超过最大高度1000，就设置为此高度 */
CGFloat const YZTopicCellPictureLimitH = 250;

/** YZUser模型－性别属性值 */
NSString * const YZUserSexMale = @"m";
NSString * const YZUserSexFemale = @"f";

/** 精华－cell－“最热评论”4个字的高度 */
CGFloat const YZTopicCellTopCmtTitleH = 20;

/** tabBar被选中的通知的名字 */
NSString * const YZTabBarDidSelectNotification = @"YZTabBarDidSelectNotification";

/** tabBar被选中的通知 － 被选中的控制器的index key */
NSString * const YZSelectedControllerIndexKey = @"YZSelectedControllerIndexKey";

/** tabBar被选中的通知 － 被选中的控制器key */
NSString * const YZSelectedControllerKey = @"YZSelectedControllerKey";

/** 标签－高度 */
CGFloat const YZTagH = 25.0;