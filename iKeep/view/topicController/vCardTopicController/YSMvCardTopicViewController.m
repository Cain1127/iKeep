//
//  YSMvCardTopicViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMvCardTopicViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMXMPPManager.h"
#import "YSMvCardDataModel.h"

@interface YSMvCardTopicViewController ()

@property (nonatomic,copy) BLOCK_vCARDMODEL_ACTION updateIcon;//更新头像

@end

@implementation YSMvCardTopicViewController

//*************************************
//      view加载及创建子视图
//*************************************
#pragma mark - view加载及创建子视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏的两个按钮
    [self createvCardTopicViewUI];
    
    //获取vCard
    [self getvCardInfo];
}

- (void)createvCardTopicViewUI
{
    //button style
    YSMButtonStyleDataModel *buttonStyleIcon = [[YSMButtonStyleDataModel alloc] init];
    buttonStyleIcon.aboveImage = IMAGE_MAIN_NAVIGATION_ICON_DEFAULT_ABOVE;
    buttonStyleIcon.imagesNormal = IMAGE_MAIN_NAVIGATION_DEFAULT_PERSON_ICON;
    
    //person icon button
    UIButton *iconButton = [UIButton createYSMBlockActionButton:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f) andTitle:nil andStyle:buttonStyleIcon andCallBalk:^(UIButton *button) {
        if (self.iconButtonAction) {
            self.iconButtonAction();
        }
    }];
    [self setNavigationBarRightView:iconButton];
    
    //更新头像block
    self.updateIcon = ^(YSMvCardDataModel *model){
        if (model.icon) {
            [iconButton setImage:model.icon forState:UIControlStateNormal];
        }
    };
    
    YSMButtonStyleDataModel *buttonStyleMore = [[YSMButtonStyleDataModel alloc] init];
    buttonStyleMore.imagesNormal = IMAGE_MAIN_NAVIGATION_MORE_BUTTON_NORMAL;
    buttonStyleMore.imagesHighted = IMAGE_MAIN_NAVIGATION_MORE_BUTTON_HILIGHTED;
    //more function button
    UIButton *moreButton = [UIButton createYSMBlockActionButton:CGRectMake(0.0f, 00.f, 30.0f, 30.0f) andTitle:nil andStyle:buttonStyleMore andCallBalk:^(UIButton *button) {
        if (self.moreButtonAction) {
            self.moreButtonAction();
        }
    }];
    [self setNavigationBarLeftView:moreButton];
}

//**************************************
//      获取vCard信息
//**************************************
- (void)getvCardInfo
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
        [manager getSelfvCardMessage:^(YSMvCardDataModel *model) {
            //更新头像
            if (self.updateIcon) {
                self.updateIcon(model);
            }
            //通知已完成更新
            if (self.notificavCardLoadSucces) {
                self.notificavCardLoadSucces(model);
            }
            
            //登录信息本地化
            NSData *vCardData = [NSKeyedArchiver archivedDataWithRootObject:model];
            BOOL fileIsEist = [[NSFileManager defaultManager] fileExistsAtPath:ARCHIVE_PATH_SELFvCARD];
            if (fileIsEist) {
                
                BOOL writeFlag = [vCardData writeToFile:[NSString stringWithFormat:@"%@/%@", ARCHIVE_PATH_SELFvCARD,ARCHIVE_PATH_SELFvCARD_FILENAME] atomically:YES];
                if (writeFlag) {
                    NSLog(@"vCard个人信息本地化成功");
                }
            } else {
                //如若文件不存在，则创建文件夹
                BOOL createFile = [[NSFileManager defaultManager] createDirectoryAtPath:ARCHIVE_PATH_SELFvCARD withIntermediateDirectories:YES attributes:nil error:nil];
                if (createFile) {
                    BOOL writeFlag = [vCardData writeToFile:[NSString stringWithFormat:@"%@/%@", ARCHIVE_PATH_SELFvCARD,ARCHIVE_PATH_SELFvCARD_FILENAME] atomically:YES];
                    if (writeFlag) {
                        NSLog(@"vCard个人信息本地化成功");
                    }
                }
            }
        }];
    });
}

#pragma mark - 重载vCard
- (void)reloadvCard
{
    [self getvCardInfo];
}

@end
