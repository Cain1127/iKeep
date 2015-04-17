//
//  YSMMessagesListTableViewCell.h
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMMessageModel;
@interface YSMMessagesListTableViewCell : UITableViewCell

//根据数据类型的初始化
- (instancetype)initWithMessageStyle:(XM_FROM_TYPE)msgType reuseIdentifier:(NSString *)reuseIdentifier;

//更新UI
- (void)updateMessageCellUI:(YSMMessageModel *)model;

@end
