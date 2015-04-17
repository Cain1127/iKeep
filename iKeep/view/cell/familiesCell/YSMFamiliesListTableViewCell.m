//
//  YSMFamiliesListTableViewCell.m
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMFamiliesListTableViewCell.h"
#import "YSMXMPPManager.h"
#import "YSMvCardDataModel.h"

#import <objc/runtime.h>

//关闻key
static char NameLabelAssociateKey;
static char IconImageViewKey;
static char TalkAboutKey;
static char LocationAssociateKey;
@implementation YSMFamiliesListTableViewCell

//****************************************
//  初始化及UI创建
//****************************************
#pragma mark - 初始化及UI创建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建好友信息UI
        [self createFamiliesListUI];
    }
    
    return self;
}

- (void)createFamiliesListUI
{
    //底视图
    UIImageView *rootView = [[UIImageView alloc]
                    initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 145.0f)];
    rootView.userInteractionEnabled = YES;
    rootView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:rootView];
    
    //头像
    UIImageView *iconView = [[UIImageView alloc]
                        initWithFrame:CGRectMake(5.0f, 5.0f, 60.0f, 60.0f)];
    [rootView addSubview:iconView];
    iconView.image = [UIImage imageNamed:IMAGE_MAIN_NAVIGATION_DEFAULT_PERSON_ICON];
    objc_setAssociatedObject(self, &IconImageViewKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    //user name label
    UILabel *nameLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(75.0f, 5.0f, 120.0f, 20.0f)];
    nameLabel.text = @"无名";
    nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    nameLabel.textColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    [rootView addSubview:nameLabel];
    objc_setAssociatedObject(self, &NameLabelAssociateKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //talk about
    UILabel *shareAbout = [[UILabel alloc]
                    initWithFrame:CGRectMake(75.0f, 30.0f,
                    rootView.frame.size.width - 80.0f, 90.0f)];
//    shareAbout.text = @"【2014超实用厦门旅游攻略秘籍】一位厦门旅游小编写下的超实用攻略，从穿衣住宿到景点路线推荐、交通讲解、各类小吃、海鲜大排档地址、经典线路安排…你想不到的都为你想到了，想去厦门的同学们转起收藏吧！总有一天用得到的！";
    shareAbout.textColor = [UIColor blackColor];
    shareAbout.font = [UIFont systemFontOfSize:16.0f];
    shareAbout.numberOfLines = 4;
    [rootView addSubview:shareAbout];
    objc_setAssociatedObject(self, &TalkAboutKey, shareAbout, OBJC_ASSOCIATION_ASSIGN);
    
    //location
    UILabel *location = [[UILabel alloc]
                         initWithFrame:CGRectMake(rootView.frame.size.width - 35.0f, 125.0f, 30.0f, 15.0f)];
    location.text = @"广州";
    location.textColor = [UIColor lightGrayColor];
    location.font = [UIFont systemFontOfSize:14.0f];
    [rootView addSubview:location];
    objc_setAssociatedObject(self, &LocationAssociateKey, location, OBJC_ASSOCIATION_ASSIGN);
    
    //分隔线
    self.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
}

//****************************************
//          按数据模型刷新UI
//****************************************
#pragma mark - 按数据模型刷新UI
- (void)updateFamiliesCellUIWithDataModel:(YSMXMPPFriendsInfoModel *)model
{
    //用户名
    UILabel *nameLabel = objc_getAssociatedObject(self, &NameLabelAssociateKey);
    nameLabel.text = model.name;
    
    //请求vCard
    [self requestvCardWithModel:model];
}

//请求个人信息
- (void)requestvCardWithModel:(YSMXMPPFriendsInfoModel *)model
{
    [[YSMXMPPManager shareXMPPManager] getFriendsvCardWithJID:model.jidString andCallBack:^(YSMvCardDataModel *vCardModel) {
        if (nil == vCardModel) {
            NSLog(@"个人信息vCard获取失败");
            return;
        }
        
        //头像
        if (vCardModel.icon) {
            UIImageView *icon = objc_getAssociatedObject(self, &IconImageViewKey);
            icon.image = vCardModel.icon;
        }
        
        //心情
        if (vCardModel.shareAbout) {
            UILabel *talkAbout = objc_getAssociatedObject(self, &TalkAboutKey);
            talkAbout.text = vCardModel.shareAbout;
        }
        
        //location
        if (vCardModel.city) {
            UILabel *location = objc_getAssociatedObject(self, &LocationAssociateKey);
            location.text = vCardModel.city;
        }
    }];
}

@end
