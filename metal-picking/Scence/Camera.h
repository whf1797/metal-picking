//
//  Camera.h
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
NS_ASSUME_NONNULL_BEGIN

@interface Camera : NSObject
@property(nonatomic, assign) float fieldOfView;
@property(nonatomic, assign) float nearZ;
@property(nonatomic, assign) float farZ;
-(simd_float4x4)projectionMatrix:(float)aspectRatio;
@end

NS_ASSUME_NONNULL_END
