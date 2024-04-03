//
//  UIControl+AspectAutoLog.m
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import "NSObject+AspectAutoLog.h"
#import "AspectAutoLog-Swift.h"

@implementation UIControl (AspectAutoLog)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self aal_methodSwizzleWithOriginal:@selector(addTarget:action:forControlEvents:)
                                   swizzled:@selector(aal_addTarget:action:forControlEvents:)];
        [self aal_methodSwizzleWithOriginal:@selector(removeTarget:action:forControlEvents:)
                                   swizzled:@selector(aal_removeTarget:action:forControlEvents:)];
        [self aal_methodSwizzleWithOriginal:@selector(sendAction:to:forEvent:)
                                   swizzled:@selector(aal_sendAction:to:forEvent:)];
    });
}

- (void)aal_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self aal_addTarget:target action:action forControlEvents:controlEvents];
    [AALAspectAutologHelper.shared after_control:self
                                    didAddTarget:target
                                          action:action
                                        forEvent:controlEvents];
}

- (void)aal_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self aal_removeTarget:target action:action forControlEvents:controlEvents];
    [AALAspectAutologHelper.shared after_control:self
                                 didRemoveTarget:target
                                          action:action
                                        forEvent:controlEvents];
}

- (void)aal_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [AALAspectAutologHelper.shared before_control:self
                                   willSendAction:action
                                         toTarget:target
                                         forEvent:event];
    [self aal_sendAction:action to:target forEvent:event];
}

@end
