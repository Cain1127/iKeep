//
//  YSMXMPPManager.m
//  iKeep
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMXMPPManager.h"
#import "XMPP.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "YSMRegistUserDataModel.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTemp.h"
#import "XMPPReconnect.h"
#import "YSMLoginUserDataModel.h"
#import "NSDate+YSMGetChineseDate.h"
#import "NSData+XMPP.h"
#import "NSData+Base64.h"
#import "YSMvCardDataModel.h"

#define QUEUE_KEY_XMPPSAFEOPERATION "xmpp_safe_operation_queue"

@interface YSMXMPPManager () <XMPPStreamDelegate,XMPPReconnectDelegate> {
    //用户名和密码
    NSString *_userName;
    NSString *_keyWords;
    NSString *_jidString;//记录自身的jid
    
    //消息保存数组
    NSMutableArray *_messagesArray;
    
    XMPPStream *_xmppStream;//xmpp流
    
    //连接器
    XMPPReconnect *_xmppReconnect;
    
    //电子名片数据存储模块
    XMPPvCardCoreDataStorage *_xmppvCardStorage;
    XMPPvCardTemp *_tempvCard;//暂时保存的vCard
    
    //花名册+用于添加好友,删除好友
    XMPPRoster *_xmppRoster;
    XMPPRosterCoreDataStorage *_xmppRosterStorage;
}

//保存变量读取时线程安全的自定义线程
@property (nonatomic,strong) dispatch_queue_t xmppManagerCurrentQueue;

//连接服务器时block
@property (nonatomic,copy) BLOCK_VOID_ACTION connectSuccessAction;
@property (nonatomic,copy) BLOCK_ERROR_ACTION connectFailAction;

//注册用户时的block
@property (nonatomic,copy) BLOCK_vCARDMODEL_ACTION registSuccessAction;
@property (nonatomic,copy) BLOCK_ERROR_ACTION registFailAction;

//登录时的回调block
@property (nonatomic,copy) BLOCK_VOID_ACTION loginSuccessAction;
@property (nonatomic,copy) BLOCK_ERROR_ACTION loginFailAction;

//获取好友时的回调block
@property (nonatomic,copy) BLOCK_ARRAY_ACTION getFriendsListSuccess;
@property (nonatomic,copy) BLOCK_ERROR_ACTION getFriendsListFail;

//接收信息回调block
@property (nonatomic,copy) BLOCK_XMMODEL_ACTION reciveiveMessageAction;
@property (nonatomic,copy) BLOCK_INT_ACTION receiveMessageTipsAction;

//接收好友请求时的回调
@property (nonatomic,copy) BLOCK_NSSTRING_BLOCK_ACTION reciveAddFriendRequest;

//获取自己vCard时的回调
@property (nonatomic,copy) BLOCK_vCARDMODEL_ACTION getSelfvCardCallBack;
@property (nonatomic,retain) NSMutableDictionary *getSelfvCardCallBackDict;

@property (nonatomic,copy) BLOCK_vCARDMODEL_ACTION updateIconCallBack;

@end

@implementation YSMXMPPManager

//获取单例
+ (YSMXMPPManager *)shareXMPPManager
{
    static YSMXMPPManager *manager = nil;
    
    //创建单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YSMXMPPManager alloc] init];
    });
    
    return manager;
}

//****************************************************
//                  对象方法
//****************************************************
#pragma mark - 初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        //初始化自定主线程
        self.xmppManagerCurrentQueue = dispatch_queue_create(QUEUE_KEY_XMPPSAFEOPERATION,DISPATCH_QUEUE_CONCURRENT);
        
        //实例化xmpp stream
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //实例化连接
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect activate:_xmppStream];
        [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];

        // 实例化花名册模块
        _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
        // * 设置花名册属性
        [_xmppRoster setAutoFetchRoster:YES];
        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
        // 激活花名册模块
        [_xmppRoster activate:_xmppStream];
        // 添加代理
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        // 实例化电子名片模块
        _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        _xmppvCardTempModel = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
        
        // 激活电子名片模块
        [_xmppvCardTempModel activate:_xmppStream];
        
        //初始化消息储存的数组
        _messagesArray = [[NSMutableArray alloc] init];
        
        //初始化个人vCard回调字典
        self.getSelfvCardCallBackDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

