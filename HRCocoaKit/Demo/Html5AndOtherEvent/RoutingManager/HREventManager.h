//
//  HREventManager.h
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

typedef NS_ENUM(NSUInteger, HREventType) {
    HREventTypeLink                     = 10, // 网页
    HREventTypeDetail                   = 100, // 文章详情
    // ...
};

@interface HREventModel : NSObject
@property (nonatomic, assign) HREventType event_type;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *event_link;
@property (nonatomic, strong) NSString *event_title;
@property (nonatomic, strong) NSString *event_content;
@property (nonatomic, strong) NSString *event_image;
@end

@interface HREventManager : NSObject
/**
 *  跳转事件方法
 *
 *  @param event  跳转事件模型
 *  @param parent 跳转的Controller
 */
+ (void)browseEvent:(HREventModel *)event parent:(UIViewController *)parent;
@end
