//
//  NSMutableArray+Safe.m
//  NSProxyDemo
//
//  Created by Weixu on 16/5/19.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Safe)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safeRemoveObjectAtIndex:)];
        [obj swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safeReplaceObjectAtIndex:withObject:)];
    });
}

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self safeAddObject:anObject];
    }
}


- (void)safeInsertObject:(id)anObject atIndex:(NSInteger)index
{
    if (anObject) {
        if ([self count]>=index) {
            [self safeInsertObject:anObject atIndex:index];
        }
        else{
             NSLog(@"index is beyond bounds ");
        }

    }
    else{
        NSLog(@"anObject is nil Or null ");
    }

}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index<[self count]){
        return [self safeObjectAtIndex:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}

- (void)safeRemoveObjectAtIndex:(NSInteger)index{
    if (index <[self count]) {
        [self safeRemoveObjectAtIndex:index];
    }
    else{
        NSLog(@"index is begong bounds");
    }
    
}


- (void)safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if (index < [self count]) {
        if (anObject) {
            [self safeReplaceObjectAtIndex:index withObject:anObject];
        }
        else{
            NSLog(@"safeReplaceObjectAtIndex anObject is nil");
        }
    }
    else{
        NSLog(@"safeReplaceObject");
    }
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
