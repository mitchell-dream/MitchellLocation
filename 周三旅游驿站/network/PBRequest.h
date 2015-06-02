//
//  PBRequest.h
//  机场管家
//
//  Created by apple on 14/9/23.
//  Copyright (c) 2014年 zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintObject.h"
#import "TestRequest.pb.h"
#import "TestResponse.pb.h"

@interface PBRequest : NSObject


#define PB_UPLOAD @"http://sczl.jsjinfo.cn"
//#define PB_UPLOAD @"http://192.168.66.14:4466"


#pragma mark - 上传经纬度 -

-(NSMutableArray *)uploadLocationWithLocationList:(NSMutableArray *)locationList;


@end
