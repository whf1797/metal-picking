//
//  HitResult.h
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Ray.h"
#import <simd/simd.h>
@class Node;

NS_ASSUME_NONNULL_BEGIN

@interface HitResult : NSObject
@property (nonatomic, strong) Ray *ray;
//@property (nonatomic, strong) Node *node;
@property (nonatomic, strong) Node *node;
@property (nonatomic, assign) simd_float1 parameter;
@property (nonatomic, assign) simd_float4 *intersectionPoint;
@end

NS_ASSUME_NONNULL_END
