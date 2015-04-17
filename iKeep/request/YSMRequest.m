//
//  YSMRequest.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMRequest.h"

@implementation YSMRequest

////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                   类方法                                                                                             //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////
+ (void)doSyncRequest:(REQUEST_TYPE)requestType andTag:(NSInteger)tag andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    switch (requestType) {
        case advertMessageRequestType:
        {
            NSURL *url = [NSURL URLWithString:URL_APP_LOAD_AVERT];
            [self doSyncRequest:requestType andURL:url andTag:tag andCallBack:action];
        }
            break;
            
        case advertImageRequestType:
            
            break;
            
        default:
            break;
    }
}

+ (void)doSyncRequest:(REQUEST_TYPE)requestType andURL:(NSURL *)url andTag:(NSInteger)tag andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    action([data copy],error);
}

////////////////////////////////////////////////////////////////////////////
//                                                                                                                                            //
//                                   对象方法                                                                                         //
//                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////



@end