//****************************************************
//                  连接服务器
//****************************************************
#pragma mark - 连接服务器
- (BOOL)connectToServer:(NSString *)host andDomain:(NSString *)domain successCallBalk:(BLOCK_VOID_ACTION)successAction failCallBack:(BLOCK_ERROR_ACTION)failAction
{
    //xmpp已连接服务器，则直接返回
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    //保存回调block
    self.connectSuccessAction = successAction;
    self.connectFailAction = failAction;
    
    //设置xmpp的jid及服务器
    NSString *jidString = [NSString stringWithFormat:@"anonymous@%@",domain];
    [_xmppStream setMyJID:[XMPPJID jidWithString:jidString]];
    [_xmppStream setHostName:host];
    
    //连接服务器
    NSError *error = nil;
    [_xmppStream connectWithTimeout:10.0f error:&error];
    if (error) {
        self.connectFailAction(error);
        self.connectFailAction = nil;
        NSLOG_XMPP_ERROR_DEFINE([self class], @"connectToServer", host);
        return NO;
    }
    
    return YES;
}

//连接成功时执行
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    if (self.connectSuccessAction) {
        self.connectSuccessAction();
    }
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (self.connectFailAction) {
        NSLOG_XMPP_ERROR_DEFINE([self class], @"xmppStreamDidDisconnect", error);
    }
}

//****************************************************
//                 退出
//****************************************************
#pragma mark - 退出
- (void)disConnnectServer:(BOOL)flag
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    
    //更新上次登录时间
    [self updateLastLoginDate];
    
    [_xmppStream disconnect];
}


//****************************************************
//                  客户端断开后重新连接
//****************************************************
#pragma mark - 客户端断开后重新连接
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags
{
    NSLog(@"重连");
    return YES;
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags
{
    if (self.connectFailAction) {
        self.connectFailAction([self customConnectedFailError]);
    }
    NSLog(@"xmpp服务器连接失败：didDetectAccidentalDisconnect : \n %u ", connectionFlags);
}

//****************************************************
//                  注册用户
//****************************************************
#pragma mark - 注册用户
- (BOOL)registCount:(YSMRegistUserDataModel *)model successCallBack:(BLOCK_vCARDMODEL_ACTION)succAction failCallBack:(BLOCK_ERROR_ACTION)failAction
{
    NSDictionary *errorInfo = nil;
    NSError *error = nil;
    
    //如果服务器未连接，返回失败
    if (![_xmppStream isConnected]) {
        errorInfo = [NSDictionary dictionaryWithObject:@"服务器未连接"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:XConnectFailed userInfo:errorInfo];
        failAction(error);
        return NO;
    }
    
    //保存回调block
    self.registSuccessAction = succAction;
    self.registFailAction = failAction;
    
    //保存用户信息
    _userName = model.userName;
    _keyWords = model.keyWord;

    //封装JID
    if (![self setJIDByCount:model.userName]) {
        errorInfo = [NSDictionary dictionaryWithObject:@"JID封装错误"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:XJIDPackagedFailed userInfo:errorInfo];
        self.registFailAction(error);
        return NO;
    }
    
    //注册操作
    if (![_xmppStream registerWithPassword:model.keyWord error:&error])
    {
        self.registFailAction(error);
        return NO;
    }
    
    return YES;
}

//注册成功会调用:
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    //更新myvCard
    if (self.registSuccessAction) {
        //注册成功后需要默认存一份vCard
        [self loadDefaultUservCardFirstRegist];
    }
}

- (void)loadDefaultUservCardFirstRegist
{
    XMPPvCardTemp *myvCard = [self createDefaultUservCard];
    YSMLoginUserDataModel *loginModel = [[YSMLoginUserDataModel alloc] init];
    loginModel.userName = _userName;
    loginModel.keyWords = _keyWords;
    
    //登录
    [self loginWithModel:loginModel successCallBack:^{
        //登录成功
        [self.xmppvCardTempModel updateMyvCardTemp:myvCard];
        
        //重新下载vCard
        [self getSelfvCardMessage:^(YSMvCardDataModel *model) {
            if (self.registSuccessAction) {
                model.icon = [UIImage imageWithData:myvCard.photo];
                self.registSuccessAction(model);
            }

            //更新成功后退出
            [self disConnnectServer:NO];
            //再进行一次连接
            [self connectToServer:XMPP_SERVER_HOST andDomain:XMPP_SERVER_DOMAIN successCallBalk:^{
                NSLog(@"xmpp连接成功：%s:%s:%d",__FILE__,__FUNCTION__,__LINE__);
            } failCallBack:^(NSError *error) {
                NSLog(@"xmpp连接失败：%s:%s:%d",__FILE__,__FUNCTION__,__LINE__);
            }];
        }];
        
    } failCallBack:^(NSError *error) {
        NSLog(@"注册成功，但是vCard设置失败---登录");
    }];
}

