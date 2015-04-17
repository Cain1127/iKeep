//
//  YSMShareAboutCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMShareAboutCard.h"
#import "YSMMainHandler.h"
#import "YSMHealthyNewsDataModel.h"
#import "YSMNewsDetailViewController.h"

#import <objc/runtime.h>

//关联key
static char ImageViewKey;
static char TitleLabelKey;
static char DesLabelKey;
@interface YSMShareAboutCard (){
    NSString *_newsID;//记录头条新闻ID
}

@end

@implementation YSMShareAboutCard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //用户交互
        self.userInteractionEnabled = YES;
        self.alpha = 0.6;
        
        //背景图片
        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_SHAREABOUT_CARD_DEFAULT_BG];
        
        //创建UI
        [self createShareAboutCardUI];
        
        //添加点击事件
        [self getTapGesture];
        
        //请求数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestHeaderData];
        });
    }
    
    return self;
}

//创建UI
- (void)createShareAboutCardUI
{
    //165.0f 96.7 160
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 165.0f, 96.7f)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageView];
    objc_setAssociatedObject(self, &ImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 96.7f, 165.0f, 33.3f)];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:titleLabel];
    
    //说明
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 130.0f, 165.0f, 30.0f)];
    desLabel.font = [UIFont systemFontOfSize:12.0f];
    desLabel.backgroundColor = [UIColor whiteColor];
    desLabel.textColor = [UIColor lightGrayColor];
    desLabel.numberOfLines = 2;
    objc_setAssociatedObject(self, &DesLabelKey, desLabel, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:desLabel];
}

//添加单击手势
- (void)getTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getTapGestureAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

//单击事件
- (void)getTapGestureAction
{
    if (_newsID) {
        YSMNewsDetailViewController *src = [[YSMNewsDetailViewController alloc] init];
        [src updateNewsDetailWithID:_newsID];
        if (self.tapActionCallBack) {
            self.tapActionCallBack(src);
        }
    }
}

//请求头信息
- (void)requestHeaderData
{
    //异步请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
        [manager requestData:RequestHealthyNewsTextNewsListData andPage:1 andAction:^(YSMMainHandleDataModel *result) {
            //请求数据失败
            if (result.error) {
                //则直接读取本地缓存文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_MAIN_HOME_HEADER,ARCHIVE_PATH_MAIN_HOME_HEADER_FILENAME]]) {
                    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_MAIN_HOME_HEADER,ARCHIVE_PATH_MAIN_HOME_HEADER_FILENAME]];
                    if (data) {
                        YSMHealthyNewsDataModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self updateMainHomeHeaderNews:model];
                        });
                    }
                } else {
                    NSLog(@"无法加载本地缓存数据");
                }
                return;
            }
            
            //请求成功：刷新UI
            YSMHealthyNewsDataModel *model = result.result[0];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateMainHomeHeaderNews:model];
            });
            
            //数据本地化
            [self locationHeaderData:model];
        }];
    });
}

//根据数据模型更新UI
- (void)updateMainHomeHeaderNews:(YSMHealthyNewsDataModel *)model
{
    UIImageView *imageView = objc_getAssociatedObject(self, &ImageViewKey);
    imageView.image = model.headerImage;
    
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    titleLabel.text = model.title;
    
    UILabel *desLabel = objc_getAssociatedObject(self, &DesLabelKey);
    desLabel.text = model.detail;
    
    _newsID = [NSString stringWithFormat:@"%@", model.newsID];
}

//归档头条消息
- (void)locationHeaderData:(YSMHealthyNewsDataModel *)model
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    //判断路径
    if ([[NSFileManager defaultManager] fileExistsAtPath:ARCHIVE_PATH_MAIN_HOME_HEADER]) {
        //直接写入文件
        [data writeToFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_MAIN_HOME_HEADER,ARCHIVE_PATH_MAIN_HOME_HEADER_FILENAME] atomically:YES];
    } else {
        //创建文件
        BOOL createFile = [[NSFileManager defaultManager] createDirectoryAtPath:ARCHIVE_PATH_MAIN_HOME_HEADER withIntermediateDirectories:YES attributes:nil error:nil];
        if (createFile) {
            [data writeToFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_MAIN_HOME_HEADER,ARCHIVE_PATH_MAIN_HOME_HEADER_FILENAME] atomically:YES];
        } else {
            NSLog(@"主页头条新闻文件创建失败");
        }
    }
}

@end
