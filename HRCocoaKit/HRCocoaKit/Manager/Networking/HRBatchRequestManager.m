//
//  HRBatchRequestManager.m

//
//  Created by 许昊然 on 16/7/17.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRBatchRequestManager.h"
#import "HRCocoaKit.h"

@interface HRBatchRequestManager ()
@property (nonatomic, strong) NSMutableArray *requestArray;
@end

@implementation HRBatchRequestManager
- (instancetype)initWithRequestArray:(NSArray <HRRequestManager *> *)requestArray {
    self = [super init];
    if (self) {
        if (requestArray.count == 0) {
            return nil;
        }
        self.requestArray = requestArray.mutableCopy;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"batch dealloc");
}

- (void)start:(RequestArray)complete failure:(ErrorManager)info {
    [HRHUDManager showLoadingAlert];
    NSMutableArray *completeHandles = [NSMutableArray array];
    NSMutableArray *completeData = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (HRRequestManager *manager in self.requestArray) {
        [manager start:^(id handleData, BOOL success) {
            if (manager.handle) {
                [completeHandles addObject:manager.handle];
                [completeData addObject:handleData];
            }
            dispatch_group_leave(group);
        } error:^(NSError *error) {
            if (info) {
                info(error, manager);
            }
            [self stop];
        }];
        dispatch_group_enter(group);
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (complete) {
            for (NSInteger i=0; i<completeHandles.count; i++) {
                HandleData handle = [completeHandles objectAtIndex:i];
                id data = [completeData objectAtIndex:i];
                handle(data, YES);
            }
            complete(self.requestArray);
        }
    });
}

- (void)stop {
    [HRHUDManager dismissAlert];
    for (HRRequestManager *manager in self.requestArray) {
        [manager stop];
    }
    [self.requestArray removeAllObjects];
}
@end
