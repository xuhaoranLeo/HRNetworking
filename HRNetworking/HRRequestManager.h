//
//  HRRequestManager.h
//  HRNetworkingDemo
//
//  Created by 许昊然 on 16/7/3.
//  Copyright © 2016年 许昊然. All rights reserved.
//
//  此类为所有网络请求的父类，每一个接口都继承于此并设置具体的请求配置。
//  缓存时间为0或者负数时不进行数据请求的本地存储，否则根据具体设置值进行缓存。

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger , HRRequestMethod) {
    HRRequestMethodGet = 0,
    HRRequestMethodPost,
};

typedef void(^HandleData)(id handleData);
typedef void(^ErrorInfo)(NSError *error);

typedef void (^AFConstructingBlock)(id <AFMultipartFormData> formData);

@interface HRRequestManager : NSObject
/**
 *  请求方法，默认GET请求
 */
@property (nonatomic, assign) HRRequestMethod method;
/**
 *  请求名称，用于输出信息，默认为子类接口的类名
 */
@property (nonatomic, strong) NSString *requestName;
/**
 *  主地址，设置默认值
 */
@property (nonatomic, strong) NSString *baseUrl;
/**
 *  子地址，无默认值
 */
@property (nonatomic, strong) NSString *pathUrl;
/**
 *  参数
 */
@property (nonatomic, strong) NSDictionary *params;
/**
 *  请求头，有默认值
 */
@property (nonatomic, strong) NSDictionary *headers;
/**
 *  上传数据的结构
 */
@property (nonatomic, copy) AFConstructingBlock constructing;
/**
 *  数据缓存时间，默认缓存时间0
 */
@property (nonatomic, assign) float cacheValidTime;
/**
 *  禁止缓存，默认不禁止，一般用在上拉加载
 */
@property (nonatomic, assign) BOOL banCache;
/**
 *  禁止加载的弹窗，默认不禁止
 */
@property (nonatomic, assign) BOOL banLoadingHUD;
/**
 *  请求成功后保存值
 */
@property (nonatomic, strong) NSDictionary *responseDic;
/**
 *  发起请求
 *
 *  @param handle    请求后的数据
 *  @param errorInfo 错误信息
 */
- (void)start:(HandleData)handle error:(ErrorInfo)errorInfo;
/**
 *  停止当前请求
 */
- (void)stop;
@end
