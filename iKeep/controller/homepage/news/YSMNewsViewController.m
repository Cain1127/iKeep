//
//  YSMNewsViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMNewsViewController.h"
#import "YSMHealthyNewsMiddleItem.h"
#import "MJRefresh.h"
#import "YSMHealthyNewsTableViewCell.h"
#import "YSMMainHandler.h"
#import "YSMNewsDetailViewController.h"

#import <MediaPlayer/MediaPlayer.h>

//新联类型的动画frame
#define NEWSTYPE_FRAME_SHOW CGRectMake(0.0f,0.0f,320.0f,DEVICE_HEIGHT - 64.0f)
#define NEWSTYPE_FRAME_LEFTHIDDEN CGRectMake(-320.0f,0.0f,320.0f,DEVICE_HEIGHT - 64.0f)
#define NEWSTYPE_FRAME_RIGHTHIDDEN CGRectMake(320.0f,0.0f,320.0f,DEVICE_HEIGHT - 64.0f)

@interface YSMNewsViewController () <UITableViewDataSource,UITableViewDelegate>{
    int _page;//记录当前页数
}

@property (nonatomic,strong) NSMutableArray *newsDataSource;//新闻数据源
@property (nonatomic,strong) YSMHealthyNewsMiddleItem *middleNavBar;
@property (nonatomic,strong) UIView *textNewsView;//普通文字新闻
@property (nonatomic,strong) UIView *mediaNewsView;//视屏新闻
@property (nonatomic,copy) BLOCK_VOID_ACTION removePlayer;

@end

@implementation YSMNewsViewController

//************************************
//      初始化及UI搭建
//************************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //初始化数据源
        self.newsDataSource = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化页数
    _page = 0;
    
    //创建UI
    [self createHealthyNewsUI];
}

- (void)createHealthyNewsUI
{
    //创建资讯及视屏视图
    [self.scrollView removeFromSuperview];
    self.textNewsView = [[UIView alloc] initWithFrame:NEWSTYPE_FRAME_SHOW];
    [self.mainShowView addSubview:self.textNewsView];
    
    //添加tableview
    UITableView *textTableView = [[UITableView alloc] initWithFrame:NEWSTYPE_FRAME_SHOW];
    [self.textNewsView addSubview:textTableView];
    textTableView.showsHorizontalScrollIndicator = NO;
    textTableView.showsVerticalScrollIndicator = NO;
//    textTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    textTableView.dataSource = self;
    textTableView.delegate = self;
    [textTableView addHeaderWithCallback:^{
        [self tableViewHeaderRefresh:TextHealthyNews];
    }];
    [textTableView addFooterWithCallback:^{
        [self tableViewFooterRefresh:TextHealthyNews];
    }];
    [textTableView headerBeginRefreshing];
    textTableView.tag = NEWSVIEW_TAG_TEXTNEWS_TAG;
    
    //视屏列表
    self.mediaNewsView = [[UIView alloc] initWithFrame:NEWSTYPE_FRAME_RIGHTHIDDEN];
    [self.mainShowView addSubview:self.mediaNewsView];
    
    UITableView *mediaTableView = [[UITableView alloc] initWithFrame:NEWSTYPE_FRAME_SHOW];
    [self.mediaNewsView addSubview:mediaTableView];
    mediaTableView.showsHorizontalScrollIndicator = NO;
    mediaTableView.showsVerticalScrollIndicator = NO;
//    mediaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mediaTableView.dataSource = self;
    mediaTableView.delegate = self;
    [mediaTableView addHeaderWithCallback:^{
        [self tableViewHeaderRefresh:MediaHealthyNews];
    }];
    [mediaTableView addFooterWithCallback:^{
        [self tableViewFooterRefresh:MediaHealthyNews];
    }];
    mediaTableView.tag = NEWSVIEW_TAG_MEDIANEWS_TAG;
    
    //导航栏中间主题view
    self.middleNavBar = [[YSMHealthyNewsMiddleItem alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andCallBack:^(HEALTHY_NEWS_TYPE newsType) {
        [self showNewsWithType:newsType];
    }];
    [self setNavigationBarMiddleView:self.middleNavBar];
}

//************************************
//      两个类开新闻视图切换
//************************************
#pragma mark - 两个类型新闻视图切换
- (void)showNewsWithType:(HEALTHY_NEWS_TYPE)newsType
{
    if (newsType == MediaHealthyNews) {
        //视图切换
        [UIView animateWithDuration:0.3 animations:^{
            self.mediaNewsView.frame = NEWSTYPE_FRAME_SHOW;
            self.textNewsView.frame = NEWSTYPE_FRAME_LEFTHIDDEN;
        }];
        //加载数据
        UITableView *tableView = [self.mediaNewsView subviews][0];
        [tableView headerBeginRefreshing];
        return;
    }
    
    if (newsType == TextHealthyNews) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mediaNewsView.frame = NEWSTYPE_FRAME_RIGHTHIDDEN;
            self.textNewsView.frame = NEWSTYPE_FRAME_SHOW;
        }];
        //加载数据
        UITableView *tableView = [self.textNewsView subviews][0];
        [tableView headerBeginRefreshing];
        return;
    }
}

