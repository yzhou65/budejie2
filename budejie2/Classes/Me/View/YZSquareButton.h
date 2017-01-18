//
//  YZSquareButton.h
//  budejie2
//
//  Created by Yue on 8/14/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YZSquare;

@interface YZSquareButton : UIButton
/** 方块模型 */
@property(nonatomic, strong) YZSquare *square;
@end
