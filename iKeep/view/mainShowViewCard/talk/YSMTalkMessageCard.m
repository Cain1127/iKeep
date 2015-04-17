//
//  YSMTalkMessageCard.m
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTalkMessageCard.h"
#import "YSMXMPPManager.h"
#import "YSMBlockActionButton.h"
#import "YSMTouchBlockActionTableView.h"
#import "YSMMessagesListTableViewCell.h"

@interface YSMTalkMessageCard () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray *_familiesList;//持有一个家庭成员列表
}

@property (nonatomic,strong) YSMTouchBlockActionTableView *messagesTableView;//消息tableview
@property (nonatomic,retain) NSMutableArray *messagesArray;//消息数据
@property (nonatomic,strong) UIView *bottomView;//底部视图

@end

@implementation YSMTalkMessageCard

//******************************************
//      初始化
//******************************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //用户交互
        self.userInteractionEnabled = YES;
        
        //消息数组初始化
        self.messagesArray = [[NSMutableArray alloc] init];
        _familiesList = [[NSMutableArray alloc] init];
        
        [self createTalkMessageCardUI];
        
        //键盘弹出时自动向上滑动
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisAppearanceAction:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)createTalkMessageCardUI
{
    self.messagesTableView = [[YSMTouchBlockActionTableView alloc]
                              initWithFrame:CGRectMake(0.0f, 0.0f,
                            self.frame.size.width, self.frame.size.height-54.0f)];
    self.messagesTableView.showsHorizontalScrollIndicator = NO;
    self.messagesTableView.showsVerticalScrollIndicator = NO;
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.messagesTableView];
    
    //发送消息
    self.bottomView = [[UIView alloc]
                          initWithFrame:CGRectMake(0.0f,
                        self.frame.size.height - 54.0f,
                        self.frame.size.width,
                        54.0f)];
    self.bottomView.backgroundColor = DEDEFAULT_FORWARDGROUND_COLOR;
    [self addSubview:self.bottomView];
    
    //输入框
    UITextField *inputField = [[UITextField alloc]
                    initWithFrame:CGRectMake(10.0f, 5.0f,
                    self.bottomView.frame.size.width - 70.0f, 44.0f)];
    inputField.backgroundColor = [UIColor whiteColor];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate = self;
    inputField.keyboardType = UIKeyboardTypeDefault;
    [self.bottomView addSubview:inputField];
    self.messagesTableView.action = ^(){
        [inputField resignFirstResponder];
    };
    
    //send button
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    buttonStyle.titleHightedColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:16.0f];
    UIButton *sendButton = [UIButton createYSMBlockActionButton:CGRectMake(self.bottomView.frame.size.width - 50.0f, 5.0f, 40.0f, 44.0f) andTitle:@"发送" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        NSString *message = inputField.text;
        if (nil == message) {
            [inputField resignFirstResponder];
            return;
        }
        
        //如若信息不会空，则发送信息
        [self sendMessage:message];
        [inputField resignFirstResponder];
        inputField.text = @"";
    }];
    [self.bottomView addSubview:sendButton];
}

//加持好友列表
- (void)setFriendsList:(NSArray *)array
{
    //清空
    [_familiesList removeAllObjects];
    for (YSMXMPPFriendsInfoModel *obj in array) {
        [_familiesList addObject:obj.jidString];
    }
}

//*************************************
//  收键盘事件
//*************************************
#pragma mark - 收键盘事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardAppearanceAction:(NSNotification *)sender
{
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.bottomView.frame.origin.x,
                              self.frame.size.height - 54.0f - 251.0f,
                              self.bottomView.frame.size.width,
                              self.bottomView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        self.bottomView.frame = frame;
    }];
}

- (void)keyboardDisAppearanceAction:(NSNotification *)sender
{
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.bottomView.frame.origin.x,
                              self.frame.size.height - 54.0f,
                              self.bottomView.frame.size.width,
                              self.bottomView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        self.bottomView.frame = frame;
    }];
}

//*************************************
//  UITableView数据源
//*************************************
#pragma mark - UITableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //YSMMessagesListTableViewCell
    YSMMessageModel *model = self.messagesArray[indexPath.row];
    if (model.type == XMTypeSend) {
        static NSString *cellNameSend = @"cell_send";
        YSMMessagesListTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellNameSend];
        if (nil == myCell) {
            myCell = [[YSMMessagesListTableViewCell alloc] initWithMessageStyle:XMFromSelf reuseIdentifier:cellNameSend];
        }
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [myCell updateMessageCellUI:model];
        
        return myCell;
    } else if(model.type == XMTypeReceive){
        static NSString *cellNameReceive = @"cell_receive";
        YSMMessagesListTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellNameReceive];
        if (nil == myCell) {
            myCell = [[YSMMessagesListTableViewCell alloc] initWithMessageStyle:XMFromFamilies reuseIdentifier:cellNameReceive];
        }
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [myCell updateMessageCellUI:model];
        
        return myCell;
    }
    
    static NSString *cellName = @"cell_defaul";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == myCell) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCell;
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

//*************************************
//  加载消息
//*************************************
#pragma mark - 加载消息
- (void)reloadMessages
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    
    //添加消息监听
    [manager monitorReciveMessage:^(YSMMessageModel *model) {
        [self.messagesArray addObject:model];
        [self.messagesTableView reloadData];
    }];
    
    //获取消息数组
    [self.messagesArray removeAllObjects];
    [self.messagesArray addObjectsFromArray:[manager readMessage]];
    [self.messagesTableView reloadData];
}

//清除消息监听
- (void)removeMessageReceiveListener
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    [manager monitorReciveMessage:nil];
    [self.messagesArray removeAllObjects];
}

//**************************************
//      发送信息
//**************************************
- (void)sendMessage:(NSString *)msg
{
    if (_familiesList && ([_familiesList count] > 0)) {
        YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
        [manager sendMessage:msg toUsers:_familiesList];
    }
}

@end
