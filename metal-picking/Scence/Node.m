//
//  Node.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Node.h"




@implementation Meterial

-(instancetype)init{
    if (self = [super init]) {
        self.color = simd_make_float4(1);
        self.hightlighted = false;
    
    }
    return self;
}

@end

@interface Node()

@end

@implementation Node

-(instancetype)init{
    if (self = [super init]) {
        if (_parent) {
            _worldTransform = simd_mul(_parent.worldTransform, _transform);
        } else {
            _worldTransform = _transform;
        }
        
        _boundingSphere = [[BoundingSphere alloc] initWith:simd_make_float3(0, 0, 0) and:0];
        _children   = [[NSMutableArray alloc] initWithCapacity:1];
        _transform = matrix_identity_float4x4;
    }
    return self;
}

-(simd_float4x4)worldTransform {
    if (_parent) {
        _worldTransform = simd_mul(_parent.worldTransform, _transform);
    } else {
        _worldTransform = _transform;
    }
    return _worldTransform;
}


-(void)addChildnode:(Node *)node {
    if (node.parent != nil) {
        [node removeFromParent];
    }
    [_children addObject:node];
}

-(void)removeChildNode:(Node *)node{
    [_children removeObject:node];
}

-(void)removeFromParent{
    if (_parent) {
        [_parent removeChildNode:self];
    }
}

-(HitResult *)hitTest:(Ray *)ray{
    simd_float4x4 modelToWorld = _worldTransform;
    simd_float4x4 inverse =  simd_inverse(modelToWorld);
    simd_float3 originT = simd_mul(modelToWorld, simd_make_float4(ray.origin, 1)).xyz;
    simd_float3 directionT  = simd_mul(modelToWorld, simd_make_float4(ray.direction,0)).xyz;
    Ray *localRay = [[Ray alloc] initWith:originT and:directionT];
    
//    _boundingSphere
    
    HitResult *nearrest;
    simd_float4 modelPoint = [_boundingSphere intersect:localRay];
    simd_float4 worldPoint = simd_mul(modelToWorld, modelPoint);
    simd_float1 worldParameter = [ray interpolate:worldPoint];
    
    HitResult *nearestChildHit;
    for (Node *child in _children) {
       HitResult *childHit = [child hitTest:ray];
        if (childHit) {
            HitResult *nearestActualChildHit = nearestChildHit;
            // ============
            if (childHit.parameter < nearestActualChildHit.parameter) {
                nearestChildHit = childHit;
            }
        } else{
            nearestChildHit = childHit;
        }
    }
    
    HitResult *nearestActualChildHit = nearestChildHit;
    if (nearestActualChildHit) {
        HitResult* nearestActual = nearrest;
        if (nearestActual) {
            if (nearestActualChildHit.parameter < nearestActual.parameter) {
                return nearestActualChildHit;
            }
        } else {
            return nearestActualChildHit;
        }
    }
    
    return nearrest;
}


@end
