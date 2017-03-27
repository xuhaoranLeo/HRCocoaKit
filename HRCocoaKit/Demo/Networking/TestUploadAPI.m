//
//  TestUploadAPI.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "TestUploadAPI.h"
#import "AFURLRequestSerialization.h"

@implementation TestUploadAPI
{
    UIImage *_image;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (HRRequestMethod)method {
    return HRRequestMethodPost;
}

- (NSString *)pathUrl {
    return @"/platform-web/users/modifyUserAvatar";
}

- (AFConstructingBlock)constructing {
    return ^(id <AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.8);
        NSString *serverName = @"Filedata";
        NSString *fileName = @"avatar.jpg";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:serverName fileName:fileName mimeType:type];
    };
}

@end
