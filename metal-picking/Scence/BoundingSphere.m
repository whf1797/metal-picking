//
//  BoundingSphere.m
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "BoundingSphere.h"

@implementation BoundingSphere

-(instancetype)initWith:(simd_float3)center
                    and:(simd_float1)radius {
    if (self = [super init]) {
        self.center = center;
        self.radius = radius;
    }
    return self;
}

-(simd_float4)intersect:(Ray *)ray{
    simd_float1 t0,t1;
    simd_float1 radius2 = _radius * _radius;
    if (radius2 == 0) {
        return simd_make_float4(0);
    }
    simd_float3 L = _center - ray.origin;
    simd_float1 tca = simd_dot(L, ray.direction);
    
    simd_float1 d2 = simd_dot(L, L) - tca*tca;
    if (d2 > radius2) {
        return simd_make_float4(0);
    }
    
    simd_float1 thc = sqrt(radius2 - d2);
    t0 = tca - thc;
    t1 = tca + thc;
    if (t0 > t1) {
  // ===============
    }
    if (t0 < 0) {
        t0 = t1;
        if (t0 < 0) {
            return simd_make_float4(0);
        }
    }
    return simd_make_float4(ray.origin+ray.direction*t0, 1);
}

@end
