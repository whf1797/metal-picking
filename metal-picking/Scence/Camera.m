//
//  Camera.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Camera.h"


@interface Camera()

@end

@implementation Camera
-(instancetype)init{
    if (self = [super init]) {
        _fieldOfView = 20;
        _nearZ = 0.1;
        _farZ = 100.0;
    
    }
    return self;
}

//-(simd_float4x4)projectionMatrix:(float)aspectRatio {
//    return float4x4(perspectiveProjectionRHFovY: radians_from_degrees(fieldOfView),
//                    aspectRatio: aspectRatio,
//                    nearZ: nearZ,
//                    farZ: farZ)
//}

@end
