//
//  YSMTalkViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTalkViewController.h"
#import "YSMTalkViewMiddleNavigationBar.h"
#import "YSMXMPPManager.h"
#import "MJRefresh.h"
#import "YSMBlockAlertView.h"
#import "YSMTalkMessageCard.h"
#import "YSMFamiliesListTableViewCell.h"

@interface YSMTalkViewController () <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_familiesArray;//数据源
    BOOL _tableViewScrollFlag;//标记是头刷新
}

@property (nonatomic,strong) YSMTalkViewMiddleNavigationBar *middleNavView;
@property (nonatomic,strong) UITableView *familiesTableView;//家人列表
@property (nonatomic,strong) YSMTalkMessageCard *messageCard;//消息列表

@end

@implementation YSMTalkViewController

//*************************************
//      视图加载及UI创建
//*************************************
#pragma mark - 视图加载及UI创建
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _familiesArray = [[NSMutableArray alloc] init];
    
    //创建UI
    [self createTalkViewUI];
}

- (BOOL)createTalkViewUI
{
    //UITableView
    self.familiesTableView = [[UITableView alloc]
                              initWithFrame:CGRectMake(0.0f, 0.0f,
                                    self.mainShowView.frame.size.width,
                                    self.mainShowView.frame.size.height)
                              style:UITableViewStylePlain];
    self.familiesTableView.showsHorizontalScrollIndicator = NO;
    self.familiesTableView.showsVerticalScrollIndicator = NO;
    self.familiesTableView.dataSource = self;
    self.familiesTableView.delegate = self;
    [self.familiesTableView addHeaderWithTarget:self action:@selector(getFamilies)];
    [self.familiesTableView headerBeginRefreshing];
    self.familiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainShowView addSubview:self.familiesTableView];
    [self.scrollView removeFromSuperview];
    
    //创建消息视图
    self.messageCard = [[YSMTalkMessageCard alloc]
                                initWithFrame:CGRectMake(
                                    self.mainShowView.frame.size.width,
                                    0.0f,
                                    self.mainShowView.frame.size.width,
                                    self.mainShowView.frame.size.height)];
    [self.mainShowView addSubview:self.messageCard];
    [self.messageCard setFriendsList:_familiesArray];
    
    //为家人和消息添加手执
    [self addSwipGesture];
    
    //中间视图
    self.middleNavView = (YSMTalkViewMiddleNavigationBar *)[UIView createTalkViewMiddleNavigationBar:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andCallBack:^(TC_NA_MIDDLE_VIEW_ACTION_TYPE actionType) {
        if (actionType == TCNAMVLeftButtonActionType) {
            //打开家人列表
            [self showMessageCard:NO];
            return;
        }
        
        //打开消息窗口
        if (actionType == TCNAMVRightButtonActionType) {
            [self showMessageCard:YES];
            return;
        }
    }];
    [self setNavigationBarMiddleView:self.middleNavView];
    
    //设置消息提醒
    [self setMessagesCountTips];
    
    //注册好友申请事件
    [self registFriendsCallAction];
    
    return YES;
}

//提醒当前的未读消息
- (void)setMessagesCountTips
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    [manager monitorReceiveMessageTips:^(int num) {
        [self.middleNavView alertMessageCount:num];
    }];
}

//家人和消息列表添加滑动手执
- (void)addSwipGesture
{
    UISwipeGestureRecognizer *leftSwipGesture = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(swipGestureAction:)];
    [leftSwipGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.mainShowView addGestureRecognizer:leftSwipGesture];
    
    UISwipeGestureRecognizer *rightSwipGesture = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipGestureAction:)];
    [rightSwipGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.mainShowView addGestureRecognizer:rightSwipGesture];
}

- (void)swipGestureAction:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.messageCard.frame.origin.x >= 0.0f) {
            return;
        }
        [self showMessageCard:YES];
        [self.middleNavView setSelectedIndex:0];
        return;
    }
    
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.familiesTableView.frame.origin.x >= 0.0f) {
            return;
        }
        [self showMessageCard:NO];
        [self.middleNavView setSelectedIndex:1];
        return;
    }
}

//注册好友申请事件
#pragma mark - 弹出好友申请
- (void)registFriendsCallAction
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    
    //注册好友申请事件
    [manager registFriendRequestCallBack:^(NSString *string, BLOCK_BOOL_ACTION callBack) {
        //弹出好友申请
        NSString *message = [NSString stringWithFormat:@"%@ 申请加你为好友",string];
        UIAlertView *alert = [UIAlertView createYSMBlockAlertViewWithTitle:nil message:message andCallBack:^(int num) {
            if (num == alert.cancelButtonIndex) {
                callBack(NO);
            } else {
                //刷新好友列表
                [self.familiesTableView headerBeginRefreshing];
                callBack(YES);
            }
        } cancelButtonTitle:@"拒绝" otherButtonTitles:@"添加",nil];
        [alert show];
    }];
}

//获取家庭组成员
- (void)getFamilies
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    _tableViewScrollFlag = YES;
    //获取好友列表
    [manager getFriendsList:^(NSArray *array) {
        //如果没有好友则弹出说明
        if (nil == array || 0 == [array count]) {
            [self alertWrongMessage:nil andMessage:@"暂无好友哟~~~点击右上角添加^_^"];
            [self.familiesTableView headerEndRefreshing];
            return;
        }
        
        [_familiesArray removeAllObjects];
        [_familiesArray addObjectsFromArray:array];
        [self.familiesTableView reloadData];
        [self.messageCard setFriendsList:_familiesArray];
        [self.familiesTableView headerEndRefreshing];
    } andFailCallBack:^(NSError *error) {
        [self alertWrongMessage:nil andMessage:@"获取好友失败"];
        [self.familiesTableView headerEndRefreshing];
    }];
}

//*************************************
//      消息列表和家人列表隐藏和显示
//*************************************
#pragma mark - 消息列表和家人列表隐藏和显示
- (void)showMessageCard:(BOOL)flag
{
    if (flag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.familiesTableView.frame =
            CGRectMake(-320.0f, self.familiesTableView.frame.origin.y,
                       self.familiesTableView.frame.size.width,
                       self.familiesTableView.frame.size.height);
            self.messageCard.frame =
            CGRectMake(0.0f, self.messageCard.frame.origin.y,
                       self.messageCard.frame.size.width,
                       self.messageCard.frame.size.height);
        }];
        [self.messageCard reloadMessages];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.familiesTableView.frame =
            CGRectMake(0.0f, self.familiesTableView.frame.origin.y,
                       self.familiesTableView.frame.size.width,
                       self.familiesTableView.frame.size.height);
            self.messageCard.frame =
            CGRectMake(320.0f, self.messageCard.frame.origin.y,
                       self.messageCard.frame.size.width,
                       self.messageCard.frame.size.height);
        }];
        [self.messageCard removeMessageReceiveListener];
    }
}

//*************************************
// UITableViewDataSource and Delegate method
//*************************************
#pragma mark - UITableViewDataSource and Delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_familiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell_normal";
    YSMFamiliesListTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == myCell) {
        myCell = [[YSMFamiliesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSMXMPPFriendsInfoModel *model = _familiesArray[indexPath.row];
    [myCell updateFamiliesCellUIWithDataModel:model];
    
    return myCell;
}

//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155.0f;
}

@end
