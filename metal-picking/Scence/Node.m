//
//  Node.m
//  metal-picking
//
//  Created by 王洪飞 on 2019/4/1.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Node.h"
#import <simd/simd.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface Meterial : NSObject
@property(nonatomic, assign)simd_float4 color;
@property(nonatomic, assign)BOOL hightlighted;

@end

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
@property(nonatomic, strong)NSString *name;
@property(nonatomic, weak) Node *   parent;
@property(nonatomic, strong)NSMutableArray <Node*> * children;

@end

@implementation Node

@end
