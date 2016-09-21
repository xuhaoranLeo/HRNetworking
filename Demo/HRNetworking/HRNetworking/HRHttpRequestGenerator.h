//
//  HRHttpRequestGenerator.h
//  HRNetworkingDemo
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRRequestManager.h"

typedef void(^HRRequestResult)(NSDictionary *responseObject, NSError *error);

@interface HRHttpRequestGenerator : NSObject
/**
 *  发起请求
 *
 *  @param manager API模型
 *  @param result  请求结果
 */
+ (NSURLSessionDataTask *)callRequest:(HRRequestManager *)manager result:(HRRequestResult)result;
@end
