//
//  Scene.m
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import "Scene.h"
#import "HitResult.h"

@interface Scene()

@end

@implementation Scene

-(instancetype)init{
    if (self = [super init]) {
        _rootNode = [Node new];
    }
    return self;
}

@end
