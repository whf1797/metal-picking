//
//  Ray.m
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Ray.h"

@interface Ray()

@end

@implementation Ray

-(instancetype)initWith:(simd_float3)origin
                    and:(simd_float3)direction
{
    if (self = [super init]) {
        self.origin = origin;
        self.direction = direction;
    }
    return self;
}

-(simd_float1)interpolate:(simd_float4)point{
    return simd_length(point.xyz - self.origin) / simd_length(self.direction);
}

-(simd_float4)extrapolate:(simd_float1)parameter {
    return simd_make_float4(_origin+parameter*_direction, 1);
}

@end
