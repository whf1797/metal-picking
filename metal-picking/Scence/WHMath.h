//
//  WHMath.h
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
NS_ASSUME_NONNULL_BEGIN

@interface WHMath : NSObject

+(simd_float1)radians_from_degress:(simd_float1)degress;
+(simd_float4x4)create_floatStranslation:(simd_float3)v;
+(simd_float4x4)create_float4x4axis:(simd_float3)axis
                           andangle:(simd_float1)angle;
+(simd_float4)create_float4x4Withhue:(float)hue
                              andsaturation:(float)saturation
                              andbrightness:(float)brightness;
+(simd_float4x4)create_floatfovy:(simd_float1)fovy
                         andaspectRatio:(simd_float1)aspectRatio
                         andnearZ:(simd_float1)nearZ
                         andfarZ:(simd_float1)farZ;
@end

NS_ASSUME_NONNULL_END
