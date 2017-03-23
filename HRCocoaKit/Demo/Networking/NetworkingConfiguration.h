//
//  NetworkingConfiguration.h
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/23.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#ifndef NetworkingConfiguration_h
#define NetworkingConfiguration_h

#ifdef DEBUG
//#define kReleaseEnvironment // 内外网的开关
#ifdef kReleaseEnvironment
/* ----------------测试外网接口---------------- */
#define kBaseAPI        @"http://221.226.176.34:6789"
#else
/* ----------------测试内网接口---------------- */
#define kBaseAPI        @"http://172.16.36.199:6080"
#endif

#else
/* ----------------正式发布接口---------------- */
#define kBaseAPI        @"http://yl.fiberhomecloudnj.com:6789"
#endif

#endif
