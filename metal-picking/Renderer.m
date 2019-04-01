//
//  Renderer.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Renderer.h"

@interface Renderer ()
{
   id <MTLDepthStencilState> depthStencilState;
}

@property (nonatomic, strong)MTKView *view;
@property (nonatomic, strong)id <MTLDevice> device;
@property (nonatomic, strong)id <MTLRenderPipelineState> renderPipelineState;
//@property (nonatomic, strong)
@property (nonatomic, strong)id <MTLBuffer> constantBuffers;
@property (nonatomic, assign)int frameIndex;

@end

@implementation Renderer

-(instancetype)initWith:(MTKView *)view and:(MTLVertexDescriptor *)vertexDescriptor
{
    if (self = [super init]) {
        self.device = view.device;
        self.view = view;
        
//        depthStencilState =
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








@end
