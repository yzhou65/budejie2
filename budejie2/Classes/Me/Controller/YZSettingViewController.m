//
//  YZSettingViewController.m
//  budejie2
//
//  Created by Yue on 8/16/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZSettingViewController.h"
#import "SDImageCache.h"

@implementation YZSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = YZGlobalBg;
}

/**
 遍历文件，计算文件总大小. 示例2
 */
- (void)getSize2
{
    //图片缓存
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    //获得文件夹内部的所有内容
    [manager contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray * subpaths = [manager subpathsAtPath:cachePath];
}

/**
 遍历文件，计算文件总大小. 示例1
 */
- (void)getSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        
        //判断文件是否是文件夹
        //        BOOL dir = NO;
        //        [manager fileExistsAtPath:filePath isDirectory:&dir];
        //        if (dir) continue;
        
        //判断是否是文件夹
        NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) {
            continue;
        }
        
        totalSize += [attrs[NSFileSize] integerValue];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000.0; // mac的文件按1000来计算k M G
    
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(已使用%.2fMB)", size];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SDImageCache sharedImageCache] clearDisk];
}
@end
