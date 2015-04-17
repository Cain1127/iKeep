//
//  NSLog_Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_NSLog_Header_h
#define iKeep_NSLog_Header_h

/*数据验证时的打印信息---------*/
#define NSLOG_DATA_ERROR_DEFINE(a,b,c) NSLog(@"数据源有误：%@ : %@ : %@",(a),(b),(c))
#define NSLOG_REQUEST_ERROR_DEFINE(a,b,c) NSLog(@"请求错误：%@ : %@ : %@",(a),(b),(c))
#define NSLOG_XMPP_ERROR_DEFINE(a,b,c) NSLog(@"xmpp服务器连接错误：%@ : %@ : %@",(a),(b),(c))
#define NSLOG_XMPP_SUCCESS_DEFINE(a,b,c) NSLog(@"xmpp服务器连接成功：%@ : %@ : %@",(a),(b),(c))
#define NSLOG_XMPP_REGIST_FAIL(a,b,c,d) NSLog(@"xmpp用户注册失败：%@ : %@ : Error code:%@ Error:%@",(a),(b),(c),(d))
#define NSLOG_XMPP_LOGIN_FAIL(a,b,c,d) NSLog(@"xmpp登录失败：%@ : %@ : Error code:%@ Error:%@",(a),(b),(c),(d))

#endif
