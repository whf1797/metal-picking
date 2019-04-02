//
//  Ray.h
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ray : NSObject
@property(nonatomic, assign) simd_float3 origin;
@property(nonatomic, assign) simd_float3 direction;
-(instancetype)initWith:(simd_float3)origin
                    and:(simd_float3)direction;
-(simd_float1)interpolate:(simd_float4)point;
-(simd_float4)extrapolate:(simd_float1)parameter;
@end

NS_ASSUME_NONNULL_END
