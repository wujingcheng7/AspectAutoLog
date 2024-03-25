//
//  NSObject+AspectAutoLog.m
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import "NSObject+AspectAutoLog.h"
#import <objc/runtime.h>

@implementation NSObject (AspectAutoLog)

+ (void)aal_methodSwizzleWithOriginal:(SEL)originalSelector
                             swizzled:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL success = class_addMethod(class,
                                   originalSelector,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
