//
//  UIViewController+AspectAutoLog.m
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import "UIViewController+AspectAutoLog.h"
#import "NSObject+AspectAutoLog.h"
#import "AspectAutoLog-Swift.h"

@implementation UIViewController (AspectAutoLog)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self aal_methodSwizzleWithOriginal:@selector(initWithNibName:bundle:)
                                   swizzled:@selector(initWithAalNibName:bundle:)];
        [self aal_methodSwizzleWithOriginal:@selector(initWithCoder:)
                                   swizzled:@selector(initWithAalCoder:)];
        [self aal_methodSwizzleWithOriginal:@selector(viewDidAppear:)
                                   swizzled:@selector(aal_viewDidAppear:)];
    });
}

- (instancetype)initWithAalCoder:(NSCoder *)coder {
    id res = [self initWithAalCoder:coder];
    [AALAspectAutologHelper.shared after_viewControllerDidInit:res];
    return res;
}

- (instancetype)initWithAalNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id res = [self initWithAalNibName:nibNameOrNil bundle:nibBundleOrNil];
    [AALAspectAutologHelper.shared after_viewControllerDidInit:res];
    return res;
}

- (void)aal_viewDidAppear:(BOOL)animated {
    [self aal_viewDidAppear:animated];
    [AALAspectAutologHelper.shared after_viewControllerViewDidAppear:self animated:animated];
}

@end