//************************************
//      UITableView头脚刷新
//************************************
#pragma mark - UITableView头脚刷新
//表头刷新
- (void)tableViewHeaderRefresh:(HEALTHY_NEWS_TYPE)newsType
{
    _page = 1;
    [self requestDataWithType:newsType andPage:_page];
}

//页脚刷新
- (void)tableViewFooterRefresh:(HEALTHY_NEWS_TYPE)newsType
{
    _page++;
    [self requestDataWithType:newsType andPage:_page];
}

//按给定的页数，进行请求:HANDLE_ACTION_TYPE
- (void)requestDataWithType:(HEALTHY_NEWS_TYPE)newsType andPage:(int)page
{
    //开始异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (newsType) {
            case TextHealthyNews:
            {
                YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
                [manager requestData:RequestHealthyNewsTextNewsListData andPage:page andAction:^(YSMMainHandleDataModel *result) {
                    //请求失败
                    if (result.error) {
                        //返回主线程
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self alertWrongMessage:nil andMessage:@"加载数据失败"];
                            [self reloadTableViewData:newsType];
                        });
                        return;
                    }
                    
                    //请求成功
                    //清空数据源
                    if (page <= 1) {
                        [_newsDataSource removeAllObjects];
                    }
                    [_newsDataSource addObjectsFromArray:result.result];
                    //返回主线程刷新UI
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self reloadTableViewData:newsType];
                    });
                }];
            }
                break;
                
            case MediaHealthyNews:
            {
                YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
                [manager requestData:RequestHealthyNewsMediaNewsListData andPage:page andAction:^(YSMMainHandleDataModel *result) {
                    //请求失败
                    if (result.error) {
                        //返回主线程
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self alertWrongMessage:nil andMessage:@"加载数据失败"];
                            [self reloadTableViewData:newsType];
                        });
                        return;
                    }
                    
                    //请求成功
                    //清空数据源
                    if (page <= 1) {
                        [_newsDataSource removeAllObjects];
                    }
                    [_newsDataSource addObjectsFromArray:result.result];
                    //返回主线程刷新UI
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self reloadTableViewData:newsType];
                    });
                }];
            }
                break;
                
            default:
                break;
        }
    });
}

//tableView刷新数据
- (void)reloadTableViewData:(HEALTHY_NEWS_TYPE)newType
{
    UITableView *tableView = [self.textNewsView subviews][0];
    if (newType == MediaHealthyNews) {
        tableView = [self.mediaNewsView subviews][0];
    }
    
    [tableView reloadData];
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}

