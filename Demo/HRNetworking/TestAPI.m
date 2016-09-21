//
//  TestAPI.m
//  HRNetworking
//
//  Created by 许昊然 on 2016/9/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "TestAPI.h"

@implementation TestAPI
{
    NSString *_keyword;
}

- (instancetype)initWithKeyword:(NSString *)keyword {
    self = [super init];
    if (self) {
        _keyword = keyword;
    }
    return self;
}

- (HRRequestMethod)method {
    return HRRequestMethodGet;
}

- (NSString *)baseUrl {
    return @"https://baike.baidu.com";
}

- (NSString *)pathUrl {
    return @"/api/openapi/BaikeLemmaCardApi";
}

- (NSDictionary *)params {
    return @{@"scope":@"103",
             @"format":@"json",
             @"appid":@"379020",
             @"bk_length":@"600",
             @"bk_key":_keyword};
}

@end