//注册失败会调用:
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    //注意: 如果错误码是 409, 说明这个用户已经注册
    NSString *errorCode = [[[error elementForName:XMPP_REGIST_ERROR_ELEMENT] attributeForName:XMPP_REGIST_ERROR_NODECODE] stringValue];
    NSLOG_XMPP_REGIST_FAIL([self class],@"xmppStream didNotRegister",errorCode,error);
    
    //返回自定义error
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:errorCode forKey:NSLocalizedDescriptionKey];
    NSError *errorResult = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:XMyvCardPackagedFailed userInfo:errorInfo];
    if (self.registFailAction) {
        self.registFailAction(errorResult);
    }
}

//****************************************************
//                  登录
//****************************************************
#pragma mark - 登录
//注意: 登陆的时候同时连接, 异步操作
- (BOOL)loginWithModel:(YSMLoginUserDataModel *)model successCallBack:(BLOCK_VOID_ACTION)succAction failCallBack:(BLOCK_ERROR_ACTION)failAction
{
    //先检查是否登录(授权)
    if (_xmppStream.isAuthenticated) {
        //返回自定义error
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"用户已登录" forKey:NSLocalizedDescriptionKey];
        NSError *errorResult = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:XMyvCardPackagedFailed userInfo:errorInfo];
        failAction(errorResult);
        return NO;
    }
    
    //如果未传入用户名或密码, 直接返回
    if (model.userName == nil || model.keyWords == nil) {
        return NO;
    }
    
    //保存用户名与密码
    _userName = model.userName;
    _keyWords = model.keyWords;
    
    //保存登录回调
    self.loginSuccessAction = succAction;
    self.loginFailAction = failAction;
    
    //验证帐户密码
    NSError *error = nil;
    [self setJIDByCount:_userName];
    [_xmppStream authenticateWithPassword:model.keyWords error:&error];
    
    //判断登录是否成功
    if (error) {
        failAction(error);
        return NO;
    }
    
    return YES;
}

//验证成功的回调函数
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender

{
    XMPPPresence *presence = [XMPPPresence presence];
    //可以加上上线状态，比如忙碌，在线等
    [_xmppStream sendElement:presence];//发送上线通知
    _jidString = [NSString stringWithFormat:@"%@@%@",sender.myJID.user,sender.myJID.domain];
    
    //回调
    if(self.loginSuccessAction)
    {
        self.loginSuccessAction();
    }
}

//验证失败的回调

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSString *errorCode = [[[error elementForName:XMPP_REGIST_ERROR_ELEMENT] attributeForName:XMPP_REGIST_ERROR_NODECODE] stringValue];
    NSLOG_XMPP_LOGIN_FAIL([self class],@"xmpp login fail",errorCode,error);
    
    //返回自定义error
    if (errorCode == nil) {
        errorCode = @"";
    }
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:errorCode forKey:NSLocalizedDescriptionKey];
    NSError *errorResult = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:XMyvCardPackagedFailed userInfo:errorInfo];
    
    //回调
    if(self.loginFailAction)
    {
        self.loginFailAction(errorResult);
    }
}

//****************************************************
//             获取好友列表
//****************************************************
#pragma mark - 获取好友列表
- (BOOL)getFriendsList:(BLOCK_ARRAY_ACTION)successAction andFailCallBack:(BLOCK_ERROR_ACTION)failAction
{
    //保存回调
    self.getFriendsListSuccess = successAction;
    self.getFriendsListFail = failAction;
    
    
    //原理: 获取原理发送XML结构数据
    //  包含了需要的操作
    
    //查询 queryRoster, 好友列表
    
    //id 属性，标记该请求 ID，当服务器处理完毕请求 get 类型的 iq 后，响应的 result 类型 iq 的 ID 与 请求 iq 的 ID 相同
    NSString *generateID = @"get_roster";
    
    /*
     <iq type="get"
     
     　　from="xiaoming@example.com"
     
     　　to="example.com"
     
     　　id="1234567">
     
     　　<query xmlns="jabber:iq:roster"/>
     
     <iq />
     */
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = _xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:generateID];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [_xmppStream sendElement:iq];
    return YES;
}

