//
//  YSMTalkMessageCard.h
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMTalkMessageCard : UIImageView

- (void)reloadMessages;//加载消息
- (void)removeMessageReceiveListener;//移除更新消息方法
- (void)setFriendsList:(NSArray *)array;

@end
