//
//  YSMHealthyNewsTableViewCell.h
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMHealthyNewsDataModel.h"

@class YSMHealthyNewsDataModel;
@interface YSMHealthyNewsTableViewCell : UITableViewCell

@property (nonatomic,copy) BLOCK_INT_ACTION action;

- (instancetype)initWithNewsType:(HEALTHY_NEWS_TYPE)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateHealthyNewsCellWithModel:(YSMHealthyNewsDataModel *)model;

@end
