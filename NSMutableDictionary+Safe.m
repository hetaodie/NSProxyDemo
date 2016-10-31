//
//  NSMutableDictionary+Safe.m
//  NSProxyDemo
//
//  Created by Weixu on 16/5/19.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import <objc/runtime.h>


@implementation NSMutableDictionary (Safe)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safeSetObject:forKey:)];
    });
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey{
    if (anObject) {
        [self safeSetObject:anObject forKey:aKey];
    }
    else{
         NSLog(@"safeSetObject anObject is nil");
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