//************************************
//      UITableView的代理方法
//************************************
#pragma mark - UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据不同的信息类型，返回不同的cell
    YSMHealthyNewsDataModel *model = _newsDataSource[indexPath.row];
    switch (model.modelType) {
        case MediaHealthyNews:
        {
            static NSString *mediaCellName = @"mediaCell";
            YSMHealthyNewsTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:mediaCellName];
            if (nil == myCell) {
                myCell = [[YSMHealthyNewsTableViewCell alloc] initWithNewsType:MediaHealthyNews reuseIdentifier:mediaCellName];
            }
            
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [myCell updateHealthyNewsCellWithModel:model];
            
            return myCell;
        }
        
        //普通新闻列表cell更新
        case TextHealthyNews:
        {
            static NSString *textNormalCellName = @"textNormalCell";
            YSMHealthyNewsTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:textNormalCellName];
            if (nil == myCell) {
                myCell = [[YSMHealthyNewsTableViewCell alloc] initWithNewsType:TextHealthyNews reuseIdentifier:textNormalCellName];
            }
            
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [myCell updateHealthyNewsCellWithModel:model];
            
            return myCell;
        }
            
        case TextHealthyHeaderNews:
        {
            static NSString *textHeaderCellName = @"textHeaderCell";
            YSMHealthyNewsTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:textHeaderCellName];
            if (nil == myCell) {
                myCell = [[YSMHealthyNewsTableViewCell alloc] initWithNewsType:TextHealthyHeaderNews reuseIdentifier:textHeaderCellName];
            }
            
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [myCell updateHealthyNewsCellWithModel:model];
            
            return myCell;
        }
            
        case ImageHealthyNews:
        {
            static NSString *imageCellName = @"imageCell";
            YSMHealthyNewsTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:imageCellName];
            if (nil == myCell) {
                myCell = [[YSMHealthyNewsTableViewCell alloc] initWithNewsType:ImageHealthyNews reuseIdentifier:imageCellName];
            }
            
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [myCell updateHealthyNewsCellWithModel:model];
            
            return myCell;
        }
            
        case MediaHealthyNewsHeader:
        {
            static NSString *mediaHeaderCellName = @"mediaHeaderCellName";
            YSMHealthyNewsTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:mediaHeaderCellName];
            if (nil == myCell) {
                myCell = [[YSMHealthyNewsTableViewCell alloc] initWithNewsType:MediaHealthyNewsHeader reuseIdentifier:mediaHeaderCellName];
            }
            
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [myCell updateHealthyNewsCellWithModel:model];
            
            return myCell;
        }
    }
    
    static NSString *normalCellName = @"normalCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    if (nil == myCell) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据不同的信息类型，返回不同的高度
    YSMHealthyNewsDataModel *model = _newsDataSource[indexPath.row];
    switch (model.modelType) {
        case MediaHealthyNews:
            return 224.0f;
            break;
            
        case TextHealthyNews:
            return 100.0f;
            break;
            
        case TextHealthyHeaderNews:
            return 222.0f;
            break;
            
        case ImageHealthyNews:
            return 101.0f;
            break;
            
        case MediaHealthyNewsHeader:
            return 127.37f;
            
        default:
            return 44.0f;
            break;
    }
    
    return 44.0f;
}

//***************************************
//      cell每行的点击事件：主要是播放视屏
//***************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //播放视屏页面
    if (tableView.tag == NEWSVIEW_TAG_MEDIANEWS_TAG) {
        //是视屏页面，则进入视屏播放页面
        YSMHealthyNewsDataModel *model = _newsDataSource[indexPath.row];
        MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:model.m3u8RUL];
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [self presentViewController:mpvc animated:YES completion:^{}];
        __weak UIViewController *selfController = self;
        self.removePlayer = ^(){
            if (mpvc.moviePlayer) {
                [mpvc.moviePlayer stop];
            }
            
            //将播放界面移除
            [selfController dismissViewControllerAnimated:YES completion:^{}];
        };
        //视屏播放时，点击关闭的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                selector:@selector(medioPlayerBackAction:)
            name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        return;
    }
    
    //新闻列表页面
    if (tableView.tag == NEWSVIEW_TAG_TEXTNEWS_TAG) {
        YSMNewsDetailViewController *src = [[YSMNewsDetailViewController alloc] init];
        YSMHealthyNewsDataModel *model = _newsDataSource[indexPath.row];
        [src updateNewsDetailWithID:model.newsID];
        [self.navigationController pushViewController:src animated:YES];
    }
}

//移除事件
#pragma mark - 视屏播放器移除
- (void)medioPlayerBackAction:(NSNotification *)sender
{
    //把通知移除，把自己观察者的身份移除
    [[NSNotificationCenter defaultCenter] removeObserver:self
            name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    if (self.removePlayer) {
        self.removePlayer();
    }
}

@end
