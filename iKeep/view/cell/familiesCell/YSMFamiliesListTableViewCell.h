//
//  YSMFamiliesListTableViewCell.h
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMXMPPFriendsInfoModel;
@interface YSMFamiliesListTableViewCell : UITableViewCell

//按给定的data model刷新UI
- (void)updateFamiliesCellUIWithDataModel:(YSMXMPPFriendsInfoModel *)model;

@end
