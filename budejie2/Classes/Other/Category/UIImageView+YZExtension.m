//
//  UIImageView+YZExtension.m
//  budejie2
//
//  Created by Yue on 8/14/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "UIImageView+YZExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (YZExtension)
/**
 将头像改为圆形
 */
- (void)setProfileImage:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
