//
//  Scene.h
//  metal-picking
//
//  Created by MacBook on 2019/4/2.
//  Copyright © 2019 王洪飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HitResult.h"
#import "Node.h"
#import "Ray.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scene : NSObject
@property (nonatomic, strong) Node *rootNode;
@end

NS_ASSUME_NONNULL_END
