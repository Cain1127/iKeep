//
//  YSMNewsDetailViewController.m
//  iKeep
//
//  Created by ysmeng on 14/11/3.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMNewsDetailViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMMainHandler.h"
#import "YSMNewsDetailDataModel.h"

#import <objc/runtime.h>

//关联key
static char CommentCountKey;
static char NewsDetailKey;
@interface YSMNewsDetailViewController () <UIWebViewDelegate>

@end

@implementation YSMNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建UI
    [self createNewsDetailUI];
}

- (void)createNewsDetailUI
{
    //按钮风格
    YSMButtonStyleDataModel *buttonModel = [[YSMButtonStyleDataModel alloc] init];
    buttonModel.titleNormalColor = [UIColor whiteColor];
    buttonModel.bgColor = [UIColor redColor];
    buttonModel.titleHightedColor = [UIColor darkGrayColor];
    buttonModel.cornerRadio = 15.0f;
    
    //跟帖view
    UIButton *commentButton = [UIButton createYSMBlockActionButton:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f) andTitle:@"跟帖" andStyle:buttonModel andCallBalk:^(UIButton *button) {
        
    }];
    commentButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self setNavigationBarRightView:commentButton];
    objc_setAssociatedObject(self, &CommentCountKey, commentButton, OBJC_ASSOCIATION_ASSIGN);
    
    //新联view
    UIWebView *newsDetailView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mainShowView.frame.size.width, self.mainShowView.frame.size.height)];
    [self.mainShowView addSubview:newsDetailView];
    newsDetailView.backgroundColor = [UIColor whiteColor];
    for (UIView *obj in [newsDetailView subviews]) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
        }
    }
    newsDetailView.delegate = self;
    objc_setAssociatedObject(self, &NewsDetailKey, newsDetailView, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 根据给定的新闻ID刷新UI
- (void)updateNewsDetailWithID:(NSString *)newsID
{
    //异步请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
        [manager requestData:RequestNewsDetailData andID:newsID andAction:^(YSMMainHandleDataModel *result) {
            //请求失败
            if (result.error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self alertWrongMessage:nil andMessage:@"获取新闻详情失败"];
                });
                return;
            }
            
            //请求成功
            YSMNewsDetailDataModel *model = result.result;
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIButton *commentCount = objc_getAssociatedObject(self, &CommentCountKey);
                [commentCount setTitle:model.commentMessage forState:UIControlStateNormal];
                
                UIWebView *detailsView = objc_getAssociatedObject(self, &NewsDetailKey);
                [detailsView loadHTMLString:model.details baseURL:nil];
            });
        }];
    });
}

//*************************************
//      UIWebView上下滚动时不显示背景
//*************************************
#pragma mark - UIWebView上下滚动时不显示背景
- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

@end