/*
<iq type="result"

　　id="1234567"

　　to="xiaoming@example.com">

　　<query xmlns="jabber:iq:roster">

　　　　<item jid="xiaoyan@example.com" name="小燕" />

　　　　<item jid="xiaoqiang@example.com" name="小强"/>

　　<query />

<iq />
*/
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    if ([@"result" isEqualToString:iq.type]) {
        
        //获取好友列表返回的结果
        if ([@"get_roster" isEqualToString:iq.elementID]) {
            NSXMLElement *query = iq.childElement;
            if ([@"query" isEqualToString:query.name]) {
                NSArray *items = [query children];
                
                //如若没有好友
                if (nil == items || 0 >= [items count]) {
                    if(self.getFriendsListSuccess)
                    {
                        self.getFriendsListSuccess(items);
                    };
                    return YES;
                }
                
                //解析联系人
                [self analyzeRosterWithFamiliesItems:items andCallBack:^(NSArray *userList){
                    if(self.getFriendsListSuccess)
                    {
                        self.getFriendsListSuccess(userList);
                    }
                }];
            }
        } else if([@"get_famileis_vCard" isEqualToString:iq.elementID]){
            //获取自己vCard
            /*
             <vCard xmlns="vcard-temp">
             <PHOTO>
             <TYPE>image/jpeg</TYPE>
             <BINVAL>/9j/4AAQSkZJRgABAQEASABIAAD/</BINVAL>
             </PHOTO>
             <NICKNAME>simular5s</NICKNAME>
             <N>
                <MIDDLE>2014-11-09 22:47:50 +0000</MIDDLE>
                <FAMILY>??</FAMILY>
                <GIVEN>?</GIVEN>
             </N>
             <ROLE>default</ROLE>
             <JABBERID>simular5s@ysmeng.local</JABBERID>
             <TITLE>????????????</TITLE>
             <FN>ysmeng.local</FN>
             </vCard>
             */
            NSXMLElement *query = iq.childElement;
            NSLog(@"iq to = %@@%@",iq.from.user,iq.from.domain);
            
            [self analyzePersonInfoWithIQElement:query andJID:[NSString stringWithFormat:@"%@@%@",iq.from.user,iq.from.domain]];
            
#if 0
            //查询vCard
            if ([iq elementForName:@"vCard"]){
                NSXMLElement *vCard = [iq elementForName:@"vCard"];
                FriendUserInformationModel *infromationModel = [[FriendUserInformationModel alloc] init];
                infromationModel.fromString = [[iq attributeForName:@"from"] stringValue];
                infromationModel.communityString = [[vCard elementForName:@"COMMUNITY"] stringValue];
                infromationModel.sexString = [[vCard elementForName:@"SEX"] stringValue];
                infromationModel.nickNameString = [[vCard elementForName:@"NICKNAME"] stringValue];
                infromationModel.signatureString = [[vCard elementForName:@"SIGNATURE"] stringValue];
                infromationModel.binvalString = [[(XMPPElement *)[[iq
                                                                   elementForName:@"vCard"] elementForName:@"PHOTO"] elementForName:@"BINVAL"] stringValue];
                NSData *imageData = [NSData dataWithBase64EncodedString:infromationModel.binvalString];   // you need to get NSData
                NSString* decryptedStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
                infromationModel.imageUrlString = decryptedStr;
                [decryptedStr release];
                [self.frindInformationArray addObject:infromationModel];
                [infromationModel release];
                return YES;
            }
#endif
        }
    }
    return YES;
}

//解析联系人
- (void)analyzeRosterWithFamiliesItems:(NSArray *)itemArray andCallBack:(BLOCK_ARRAY_ACTION)callBACK
{
#if 1
    //如若有好友
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    for (NSXMLElement *item in itemArray) {
        //取得个人JID信息
        NSString *jid = [item attributeStringValueForName:@"jid"];
        NSString *name = [item attributeStringValueForName:@"name"];
        if (nil == name) {
            NSRange range = [jid rangeOfString:@"@"];
            name = [jid substringToIndex:range.location];
        }
        
        //取得个人vCard
        YSMXMPPFriendsInfoModel *model = [[YSMXMPPFriendsInfoModel alloc] init];
        model.jidString = jid;
        model.name = name;
        
        //添加数据
        [userList addObject:model];
    }
    
    callBACK(userList);
#endif
}

