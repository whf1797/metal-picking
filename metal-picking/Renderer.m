//
//  Renderer.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Renderer.h"
//#import "Scence"

@interface Renderer ()
{
   id <MTLDepthStencilState> depthStencilState;
}

@property (nonatomic, strong)MTKView *view;
@property (nonatomic, strong)id <MTLDevice> device;
@property (nonatomic, strong)id <MTLRenderPipelineState> renderPipelineState;
//@property (nonatomic, strong)
@property (nonatomic, strong)NSMutableArray <id <MTLBuffer>>* constantBuffers;
@property (nonatomic, assign)int frameIndex;

@end

@implementation Renderer

-(instancetype)initWith:(MTKView *)view and:(MDLVertexDescriptor *)vertexDescriptor
{
    if (self = [super init]) {
        self.device = view.device;
        self.view = view;
        _constantBuffers = [[NSMutableArray alloc] initWithCapacity:1];
        depthStencilState = [self makeDepthStencilState:self.device];
        for (int i = 0; i < MaxInFlightFrameCount; i++) {
           [_constantBuffers addObject:[self.device newBufferWithLength:ConstantBufferLength options:MTLResourceStorageModeShared]];
        }
        _renderPipelineState = [self makeRenderPipelineState:view and:vertexDescriptor];
    }
    return self;
}

-(id <MTLDepthStencilState>)makeDepthStencilState:(id <MTLDevice>)device{
    MTLDepthStencilDescriptor *depthStateDescriptor = [MTLDepthStencilDescriptor new];
    depthStateDescriptor.depthCompareFunction = MTLCompareFunctionLess;
    [depthStateDescriptor setDepthWriteEnabled:YES];
    return [device newDepthStencilStateWithDescriptor:depthStateDescriptor];
}

-(id<MTLRenderPipelineState>)makeRenderPipelineState:(MTKView *)view and:(MDLVertexDescriptor *)vertexDescripitor{
    id <MTLDevice> device = view.device;
    if (device == nil) {
        return nil;
    }
    id<MTLLibrary>library = [device newDefaultLibrary];
    id <MTLFunction>vertexFunc = [library newFunctionWithName:@"vertex_main"];
    id <MTLFunction>fragmentFunc = [library newFunctionWithName:@"fragment_main"];
    MTLVertexDescriptor *mtlVertexDescriptor = MTKMetalVertexDescriptorFromModelIO(vertexDescripitor);
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    
    pipelineDescriptor.vertexFunction = vertexFunc;
    pipelineDescriptor.fragmentFunction = fragmentFunc;
    pipelineDescriptor.vertexDescriptor = mtlVertexDescriptor;
    pipelineDescriptor.sampleCount = view.sampleCount;
    pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;
    pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat;
    
    return [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:nil];;
}


-(void)draw:(Scene *)scence
        and:(Node *)pointOfView
        and:(id<MTLRenderCommandEncoder>)renderCommandEncoder{
    Node *cameraNode = pointOfView;
    Camera *camera = cameraNode.camera;
    if (camera == nil) {
        return;
    }
    
    _frameIndex = (_frameIndex + 1) % MaxInFlightFrameCount;
    [renderCommandEncoder setRenderPipelineState:_renderPipelineState];
    [renderCommandEncoder setDepthStencilState:depthStencilState];
    
    simd_float4x4 viewMatrix = simd_inverse(cameraNode.worldTransform);
    
    NSRect viewpoint = _view.bounds;
    simd_float1 width = viewpoint.size.width;
    simd_float1 height = viewpoint.size.height;
    float aspectRatio = width/height;
    simd_float4x4 projectMatrix = [camera projectionMatrix:aspectRatio];
    simd_float4x4 worldMatrix = matrix_identity_float4x4;
    
    id<MTLBuffer> constantBuffer =  _constantBuffers[_frameIndex];
    [renderCommandEncoder setVertexBuffer:constantBuffer offset:1 atIndex:0];
    simd_float1 constantsOfset = 0;
    
    
}

-(void)draw:(Node *)node
        and:(simd_float4x4)worldTransform
        and:(simd_float4x4)viewMatrix
        and:(simd_float4x4)projectionMatrix
        and:(inout int)constantOffset
        and:(in id <MTLRenderCommandEncoder>)renderCommandEncoder{
    simd_float4x4 worldMatrix = simd_mul( worldTransform , node.transform);

    InstanceConsTants constants = {
        .modelViewProjectionMatrix =  simd_mul(projectionMatrix, viewMatrix),
        .normalMatrix =  simd_mul(viewMatrix , worldMatrix),
        .color =  node.meterial.color
    };
    
    id<MTLBuffer> constantbuffer = _constantBuffers[_frameIndex];
    memcpy(constantbuffer.contents + constantOffset, &constants, sizeof(InstanceConsTants));
    [renderCommandEncoder setVertexBufferOffset:constantOffset atIndex:1];
    
    MTKMesh *mesh = node.mesh;
    if (mesh != nil) {
        [mesh.vertexBuffers enumerateObjectsUsingBlock:^(MTKMeshBuffer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [renderCommandEncoder setVertexBuffer:obj.buffer offset:obj.offset atIndex:idx];
        }];
        
        [mesh.submeshes enumerateObjectsUsingBlock:^(MTKSubmesh * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MTLTriangleFillMode fillMode = node.meterial.hightlighted? MTLTriangleFillModeLines:MTLTriangleFillModeFill;
            [renderCommandEncoder setTriangleFillMode:fillMode];
            [renderCommandEncoder drawIndexedPrimitives:obj.primitiveType indexCount:obj.indexCount indexType:obj.indexType indexBuffer:obj.indexBuffer.buffer indexBufferOffset:obj.indexBuffer.offset];
        }];
    }
    constantOffset+= ConstantAlignment;
    [node.children enumerateObjectsUsingBlock:^(Node * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self draw:obj and:worldTransform and:viewMatrix and:projectionMatrix and:constantOffset and:renderCommandEncoder];
    }];
    
}



@end
