//
//  UIView+AspectAutoLog.m
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import "UIView+AspectAutoLog.h"
#import "NSObject+AspectAutoLog.h"
#import "AspectAutoLog-Swift.h"

@implementation UIView (AspectAutoLog)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self aal_methodSwizzleWithOriginal:@selector(initWithFrame:)
                                   swizzled:@selector(initWithAalFrame:)];
        [self aal_methodSwizzleWithOriginal:@selector(initWithCoder:)
                                   swizzled:@selector(initWithAalCoder:)];
    });
}

- (instancetype)initWithAalFrame:(CGRect)frame {
    id res = [self initWithAalFrame:frame];
    [AALAspectAutologHelper.shared after_viewDidInit:res];
    return res;
}

- (instancetype)initWithAalCoder:(NSCoder *)coder {
    id res = [self initWithAalCoder:coder];
    [AALAspectAutologHelper.shared after_viewDidInit:res];
    return res;
}

@end