//解析个人信息
- (void)analyzePersonInfoWithIQElement:(NSXMLElement *)query andCallBack:(BLOCK_vCARDMODEL_ACTION)callBack
{
    NSXMLElement *nickNameE = [query elementForName:@"NICKNAME"];
    NSString *nickName = [nickNameE stringValue];
    YSMvCardDataModel *model = [[YSMvCardDataModel alloc] init];
    model.nickName = nickName;
    model.userName = _userName;
    NSXMLElement *imageBinvalData = [[query elementForName:@"PHOTO"] elementForName:@"BINVAL"];
    NSData *imageData = [NSData dataWithBase64EncodedString:[imageBinvalData stringValue]];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    model.icon = iconImage;
    model.city = [[[query elementForName:@"N"] elementForName:@"FAMILY"] stringValue];
    model.weather = [[[query elementForName:@"N"] elementForName:@"GIVEN"] stringValue];
    model.shareAbout = [[query elementForName:@"TITLE"] stringValue];
    model.lastLoginTime = [[[query elementForName:@"N"] elementForName:@"MIDDLE"] stringValue];
    callBack(model);
}

- (YSMvCardDataModel *)analyzePersonInfoWithIQElement:(NSXMLElement *)query andJID:(NSString *)jidString
{
    NSXMLElement *nickNameE = [query elementForName:@"NICKNAME"];
    NSString *nickName = [nickNameE stringValue];
    YSMvCardDataModel *model = [[YSMvCardDataModel alloc] init];
    model.nickName = nickName;
    model.userName = _userName;
    NSXMLElement *imageBinvalData = [[query elementForName:@"PHOTO"] elementForName:@"BINVAL"];
    NSData *imageData = [NSData dataWithBase64EncodedString:[imageBinvalData stringValue]];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    model.icon = iconImage;
    model.city = [[[query elementForName:@"N"] elementForName:@"FAMILY"] stringValue];
    model.weather = [[[query elementForName:@"N"] elementForName:@"GIVEN"] stringValue];
    model.shareAbout = [[query elementForName:@"TITLE"] stringValue];
    model.lastLoginTime = [[[query elementForName:@"N"] elementForName:@"MIDDLE"] stringValue];
    
    BLOCK_vCARDMODEL_ACTION callBack = [self.getSelfvCardCallBackDict valueForKey:jidString];
    callBack(model);
    
    [self.getSelfvCardCallBackDict removeObjectForKey:jidString];
    
    return model;
}

//****************************************************
//                  数据封装
//****************************************************
#pragma mark - 添加好友,删除好友和处理好友请求
- (void)sendAddFriendRequestWithJidString:(NSString *)jidString andCallBack:(BLOCK_NSSTRING_ACTION)callBack
{
    // 判断是否已经是好友
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    BOOL isExist = [_xmppRosterStorage userExistsWithJID:jid xmppStream:_xmppStream];
    
    if (isExist) {
        callBack([NSString stringWithFormat:@"%@已经是你的好友",jidString]);
        return;
    }
    
    // 发送好友订阅请求
    [_xmppRoster subscribePresenceToUser:jid];
    callBack(@"好友请求已发送，等待对方确认!");
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    // 1. 取得好友当前类型（状态）
    NSString *presenceType = [presence type];
    /*
     <presence xmlns="jabber:client" 
        id="6LrnE-6"
        from="testregist01@ysmeng.local/Spark 2.6.3"
        to="hello@ysmeng.local/5cec24a2">
        <status>在线</status>
        <priority>1</priority>
     </presence>
     */
#if 0
    //1.好友上线：presence type = @"available";
    
#endif
#if 0
    //2.好友下线：presence type = @"unavailable"
#endif
#if 1
    // 3. 如果是用户订阅，则添加用户
    if ([presenceType isEqualToString:@"subscribe"]) {
        NSString *jidString = [presence from].user;
        if(self.reciveAddFriendRequest){
            self.reciveAddFriendRequest(jidString,^(BOOL flag){
                if(flag){
                    // 接收好友订阅请求
                    [_xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
                } else {
                    [_xmppRoster rejectPresenceSubscriptionRequestFrom:[presence from]];
                }
            });
        }
    }
#endif
}

//发送查询vCard的消息
#if 0
- (void)myNeighborhoodUsersDetail:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSXMLElement *query = [iq elementForName:@"query"];
    NSArray * items = [query elementsForName:@"item"];
    for (int i = 0; i < [items count]; i++){
        NSXMLElement *item = [items objectAtIndex:i];
        NSString *jidString = [item attributeStringValueForName:@"jid"];
        NSLog(@"jidString %@",jidString);
        
        XMPPIQ *xmPPIQ = [[XMPPIQ alloc] initWithType:@"get"];
        [xmPPIQ addAttributeWithName:@"to" stringValue:jidString/*好友的jid*/];
        NSXMLElement *vElement = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
        [xmPPIQ addChild:vElement];
        //    通过xmppStream发送请求，重新下载vcard：
        [xmppStream sendElement:xmPPIQ];
    }
}
#endif

