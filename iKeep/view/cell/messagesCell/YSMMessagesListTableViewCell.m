//
//  YSMMessagesListTableViewCell.m
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMessagesListTableViewCell.h"
#import "YSMMessageModel.h"
#import "YSMvCardDataModel.h"

#import <objc/runtime.h>

//关联key
static char TimeAssociateKey;
static char NameAssociateKey;
static char MessageAssociateKey;
static char IconImageAssociateKey;
@implementation YSMMessagesListTableViewCell

//*****************************************
//      初始化及UI搭建
//*****************************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithMessageStyle:(XM_FROM_TYPE)msgType reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        //根据消息类开创建不同的cell UI
        if (msgType == XMFromSelf) {
            [self createSelfMessageCellUI];
        } else if (msgType == XMFromFamilies) {
            [self createFamiliesMessageCellUI];
        }
    }
    
    return self;
}

//家庭成员的消息类型UI
- (void)createFamiliesMessageCellUI
{
    //IMAGE_TALK_RECEIVE_DEFAULT_BG
    UIImageView *rootView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 100.0f)];
    rootView.userInteractionEnabled = YES;
    [self.contentView addSubview:rootView];
    
    //time
    UILabel *timeLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(0.0f, 10.0f,
                          rootView.frame.size.width, 15.0f)];
    timeLabel.text = @"12:23";
    timeLabel.textColor = DEDEFAULT_FORWARDGROUND_COLOR;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:timeLabel];
    objc_setAssociatedObject(self, &TimeAssociateKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //icon
    UIImageView *iconView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(5.0f, 30.0f, 40.0f, 40.0f)];
    [rootView addSubview:iconView];
    iconView.image = [UIImage imageNamed:IMAGE_MAIN_NAVIGATION_DEFAULT_PERSON_ICON];
    objc_setAssociatedObject(self, &IconImageAssociateKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    // name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0f, 30.0f, 120.0f, 20.0f)];
    nameLabel.text = @"name";
    nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    nameLabel.textColor = [UIColor lightGrayColor];
    [rootView addSubview:nameLabel];
    objc_setAssociatedObject(self, &NameAssociateKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //talk point
    UIImageView *talkView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 55.0f, 20.0f, 20.0f)];
    talkView.image = [UIImage imageNamed:IMAGE_TALK_RECEIVE_DEFAULT_BG];
    [rootView addSubview:talkView];
    
    //message view
    UIView *messageView = [[UIView alloc]
                           initWithFrame:CGRectMake(60.0f, 55.0f,
                           160.0f, 30.0f)];
    [rootView addSubview:messageView];
    messageView.layer.cornerRadius = 10.0f;
    messageView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    
    //message label
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 150.0f, 20.0f)];
    msgLabel.textColor = [UIColor blackColor];
    [messageView addSubview:msgLabel];
    objc_setAssociatedObject(self, &MessageAssociateKey, msgLabel, OBJC_ASSOCIATION_ASSIGN);
}

//自己消息类型UI
- (void)createSelfMessageCellUI
{
    //IMAGE_TALK_SEND_DEFAULT_BG
    UIImageView *rootView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 80.0f)];
    rootView.userInteractionEnabled = YES;
    [self.contentView addSubview:rootView];
    
    //time
    UILabel *timeLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(0.0f, 10.0f,
                          rootView.frame.size.width, 15.0f)];
    timeLabel.text = @"12:23";
    timeLabel.textColor = DEDEFAULT_FORWARDGROUND_COLOR;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:timeLabel];
    objc_setAssociatedObject(self, &TimeAssociateKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //icon
    UIImageView *iconView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(255.0f, 30.0f, 40.0f, 40.0f)];
    [rootView addSubview:iconView];
    iconView.image = [UIImage imageNamed:IMAGE_MAIN_NAVIGATION_DEFAULT_PERSON_ICON];
    objc_setAssociatedObject(self, &IconImageAssociateKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    // name 245 - 120
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 30.0f, 120.0f, 20.0f)];
    nameLabel.text = @"name";
    nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [rootView addSubview:nameLabel];
    objc_setAssociatedObject(self, &NameAssociateKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //talk point
    UIImageView *talkView = [[UIImageView alloc] initWithFrame:CGRectMake(230.0f, 55.0f, 20.0f, 20.0f)];
    talkView.image = [UIImage imageNamed:IMAGE_TALK_SEND_DEFAULT_BG];
    [rootView addSubview:talkView];
    
    //message view 240-160
    UIView *messageView = [[UIView alloc]
                           initWithFrame:CGRectMake(80.0f, 55.0f,
                                                    160.0f, 30.0f)];
    [rootView addSubview:messageView];
    messageView.layer.cornerRadius = 10.0f;
    messageView.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    
    //message label
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 150.0f, 20.0f)];
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.textAlignment = NSTextAlignmentRight;
    [messageView addSubview:msgLabel];
    objc_setAssociatedObject(self, &MessageAssociateKey, msgLabel, OBJC_ASSOCIATION_ASSIGN);
}

//*****************************************
//      根据信息数据模型更新UI
//*****************************************
#pragma mark - 根据信息数据模型更新UI
- (void)updateMessageCellUI:(YSMMessageModel *)model
{
    //更新名字
    UILabel *nameLabel = objc_getAssociatedObject(self, &NameAssociateKey);
    nameLabel.text = model.fromName;
    
    //更新时间
    UILabel *timeLabel = objc_getAssociatedObject(self, &TimeAssociateKey);
    timeLabel.text = [self getTimeWithDate:model.messageTime];
    
    //更新聊天内容
    UILabel *messageLabel = objc_getAssociatedObject(self, &MessageAssociateKey);
    messageLabel.text = model.messageString;
    
    //更新头像
    if (model.vCard.icon) {
        UIImageView *icon = objc_getAssociatedObject(self, &IconImageAssociateKey);
        icon.image = model.vCard.icon;
    }
}

- (NSString *)getTimeWithDate:(NSString *)date
{
    //yyyymmdd hh:mm:ss
    NSString *timeString = [date substringWithRange:NSMakeRange(9, 5)];
    return timeString;
}

@end
