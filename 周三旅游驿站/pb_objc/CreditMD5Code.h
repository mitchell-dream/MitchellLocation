//
//  CreditMD5Code.h
//  JinSeShiJi
//
//  Created by apple on 14-7-7.
//
//

#import <Foundation/Foundation.h>

#define DEF_MD5_KEY @"qweasdzxc123!@#$"

@interface CreditMD5Code : NSObject

+(NSString *)CreditToMD5:(NSString *)num;

@end