- (void)registFriendRequestCallBack:(BLOCK_NSSTRING_BLOCK_ACTION)callBack
{
    if (callBack) {
        self.reciveAddFriendRequest = callBack;
    }
}

#pragma mark - 消息发送和接收
//接收到消息时此方法执行
/*
 <message xmlns="jabber:client" from="abel@xxx.xxxxx/AbeltekiMacBook-Pro" to="wuliao@xxxx.xxx" type="chat" id="purple756090eb">
 <active xmlns="http://jabber.org/protocol/chatstates"></active>
 <body>你好</body>
 <html xmlns="http://jabber.org/protocol/xhtml-im">
 <body xmlns="http://www.w3.org/1999/xhtml">
 <p>
 <span style="font-family: Heiti SC; font-size: medium;">你好</span>
 </p>
 </body>
 </html>
 </message>
 
 */

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *messageBody = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    YSMMessageModel *model = [[YSMMessageModel alloc] init];
    model.type = XMTypeReceive;
    model.readStatu = XMReadStatuUNReaded;
    model.messageString = messageBody;
    
    XMPPJID *jid = [XMPPJID jidWithString:from];
    model.from = [NSString stringWithFormat:@"%@@%@",jid.user,jid.domain];
    __block YSMvCardDataModel *vCard = [[YSMvCardDataModel alloc] init];
    [self getFriendsvCardWithJID:model.from andCallBack:^(YSMvCardDataModel *vCardModel) {
        vCard = vCardModel;
        model.vCard = vCard;
    }];
    model.fromName = jid.user;
    model.messageTime = [NSDate getCurrentDateTimeString];
    model.to = _jidString;
    
    //保存消息
    [self addMessage:model];
}

//接收到消息的回调事件设置
- (void)monitorReciveMessage:(BLOCK_XMMODEL_ACTION)dealReciveFunc
{
    if (dealReciveFunc) {
        self.reciveiveMessageAction = dealReciveFunc;
    } else {
        self.reciveiveMessageAction = nil;
    }
}

//接收目前接收到的消息条数提醒
- (void)monitorReceiveMessageTips:(BLOCK_INT_ACTION)callBack
{
    if (callBack) {
        self.receiveMessageTipsAction = callBack;
        self.receiveMessageTipsAction((int)[self getUNReadMessageCount]);
    } else {
        self.receiveMessageTipsAction = nil;
    }
}

//读取消息
- (NSArray *)readMessage
{
    __block NSArray *resultArray;
    dispatch_sync(self.xmppManagerCurrentQueue, ^{
        resultArray = [NSArray arrayWithArray:_messagesArray];
        [self resetMessageReadStatu];
    });
    return resultArray;
}

//发送消息
- (void)sendMessage:(NSString *)message toUsers:(NSArray *)familiesList
{
    //先保存信息
    YSMMessageModel *model = [[YSMMessageModel alloc] init];
    model.type = XMTypeSend;
    model.readStatu = XMReadStatuUNReaded;
    model.from = _jidString;
    model.to = @"families@ysmeng.local";
    model.fromName = _userName;
    model.messageTime = [NSDate getCurrentDateTimeString];
    model.messageString = message;
    [self getSelfvCardMessage:^(YSMvCardDataModel *vCardModel) {
        model.vCard = vCardModel;
    }];
    [self addMessage:model];
    
    for (NSString *jid in familiesList) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        NSXMLElement *messageElement = [NSXMLElement elementWithName:@"message"];
        [messageElement addAttributeWithName:@"type" stringValue:@"chat"];
        
        NSString *to = [NSString stringWithFormat:@"%@", jid];
        [messageElement addAttributeWithName:@"to" stringValue:to];
        [messageElement addChild:body];
        [_xmppStream sendElement:messageElement];
    }
}

//保存一个消息
- (void)addMessage:(YSMMessageModel *)model
{
    //保证消息数组的读写线程安全
    dispatch_barrier_async(self.xmppManagerCurrentQueue, ^{
        [_messagesArray addObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果用户当前在消息页面
            if (self.reciveiveMessageAction) {
                self.reciveiveMessageAction(model);
                //修改消息状态
                dispatch_sync(self.xmppManagerCurrentQueue, ^{
                    [self resetMessageReadStatu];
                });
                return;
            }
            //如果用户在好友列表，则提示有新消息到来
            if (self.receiveMessageTipsAction) {
                self.receiveMessageTipsAction((int)[self getUNReadMessageCount]);
            }
        });
    });
}

