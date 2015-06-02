//
//  GCDataPort.m
//  机场管家
//
//  Created by apple on 14/9/22.
//  Copyright (c) 2014年 zhou. All rights reserved.
//

#import "GCDataPort.h"

@implementation GCDataPort

@synthesize delegate=_delegate;
@synthesize isRunning;

#pragma mark - 构造方法 -

-(instancetype)initWithRequestTag:(NSInteger)requestT{
    if (self = [super init]) {
        _requestTag = requestT;
    }
    return self;
}

#pragma mark - 外部方法 -

/*
 post 请求 probuff
 sUrl:请求地址
 sData:发送数据
 */
-(void)doPBConnectionPostUrl:(NSString *)sUrl ForData:(NSData *)sData Method:(NSString *)methodStr{
    
    NSURL *url=[NSURL URLWithString:sUrl];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue: @"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    [theRequest addValue:methodStr forHTTPHeaderField:@"MethodName"];
    

    [theRequest setHTTPBody:sData];
    
    if (externalTimelong!=0) {
        [theRequest setTimeoutInterval:externalTimelong];
    }
    else{
        [theRequest setTimeoutInterval:60];
    }
    _theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (_theConnection) {
        isRunning = YES;
        _webData=[NSMutableData data];
    }
    else{
        isRunning = NO;
        if ([_delegate respondsToSelector:@selector(pbResponseFail:)]) {
            [_delegate pbResponseFail:_requestTag];
        }
    }
}

/*
 post 请求 probuff ，
 sUrl:请求地址
 sData:发送数据
 outTime:请求超时时间
 */
-(void)doPBConnectionPostUrl:(NSString *)sUrl ForData:(NSData *)sData Method:(NSString *)methodStr outTime:(int)outTime{
    externalTimelong = outTime;
    [self doPBConnectionPostUrl:sUrl ForData:sData Method:methodStr];
}

/*
 post 请求 json
 serverUrl ：请求地址
 message : 请求数据
 outTime:请求超时时间
 */

-(void)doConnectionUrlForPost:(NSString *)serverUrl postMessage:(NSString *)message outTime:(int)outTime{
    externalTimelong = outTime;
    [self doConnectionUrlForPost:serverUrl postMessage:message];
}

/*
 post 请求 json
 serverUrl ：请求地址
 message : 请求数据
 */

-(void)doConnectionUrlForPost:(NSString *)serverUrl postMessage:(NSString *)message{
    
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [message dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%i", [postData length]];
    [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:postData];
    
    if (externalTimelong!=0) {
        [theRequest setTimeoutInterval:externalTimelong];
    }else{
        [theRequest setTimeoutInterval:60];
    }
    
    //请求
    _theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    //如果连接已经建好，则初始化data
    if( _theConnection )
    {
        isRunning = YES;
        _webData = [NSMutableData data];
    }
    else
    {
        isRunning = NO;
        if ([_delegate respondsToSelector:@selector(pbResponseFail:)]) {
            [_delegate pbResponseFail:_requestTag];
        }
    }
}

/*
 停止网络连接
 */

-(void)stopPBConnection{
    if (_theConnection !=nil) {
      [_theConnection cancel];
    }
    isRunning = NO;
}

#pragma mark - 网络连接代理 -

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _returnCode=(int)[(NSHTTPURLResponse *)response statusCode];
    [_webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    isRunning = NO;
    if ([_delegate respondsToSelector:@selector(pbResponseFail:)]) {
        [_delegate pbResponseFail:_requestTag];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    isRunning = NO;
    if (_returnCode==404 || _returnCode==500 || _returnCode==403) {
        if ([_delegate respondsToSelector:@selector(pbResponseFail:)]) {
            [_delegate pbResponseFail:_requestTag];
        }
    }
    else{
        NSLog(@"数据:%@",[[NSString alloc] initWithData:_webData encoding:NSUTF8StringEncoding]);
        if (_webData == nil || _webData.length == 0) {
            if ([_delegate respondsToSelector:@selector(pbResponseFail:)]) {
                [_delegate pbResponseFail:_requestTag];
            }
        }
        else{
            if ([_delegate respondsToSelector:@selector(pbResponseSuccess:requestTag:)]) {
                [_delegate pbResponseSuccess:_webData requestTag:_requestTag];
            }
        }
    }
}

@end
