//
//  Node.h
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "Camera.h"
#import "BoundingSphere.h"
#import "Ray.h"
#import "HitResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface Meterial : NSObject
@property(nonatomic, assign)simd_float4 color;
@property(nonatomic, assign)BOOL hightlighted;

@end

@interface Node : NSObject
@property(nonatomic, strong)Camera* camera;
@property (nonatomic, strong) Meterial *meterial;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, weak) Node *   parent;
@property(nonatomic, strong)NSMutableArray <Node*> * children;

@property (nonatomic, strong) MTKMesh *mesh;

@property (nonatomic, assign) simd_float4x4 transform;
@property (nonatomic, assign) simd_float4x4 worldTransform;
@property (nonatomic, strong) BoundingSphere *boundingSphere;

-(void)addChildnode:(Node *)node ;
@end




NS_ASSUME_NONNULL_END
