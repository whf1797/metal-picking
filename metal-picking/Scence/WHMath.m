//
//  WHMath.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "WHMath.h"

@implementation WHMath
+(simd_float4)create_float4x4Withhue:(float)hue
                       andsaturation:(float)saturation
                       andbrightness:(float)brightness{
    float c = brightness * saturation;
    float x = c * (1 - fabsf(fmodf(hue * 6, 2) - 1));
    float m = brightness - saturation;
    float r = 0;
    float g = 0;
    float b = 0;
    if (hue < 0.16667) {
        r = c; g = x; b = 0;
    } else if (hue < 0.33333){
        r = x; g = c; b = 0;
    } else if (hue < 0.5) {
        r = 0; g = c; b = x;
    } else if (hue < 0.66667) {
        r = 0; g = x; b = c;
    } else if (hue < 0.83333) {
        r = x; g = 0; b = c;
    } else if (hue <= 1.0) {
        r = c; g = 0; b = x;
    }
    r += m; g += m; b += m;
    return simd_make_float4(r, g, b, 1);
}

+(simd_float4x4)create_float4x4axis:(simd_float3)axis
                            andangle:(simd_float1)angle{
    simd_float3 unitAxis = simd_normalize(axis);
    simd_float1 ct = cosf(angle);
    simd_float1 st = sinf(angle);
    simd_float1 ci = 1 - ct;
    simd_float1 x = unitAxis.x;
    simd_float1 y = unitAxis.y;
    simd_float1 z = unitAxis.z;
    
    return simd_matrix_from_rows(simd_make_float4(ct+x*x*ci,    y*x*ci+z*st, z*x*ci-y*st, 0),
                                 simd_make_float4(x*y*ci-z*st,  ct+y*y*ci,   z*y*ci+x*st, 0),
                                 simd_make_float4(x*z*ci+y*st,  y*z*ci-x*st, ct+z*z*ci, 0),
                                 simd_make_float4(                  0,                   0,                   0, 1));
    
}

+(simd_float4x4)create_floatStranslation:(simd_float3)v
{
    simd_float4x4 res = simd_matrix(simd_make_float4(1, 0, 0, 0),
                                    simd_make_float4(0, 1, 0, 0),
                                    simd_make_float4(0, 0, 1, 0),
                                    simd_make_float4(v.x, v.y, v.z, 1));
//    simd_matrix(<#simd_float4 col0#>, <#simd_float4 col1#>, <#simd_float4 col2#>, <#simd_float4 col3#>)
    return res;
}



+(simd_float4x4)create_floatfovy:(simd_float1)fovy
                  andaspectRatio:(simd_float1)aspectRatio
                        andnearZ:(simd_float1)nearZ
                         andfarZ:(simd_float1)farZ{
    simd_float1 ys = 1 / tanf(fovy * 0.5);
    simd_float1 xs = farZ / aspectRatio;
    simd_float1 zs = farZ / (nearZ - farZ);
    return simd_matrix(simd_make_float4(xs, 0, 0, 0),
                       simd_make_float4(0, ys, 0, 0),
                       simd_make_float4(0, 0, zs, -1),
                       simd_make_float4(0, 0, zs*nearZ, 0));
}
//
+(simd_float1)radians_from_degress:(simd_float1)degress{
    return (degress / 180) * 3.1415826;
}







@end