//修改消息数组中的消息状态
- (void)resetMessageReadStatu
{
    for (YSMMessageModel *obj in _messagesArray) {
        obj.readStatu = XMReadStatuReaded;
    }
    
    //通知消息提醒
    if (self.receiveMessageTipsAction) {
        self.receiveMessageTipsAction(0);
    }
}

//取得未读取消息的数量
- (NSInteger)getUNReadMessageCount
{
    NSInteger count = 0;
    for (YSMMessageModel *obj in _messagesArray) {
        if (obj.readStatu == XMReadStatuUNReaded) {
            count++;
        }
    }
    return count;
}

//****************************************************
//                  数据封装
//****************************************************
#pragma mark - 更新头像
- (void)updatePersonHeaderIcon:(UIImage *)newIcon andCallBack:(BLOCK_vCARDMODEL_ACTION)callBack
{
#if 1
    XMPPvCardTemp *myvCardTemp = [self.xmppvCardTempModel myvCardTemp];
    if (myvCardTemp) {
        myvCardTemp.photo = UIImageJPEGRepresentation(newIcon, 0.6);
        [self.xmppvCardTempModel updateMyvCardTemp:myvCardTemp];
    } else {
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:[self createDefaultUservCard]];
        newvCardTemp.photo = UIImageJPEGRepresentation(newIcon, 0.6);
        [self.xmppvCardTempModel updateMyvCardTemp:newvCardTemp];
    }
    callBack(nil);
#endif
#if 0
    /*
     //vCard数据
     <vCard xmlns="vcard-temp"><PHOTO><TYPE>image/jpeg</TYPE><BINVAL>PHOTO_DATA</BINVAL></PHOTO><NICKNAME>hello_nick</NICKNAME></vCard>
     */
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns: @"vcard-temp"];
    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
    NSData *dataFromImage = UIImageJPEGRepresentation(newIcon, 0.7f);
    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL" stringValue:[dataFromImage xmpp_base64Encoded]];
    [photoXML addChild:typeXML];
    [photoXML addChild:binvalXML];
    [vCardXML addChild:photoXML];
    XMPPvCardTemp *myvCardTemp = [self.xmppvCardTempModel myvCardTemp];
    if (myvCardTemp) {
        [myvCardTemp setPhoto:dataFromImage];
        [self.xmppvCardTempModel updateMyvCardTemp:myvCardTemp];
    } else {
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
        [newvCardTemp setNickname:@"hello_nick"];
        [self.xmppvCardTempModel updateMyvCardTemp:newvCardTemp];
    }
    
    //保存回调
    if (callBack) {
        self.updateIconCallBack = callBack;
    }
#endif
}

//更新最后在线日期
- (void)updateLastLoginDate
{
    XMPPvCardTemp *myvCardTemp = [self.xmppvCardTempModel myvCardTemp];
    if (myvCardTemp) {
        myvCardTemp.bday = [NSDate getCurrentDateTime];
        [self.xmppvCardTempModel updateMyvCardTemp:myvCardTemp];
    } else {
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:[self createDefaultUservCard]];
        newvCardTemp.bday = [NSDate getCurrentDateTime];
        [self.xmppvCardTempModel updateMyvCardTemp:newvCardTemp];
    }
}

