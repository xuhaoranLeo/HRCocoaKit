//
//  HRBatchRequestManager.h

//
//  Created by 许昊然 on 16/7/17.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRRequestManager.h"

typedef void(^RequestArray)(NSArray *requestArray);
typedef void(^ErrorManager)(NSError *error, HRRequestManager *manager);

@interface HRBatchRequestManager : NSObject
- (instancetype)initWithRequestArray:(NSArray <HRRequestManager *> *)requestArray;
- (void)start:(RequestArray)complete failure:(ErrorManager)info;
- (void)stop;
@end
