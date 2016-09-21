//
//  HRRequestManager.m
//  HRNetworkingDemo
//
//  Created by 许昊然 on 16/7/3.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRRequestManager.h"
#import "HRHttpRequestGenerator.h"

@interface HRRequestManager ()
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation HRRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)start:(HandleData)handle error:(ErrorInfo)errorInfo {
    if (!self.banLoadingHUD) {
       // [HRHUDManager showLoadingAlert];
    }
    __weak typeof(self) weakSelf = self;
    self.task = [HRHttpRequestGenerator callRequest:self result:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
          //  [HRHUDManager dismissAlert];
            if (handle) {
                weakSelf.responseDic = responseObject;
                handle(responseObject);
                if ([responseObject[@"code"] integerValue] != 1) {
                //    [HRHUDManager showBriefAlert:responseObject[@"msg"]];
                }
            }
        } else {
           // [HRHUDManager showBriefAlert:@"网络连接失败"];
            if (errorInfo) {
                errorInfo(error);
            }
        }
    }];
}

- (void)stop {
    [self.task cancel];
}

- (HRRequestMethod)method {
    return HRRequestMethodGet;
}

- (NSString *)requestName {
    return [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
}

- (NSString *)baseUrl {
    //return kBaseAPI;
    return @"";
}

- (NSString *)pathUrl {
    return @"";
}

- (NSDictionary *)params {
    return @{};
}

- (NSDictionary *)headers {
    NSDictionary *dic = @{/*@"CUSTOM_ID":[[GlobalSetting sharedSetting] user].u_id ?:@"",
                          @"ACCESS_TOKEN":[[GlobalSetting sharedSetting] token] ?:@"",
                          @"DEVICE_ID":[[GlobalSetting sharedSetting] device_id] ?:@"",
                          @"SOURCE_TYPE":@"iPhone",
                          @"VERSON":[[GlobalSetting sharedSetting] version]*/};
    NSString *headerStr = @"";
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        headerStr = [headerStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
        if (![key isEqualToString:dic.allKeys.lastObject]) {
            headerStr = [headerStr stringByAppendingString:@";"];
        }
    }
    return @{@"X-FiberHome-Client":headerStr};
}

- (AFConstructingBlock)constructing {
    return nil;
}

- (float)cacheValidTime {
    return -1;
}

- (NSDictionary *)responseDic {
    return _responseDic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.method) forKey:@"method"];
    [dic setValue:self.requestName forKey:@"request_name"];
    [dic setValue:self.baseUrl forKey:@"base_url"];
    [dic setValue:self.pathUrl forKey:@"path_url"];
    [dic setValue:self.params forKey:@"params"];
    [dic setValue:@(self.cacheValidTime) forKey:@"cache_time"];
    [dic setValue:[NSString stringWithFormat:@"%@", self.banCache?@"YES":@"NO"] forKey:@"cache_ban"];
    return [NSString stringWithFormat:@"%@", dic];
}

@end