//****************************************************
//                  数据封装
//****************************************************
#pragma mark - 封装JID
- (BOOL)setJIDByCount:(NSString *)count
{
    NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", count, _xmppStream.myJID.domain];
    [_xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    
    return YES;
}

//****************************************************
//                 生成默认的vCard
//****************************************************
#pragma mark - 生成默认的vCard
- (XMPPvCardTemp *)createDefaultUservCard
{
    //xml封装
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns: @"vcard-temp"];
    //封装头像
    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
    NSData *dataFromImage = UIImageJPEGRepresentation([UIImage imageNamed:@"default_regist_icon"], 0.6f);
    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL" stringValue:[dataFromImage xmpp_base64Encoded]];
    [photoXML addChild:typeXML];
    [photoXML addChild:binvalXML];
    [vCardXML addChild:photoXML];
    //创建myvCard
    XMPPvCardTemp *myvCard = [XMPPvCardTemp vCardTempFromElement:vCardXML];
    
    myvCard.nickname = _xmppStream.myJID.user;
    myvCard.emailAddresses = @[@"default@example.com"];
    myvCard.middleName = [NSString stringWithFormat:@"%@",[NSDate getCurrentDateTime]];
    myvCard.role = @"default";
    myvCard.jid = _xmppStream.myJID;
    myvCard.title = @"这个家伙很懒，什么也没写";
    myvCard.addresses = @[@"default"];
    myvCard.formattedName = _xmppStream.myJID.domain;
    myvCard.familyName = @"广州";
    myvCard.givenName = @"晴";
    
    /*
        <vCard xmlns="vcard-temp">
            <PHOTO>
                <TYPE>image/jpeg</TYPE>
                <BINVAL>/9j/4AAQSkZJRgABAQEASABIAAD/</BINVAL>
            </PHOTO>
            <NICKNAME>simular5s</NICKNAME>
            <N>
                <MIDDLE>2014-11-09 22:47:50 +0000</MIDDLE>
                <FAMILY>??</FAMILY>
                <GIVEN>?</GIVEN>
            </N>
            <ROLE>default</ROLE>
            <JABBERID>simular5s@ysmeng.local</JABBERID>
            <TITLE>????????????</TITLE>
            <FN>ysmeng.local</FN>
     </vCard>
     */
    
    return myvCard;
}

//****************************************************
//                  自定义NSError
//****************************************************
#pragma mark - 自定义NSError
- (NSError *)customConnectedFailError
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"xmpp服务器连接失败"                                                                      forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:MHPersonHeaderInfoAnalyzeFail userInfo:userInfo];
    
    return aError;
}

//******************************************
//      获取当前账号/好友vCard
//******************************************
#pragma mark - 获取当前账号/好友vCard
- (BOOL)getSelfvCardMessage:(BLOCK_vCARDMODEL_ACTION)callBack
{
    //通过vCardTempStorage获取
#if 1
    XMPPvCardTemp *myvCard = [_xmppvCardStorage myvCardTempForXMPPStream:_xmppStream];
    [self getFriendsvCardWithJID:[NSString stringWithFormat:@"%@@%@",myvCard.jid.user,myvCard.jid.domain] andCallBack:^(YSMvCardDataModel *model) {
        if (model) {
            callBack(model);
        }
    }];
#endif
    
#if 0
    YSMvCardDataModel *model = [[YSMvCardDataModel alloc] init];
    model.nickName = [myvCard nickname];
    model.userName = _userName;
    NSData *imageData = [myvCard photo];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    model.icon = iconImage;
    model.jidString = [NSString stringWithFormat:@"%@@%@",myvCard.jid.user,myvCard.jid.domain];
    model.domain = myvCard.jid.domain;
    model.shareAbout = myvCard.title;
    model.city = myvCard.familyName;
    model.weather = myvCard.givenName;
    model.lastLoginTime = myvCard.middleName;
    callBack(model);
#endif
    return YES;
}

- (BOOL)getFriendsvCardWithJID:(NSString *)jidString andCallBack:(BLOCK_vCARDMODEL_ACTION)callBack
{
#if 0
    XMPPvCardTemp *myvCard = [_xmppvCardStorage vCardTempForJID:[XMPPJID jidWithString:jidString] xmppStream:_xmppStream];
    YSMvCardDataModel *model = [[YSMvCardDataModel alloc] init];
    model.nickName = [myvCard nickname];
    model.userName = _userName;
    NSData *imageData = [myvCard photo];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    model.icon = iconImage;
    model.jidString = [NSString stringWithFormat:@"%@@%@",myvCard.jid.user,myvCard.jid.domain];
    model.domain = myvCard.jid.domain;
    model.shareAbout = myvCard.title;
    model.city = myvCard.familyName;
    model.weather = myvCard.givenName;
    model.lastLoginTime = myvCard.middleName;
    callBack(model);
#endif
#if 1
    //发送查询vCard的IQ
    XMPPIQ *xmPPIQ = [[XMPPIQ alloc] initWithType:@"get"];
    [xmPPIQ addAttributeWithName:@"to" stringValue:jidString];
    [xmPPIQ addAttributeWithName:@"id" stringValue:@"get_famileis_vCard"];
    NSXMLElement *vElement = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    [xmPPIQ addChild:vElement];
    //    通过xmppStream发送请求，重新下载vcard：
    [_xmppStream sendElement:xmPPIQ];
    //保存回调
    if (callBack) {
        [self.getSelfvCardCallBackDict setObject:[callBack copy] forKey:jidString];
    }
#endif
    return YES;
}

@end
