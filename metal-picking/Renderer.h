//
//  Renderer.h
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <simd/simd.h>
#import "Scence/Scene.h"
#import "Scence/Node.h"

typedef struct {
    simd_float4x4   modelViewProjectionMatrix;
    simd_float4x4   normalMatrix;
    simd_float4     color;
}InstanceConsTants;

static int MaxInFlightFrameCount = 3;
static int ConstantBufferLength = 536;
static int ConstantAlignment = 256;



@interface Renderer : NSObject

-(instancetype)initWith:(MTKView *)view and:(MTLVertexDescriptor *)vertexDescriptor;
-(void)draw:(Scene *)scence
        and:(Node *)pointOfView
        and:(id<MTLRenderCommandEncoder>)renderCommandEncoder;

@end


