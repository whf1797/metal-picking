//
//  BoundingSphere.h
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import "Ray.h"
NS_ASSUME_NONNULL_BEGIN

@interface BoundingSphere : NSObject
@property (nonatomic, assign) simd_float3 center;
@property (nonatomic, assign) simd_float1 radius;

-(instancetype)initWith:(simd_float3)center
                    and:(simd_float1)radius;
-(simd_float4)intersect:(Ray *)ray;
@end

NS_ASSUME_NONNULL_END
