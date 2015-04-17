//
//  YSMMallGoodsListTableViewCell.h
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMMallGoodsListDataModel;
@interface YSMMallGoodsListTableViewCell : UITableViewCell

//根据数据模型刷新数据
- (void)updateMallListGoodUI:(YSMMallGoodsListDataModel *)model;

@end
