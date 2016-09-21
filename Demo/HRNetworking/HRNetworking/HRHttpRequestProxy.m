//
//  HRHttpRequestProxy.m
//  HRNetworkingDemo
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRHttpRequestProxy.h"
#import "HRRequestManager.h"

#define kTimeoutInterval    10
#define kHTTPsRequest       NO

@interface HRHttpRequestProxy ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation HRHttpRequestProxy

#pragma mark - public method
+ (instancetype)sharedProxy {
    static id sharedProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProxy = [[self alloc] init];
    });
    return sharedProxy;
}

+ (NSURLSessionDataTask *)callGETRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    if (kHTTPsRequest) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

+ (NSURLSessionDataTask *)callPOSTRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    if (kHTTPsRequest) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
            [task cancel];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (NSURLSessionDataTask *)uploadFileWithURL:(NSString *)URL params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval * 3;
    if (kHTTPsRequest) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager POST:URL parameters:params constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}



#pragma mark - private method
- (AFSecurityPolicy *)configSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许无效证书，即自建证书。
    securityPolicy.allowInvalidCertificates = YES;
    /*
     假如证书的域名与你请求的域名不一致，需把该项设置为NO；
     因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；
     如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
     */
    securityPolicy.validatesDomainName = YES;
    // 导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
    return securityPolicy;
}

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 10;
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    }
    return _sessionManager;
}

@end
