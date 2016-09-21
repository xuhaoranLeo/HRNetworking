//
//  HRHttpRequestGenerator.m
//  HRNetworkingDemo
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRHttpRequestGenerator.h"
#import "HRHttpRequestProxy.h"

@implementation HRHttpRequestGenerator

#pragma mark - public method
+ (instancetype)sharedGenerator {
    static id sharedGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGenerator = [[self alloc] init];
    });
    return sharedGenerator;
}

+ (NSURLSessionDataTask *)callRequest:(HRRequestManager *)manager result:(HRRequestResult)result {
    HRHttpRequestGenerator *generator = [HRHttpRequestGenerator sharedGenerator];
    // header
    NSDictionary *header = manager.headers;
    NSString *URL = [NSString stringWithFormat:@"%@%@", manager.baseUrl, manager.pathUrl];
    switch (manager.method) {
        case HRRequestMethodGet: {
            return [HRHttpRequestProxy callGETRequestWithURL:URL params:manager.params success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject)  {
                result(responseObject, nil);
                // 格式化输出
                [generator requestDataPrintWithName:manager.requestName method:@"GET" url:URL params:manager.params header:header response:responseObject error:nil];
            } failure:^(NSURLSessionTask * _Nonnull task, id  _Nonnull error) {
                result(nil, error);
                [generator requestDataPrintWithName:manager.requestName method:@"GET" url:URL params:manager.params header:header response:nil error:error];
            } header:header];
        }
            break;
        case HRRequestMethodPost: {
            if (manager.constructing) {
                // 上传
                return [HRHttpRequestProxy uploadFileWithURL:URL params:manager.params constructingBodyWithBlock:manager.constructing success:^(NSURLSessionTask *task, id responseObject) {
                    result(responseObject, nil);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:header response:responseObject error:nil];
                } failure:^(NSURLSessionTask *task, id error) {
                    result(nil, error);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:header response:nil error:error];
                } header:header];
            } else {
                return [HRHttpRequestProxy callPOSTRequestWithURL:URL params:manager.params success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
                    result(responseObject, nil);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:header response:responseObject error:nil];
                } failure:^(NSURLSessionTask * _Nonnull task, id  _Nonnull error) {
                    result(nil, error);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:header response:nil error:error];
                } header:header];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark print format
/**
 *  格式化输出请求
 *
 *  @param name     名称
 *  @param url      地址
 *  @param params   参数
 *  @param header   头
 *  @param response 返回值
 *  @param error    错误信息
 */
- (void)requestDataPrintWithName:(NSString *)name method:(NSString *)method url:(NSString *)url params:(NSDictionary *)params header:(NSDictionary *)header response:(NSDictionary *)response error:(NSError *)error {
    NSMutableString *printStr = [NSMutableString stringWithFormat:@"\n***【%@】【%@】***\n\n【URL】 %@\n\n【Params】\n", method, name, url];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *temp = [NSString stringWithFormat:@"    %@: %@\n", key, obj];
        [printStr appendString:temp];
    }];
    [printStr appendString:@"\n【Header】\n"];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *temp = [NSString stringWithFormat:@"    %@: %@\n", key, obj];
        [printStr appendString:temp];
    }];
    [printStr appendFormat:@"\n【Response】\n%@\n\n【Error】\n%@\n******", [response description], error];
    NSLog(@"%@", printStr);
}


@end
