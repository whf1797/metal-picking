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

@interface ViewController ()<MTKViewDelegate>
{
    id <MTLDevice> device;
    id <MTLCommandQueue> commandQueue;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size{
    
}

-(void)drawInMTKView:(MTKView *)view{
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
