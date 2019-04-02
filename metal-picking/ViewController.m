//
//  ViewController.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "ViewController.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "Renderer.h"
#import "Scence/Scene.h"
#import "Scence/Node.h"
#import <simd/simd.h>
#import "Scence/WHMath.h"

@interface ViewController ()<MTKViewDelegate>
{
    id <MTLDevice> device;
    id <MTLCommandQueue> commandQueue;
    MTKView *mtkView;
    
    Renderer *renderer;
    Scene *scene;
    Node * pointOfview;
    simd_float1 cameraAngle;
    
    MDLVertexDescriptor *vertexDescriptor;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scene = [Scene new];
    mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    self.view = mtkView;
    
    device = MTLCreateSystemDefaultDevice();
    mtkView.device = device;
    commandQueue = device.newCommandQueue;
    
    mtkView.device = device;
    mtkView.delegate = self;
    mtkView.sampleCount = 4;
    mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
    mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
    
    [self updateVertexdescriptor];
    [self makescene];
    renderer = [[Renderer alloc] initWith:mtkView and:vertexDescriptor];
    // Do any additional setup after loading the view.
}

-(void)updateVertexdescriptor{
    vertexDescriptor = [MDLVertexDescriptor new];
    vertexDescriptor.attributes[0].name = MDLVertexAttributePosition;
    vertexDescriptor.attributes[0].format = MDLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.attributes[1].name = MDLVertexAttributeNormal;
    vertexDescriptor.attributes[1].format = MDLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = sizeof(float)*3;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(float) * 6;
}

-(void)makescene{
    float GridSideCount = 1;
    float sphereRadius = 1;
    float spherePadding = 1;
    MTKMeshBufferAllocator *meshAlloctor = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(sphereRadius, sphereRadius, sphereRadius)
                                                    segments:simd_make_uint2(20, 20)
                                               inwardNormals:NO
                                                geometryType:MDLGeometryTypeTriangles
                                                   allocator:meshAlloctor];
    mdlMesh.vertexDescriptor = vertexDescriptor;
    MTKMesh *sphereMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:nil];
    float gridSildLength = (sphereRadius * 2 * GridSideCount) + (spherePadding * (GridSideCount -1));
    
    for (int j = 0; j < GridSideCount; j++) {
        for (int i = 0; i < GridSideCount; i++) {
            Node *node = [Node new];
            node.mesh = sphereMesh;
            simd_float3 position = simd_make_float3(sphereRadius + (i) * (2 * sphereRadius + spherePadding) - ((gridSildLength) / 2),
                                                    sphereRadius + (j) * (2 * sphereRadius + spherePadding) - ((gridSildLength) / 2),
                                                    0);
            NSLog(@"make sence x = %f y = %f z = %f", position.x, position.y, position.z);
            node.transform = [WHMath create_floatStranslation:position];
            node.boundingSphere.radius = sphereRadius;
            [scene.rootNode addChildnode:node];
        }
    }
    Node *cameraNode = [Node new];
    cameraNode.transform = [WHMath create_floatStranslation:simd_make_float3(0, 0, 15)];
    cameraNode.camera = [Camera new];
    pointOfview = cameraNode;
    [scene.rootNode addChildnode:cameraNode];
}

-(void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size{
    
}

-(void)drawInMTKView:(MTKView *)view{
//    cameraAngle+=0.01;
    id <MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    id <MTLRenderCommandEncoder> renderCommandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    //    simd_float1 angle =  ([WHMath create_floatStranslation:simd_make_float3(0, 0, 15)], cameraAngle);
    
    simd_float4x4 tr1 = [WHMath create_float4x4axis:simd_make_float3(0, 1, 0) andangle:cameraAngle];
    simd_float4x4 tr2 = [WHMath create_floatStranslation:simd_make_float3(0, 0, 15)];
    
    pointOfview.transform = simd_mul(tr1,tr2);


    
//    NSLog(@"transfomr = %f", pointOfview.transform);
    [renderer draw:scene and:pointOfview and:renderCommandEncoder];
    [renderCommandEncoder endEncoding];
    if (view.currentDrawable) {
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
