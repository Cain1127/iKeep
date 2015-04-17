//
//  YSMiKeepLoginRootViewController.m
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMiKeepLoginRootViewController.h"
#import "YSMiKeepLoginGuideViewController.h"
#import "UIImage+YSMImageCategory.h"
#import "YSMBlockActionButton.h"

#import <objc/runtime.h>

//关联key
static char AdvertImageViewKey;
@interface YSMiKeepLoginRootViewController (){
    ADERT_VIEW_TYPE _loadType;//加载的视图类型
}

@end

@implementation YSMiKeepLoginRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadType = AdvertFirstLoadType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建默认广告页
    [self createAdvertDefaultUI];
    
    //添加广告view
    if (_loadType == AdvertOtherLoadType) {
        [self loadAdvertImage];
    } else {
        [self addAvertImageView];
    }
}

//初始加载的view
- (void)createAdvertDefaultUI
{
    __block UIImageView *imageView = [[UIImageView alloc]
                                      initWithFrame:CGRectMake(0.0f, 0.0f,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height)];
    imageView.userInteractionEnabled = YES;
    [self.rootView addSubview:imageView];
    
    //568 - 480 = 68
    CGFloat advertHeight = 480.0f;
    if (IS_PHONE568) {
        imageView.image = [UIImage imageNamed:IMAGE_COPYRIGHT_ADVERT_DEFAULT_BG_568];
    } else {
        advertHeight = 412.0f;
        imageView.image = [UIImage imageNamed:IMAGE_COPYRIGHT_ADVERT_DEFAULT_BG];
    }
    
    //广告加载的view
    UIImageView *advertView = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f,
                                                        self.view.frame.size.width, advertHeight)];
    [imageView addSubview:advertView];
    objc_setAssociatedObject(self, &AdvertImageViewKey, advertView, OBJC_ASSOCIATION_ASSIGN);
}

//添加广告图片
- (void)addAvertImageView
{
    UIImageView *advertView = objc_getAssociatedObject(self, &AdvertImageViewKey);
    
#if 1
    //开启异步请求
    __block UIImage *image = nil;
    __block NSTimeInterval advertTime = 0.0f;
    dispatch_queue_t currentqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentqueue, ^{
        
        //同步请求数据
        dispatch_sync(currentqueue, ^{
            YSMMainHandler *shareHandler = [YSMMainHandler shareMainHandler];
            [shareHandler requestData:RequestAvertMessage andAction:^(YSMMainHandleDataModel *result) {
                if (!result.resultFlag) {
                    //请求失败
                    dispatch_sync(dispatch_get_main_queue(), ^{
                    });
                } else {
                    image = result.result;
                    advertTime = result.AdvertTime;
                    
                    //请求完后，刷新image view，同时移除HUD
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (IS_PHONE568) {
                            advertView.image = image;
                            //文件存本地
                            [self saveAdvertImage:image];
                        } else {
                            image = [image getSubImage:CGRectMake(0.0f,
                                                                  (34.0f / 480.0f) * image.size.height,
                                                                  image.size.width,
                                                                  (412.0f / 480.f) * image.size.height)];
                            //文件存本地
                            [self saveAdvertImage:image];
                            
                            advertView.image = image;
                        }
                    });
                }
            }];
        });
        
#if 1
        //无论广告请求成功与否，都跳到主页面中
        dispatch_sync(currentqueue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(advertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YSMiKeepLoginGuideViewController *src = [[YSMiKeepLoginGuideViewController alloc] init];
                [self.navigationController pushViewController:src animated:YES];
            });
        });
#endif
    });
#endif
}

//将广告页图片保存到本地
- (void)saveAdvertImage:(UIImage *)image
{
    //保存到本地
    NSData *advertImageData = [NSKeyedArchiver archivedDataWithRootObject:image];
    //判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:ARCHIVE_PATH_ADVERT_IMAGE]) {
        //如果存在，直接写入
        [advertImageData writeToFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_ADVERT_IMAGE,ARCHIVE_PATH_ADVERT_IMAGE_FILENAME] atomically:YES];
    } else {
        //不存在，则创建
        BOOL createFilePath = [[NSFileManager defaultManager] createDirectoryAtPath:ARCHIVE_PATH_ADVERT_IMAGE withIntermediateDirectories:YES attributes:nil error:nil];
        if (createFilePath) {
            [advertImageData writeToFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_ADVERT_IMAGE,ARCHIVE_PATH_ADVERT_IMAGE_FILENAME] atomically:YES];
        } else {
            NSLog(@"广告本地缓存文件保存失败");
        }
    }
}

//从主页面返回到广告页面时的UI
- (void)loadAdvertImage
{
    UIImageView *advertView = objc_getAssociatedObject(self, &AdvertImageViewKey);
    UIImage *imageResult = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",ARCHIVE_PATH_ADVERT_IMAGE,ARCHIVE_PATH_ADVERT_IMAGE_FILENAME]]];
    advertView.image = imageResult;
    
    //返回按钮
    UIImageView *rootView = [self.rootView subviews][0];
    //68
    UIButton *turnBack = [UIButton createYSMBlockActionButton:CGRectMake(rootView.frame.size.width - 54.0f, rootView.frame.size.height - 90.0f, 44.0f, 30.0f) andTitle:@"主页>" andStyle:nil andCallBalk:^(UIButton *button) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    [turnBack setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    turnBack.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rootView addSubview:turnBack];
}

//重置加载UI的类型
- (void)setLoadType:(ADERT_VIEW_TYPE)loadType
{
    _loadType = loadType;
}

@end
