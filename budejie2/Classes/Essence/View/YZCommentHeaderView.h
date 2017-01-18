//
//  YZCommentHeaderView.h
//  budejie2
//
//  Created by Yue on 8/13/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZCommentHeaderView : UITableViewHeaderFooterView
/** 文字数据 */
@property(nonatomic, copy) NSString *title;

/** 封装了tableView的dequeue方法，创建一个YZCommentHeaderView对象 */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
