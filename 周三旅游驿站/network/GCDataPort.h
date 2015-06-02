//
//  GCDataPort.h
//  机场管家
//  网络数据请求
//  Created by apple on 14/9/22.
//  Copyright (c) 2014年 zhou. All rights reserved.
//

/**********************
 ┏┓　　　┏┓
 ┏┛┻━━━━━┛┻┓
 ┃         ┃
 ┃    ━    ┃
 ┃　┳┛　┗┳　┃
 ┃         ┃
 ┃    ┻    ┃
 ┃         ┃
 ┗━┓　　　┏━┛
 ┃　　　┃ 神兽保佑
 ┃　　　┃ 代码无BUG！
 ┃　　　┗━━━┓
 ┃         ┣┓
 ┃         ┏┛
 ┗┓┓┏━━━┳┓┏┛
 ┃┫┫   ┃┫┫
 ┗┻┛   ┗┻┛
 **********************/
#import <Foundation/Foundation.h>

#define CREDITHOST @"http://192.168.7.222/api.ashx"
//#define CREDITHOST @"http://payapi.jsjinfo.cn/"

@protocol GCDataPortDelegate <NSObject>

/*
 网络请求，返回数据代理
 */
-(void)pbResponseSuccess:(NSMutableData *)PBResolveData requestTag:(NSInteger)requestTag;

///*
// 网络请求，返回空
// */
//-(void)responseNil;

/*
 网络错误（不通）or 返回数据失败
 */
-(void)pbResponseFail:(NSInteger)requestTag;

@end

@interface GCDataPort : NSObject<NSXMLParserDelegate>{
    NSMutableData *_webData;//网络返回数据
    id<GCDataPortDelegate> _delegate;//网络请求代理
    NSURLConnection *_theConnection;
    int _returnCode;//返回码
    int externalTimelong;//网络连接时长
}

@property(nonatomic,retain) id<GCDataPortDelegate> delegate;
@property (nonatomic,assign)BOOL isRunning;
@property (nonatomic,assign)NSInteger requestTag;

-(instancetype)initWithRequestTag:(NSInteger)requestTag;

/*
  post 请求 probuff
 sUrl:请求地址
 sData:发送数据
 */
-(void)doPBConnectionPostUrl:(NSString *)sUrl ForData:(NSData *)sData Method:(NSString *)methodStr;

/*
 post 请求 probuff ，
 sUrl:请求地址
 sData:发送数据
 outTime:请求超时时间
 */
-(void)doPBConnectionPostUrl:(NSString *)sUrl ForData:(NSData *)sData Method:(NSString *)methodStr outTime:(int)outTime;

/*
 post 请求 json
 serverUrl ：请求地址
 message : 请求数据
 outTime:请求超时时间
 */
-(void)doConnectionUrlForPost:(NSString *)serverUrl postMessage:(NSString *)message outTime:(int)outTime;

/*
 post 请求 json
 serverUrl ：请求地址
 message : 请求数据
 */
-(void)doConnectionUrlForPost:(NSString *)serverUrl postMessage:(NSString *)message;

/*
 停止网络连接
 */
-(void)stopPBConnection;

@end