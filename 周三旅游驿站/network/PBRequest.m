//
//  PBRequest.m
//  机场管家
//
//  Created by apple on 14/9/23.
//  Copyright (c) 2014年 zhou. All rights reserved.

#import "PBRequest.h"
#import "ENDEcryption.h"
#import "PositionRequest.pb.h"
#import "CreditMD5Code.h"

@implementation PBRequest

#pragma mark - 上传经纬度 -

-(NSMutableArray *)uploadLocationWithLocationList:(NSMutableArray *)locationList{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSString *methodStr = @"_SendPosition"; // 接口名称
    Position_Request_Builder *modify = [Position_Request builder];
    
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [locationList count]; i++) {
        Positions_Builder *temp = [Positions builder];
        NSDictionary  *tempDic=[locationList objectAtIndex:i];
        [temp setX:[[tempDic objectForKey:@"longitude"] floatValue]];
        [temp setY:[[tempDic objectForKey:@"latitude"] floatValue]];
        [temp setH:[[tempDic objectForKey:@"altitude"] floatValue]];
        [temp setPtype:1];
        float temPower = [[tempDic objectForKey:@"deviceLevel"] floatValue] *100;
        [temp setPower:temPower];
        
        [temp setCreateTime:[tempDic objectForKey:@"date"]];
        
        Positions *tempTT = [temp build];
        
        [tempList addObject:tempTT];
    }
    
    [modify addAllUpPositions:tempList];
    NSString* identifierNumber = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSString *md5string = [CreditMD5Code CreditToMD5:identifierNumber];
    if (md5string.length >10) {
        md5string = [md5string substringToIndex:10];
    }
    md5string = [NSString stringWithFormat:@"IOS_%@",md5string];
    
    [modify setUindex:md5string];
    
    Position_Request *tempR = [modify build];
    NSData *tempData = [tempR data]; // 数据流
    //    NSData *encryData = [ENDEcryption DESEncrypt:tempData WithKey:S5KEY]; // 加密后的data
    [tempArray addObject:tempData];
    [tempArray addObject:methodStr];
    return tempArray;
}


@end
