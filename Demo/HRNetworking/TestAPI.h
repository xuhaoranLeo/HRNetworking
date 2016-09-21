//
//  TestAPI.h
//  HRNetworking
//
//  Created by 许昊然 on 2016/9/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRRequestManager.h"

@interface TestAPI : HRRequestManager
- (instancetype)initWithKeyword:(NSString *)keyword;
@end
