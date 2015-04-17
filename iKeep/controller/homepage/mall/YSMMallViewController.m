//
//  YSMMallViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMallViewController.h"
#import "MJRefresh.h"
#import "YSMMainHandler.h"
#import "YSMMallGoodsListTableViewCell.h"

@interface YSMMallViewController () <UITableViewDataSource,UITableViewDelegate>{
    int _page;//记录页码
    NSMutableArray *_booksDataSource;//数据源
}

@end

@implementation YSMMallViewController

//***********************************
//      初始化及UI搭建
//***********************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _booksDataSource = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建UI
    [self creatMallViewUI];
}

- (void)creatMallViewUI
{
    //导航栏说明
    [self setNavigationBarMiddleTitle:@"书店"];
    
    //删除scroll view
    [self.scrollView removeFromSuperview];
    
    //添加tableview
    UITableView *tableView = [[UITableView alloc]
                initWithFrame:CGRectMake(0.0f, 0.0f,
                self.mainShowView.frame.size.width,
                self.mainShowView.frame.size.height)];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView addHeaderWithCallback:^{
        [self tableViewHeaderRefresh];
    }];
    [tableView addFooterWithCallback:^{
        [self tableViewFooterRefresh];
    }];
    [self.mainShowView addSubview:tableView];
    [tableView headerBeginRefreshing];
}

//***********************************
//          tableView上拉下拉刷新
//***********************************
#pragma mark - tableView上拉下拉刷新
- (void)tableViewHeaderRefresh
{
    _page = 1;
    [self requestMallData:_page];
}

- (void)tableViewFooterRefresh
{
    _page++;
    [self requestMallData:_page];
}

- (void)requestMallData:(int)page
{
    //取得控件器
    YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager requestData:RequestMallListData andPage:page andAction:^(YSMMainHandleDataModel *result) {
            //失败
            if (result.error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self alertWrongMessage:nil andMessage:[NSString stringWithFormat:@"请求数据失败 error:%@",result.error]];
                });
                return;
            }
            
            //成功
            //清空原数据
            if (page == 1) {
                [_booksDataSource removeAllObjects];
            }
            //加载新数据
            [_booksDataSource addObjectsFromArray:result.result];
            //更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self reloadDataWithNewData];
            });
        }];
    });
}

//更新UI
- (void)reloadDataWithNewData
{
    UITableView *tableView = [self.mainShowView subviews][0];
    [tableView reloadData];
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}

//***********************************
//          tableView数据源
//***********************************
#pragma mark - tableView数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *normalCellName = @"normalCell";
    YSMMallGoodsListTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    if (nil == myCell) {
        myCell = [[YSMMallGoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName];
    }
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [myCell updateMallListGoodUI:(YSMMallGoodsListDataModel *)_booksDataSource[indexPath.row]];
    
    return myCell;
}

//返回cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_booksDataSource count];
}

//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f;
}

@end
