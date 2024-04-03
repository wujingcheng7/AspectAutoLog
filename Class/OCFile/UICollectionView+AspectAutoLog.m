//
//  UICollectionView+AspectAutoLog.m
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/4/1.
//

#import "NSObject+AspectAutoLog.h"
#import "AspectAutoLog-Swift.h"

@implementation UICollectionView (AspectAutoLog)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self aal_methodSwizzleWithOriginal:@selector(reloadData)
                                   swizzled:@selector(aal_reloadData)];
        [self aal_methodSwizzleWithOriginal:@selector(endUpdates)
                                   swizzled:@selector(aal_endUpdates)];
        [self aal_methodSwizzleWithOriginal:@selector(performBatchUpdates:completion:)
                                   swizzled:@selector(aal_performBatchUpdates:completion:)];
    });
}

- (void)aal_reloadData {
    [self aal_reloadData];
    [AALAspectAutologHelper.shared after_viewDidReloadData:self];
}

- (void)aal_endUpdates {
    [self aal_endUpdates];
    [AALAspectAutologHelper.shared after_viewDidReloadData:self];
}

- (void)aal_performBatchUpdates:(void (^)(void))updates
                     completion:(void (^)(BOOL))completion {
    __weak typeof(self) weakSelf = self;
    [self aal_performBatchUpdates:updates 
                       completion:^(BOOL finish) {
        __strong typeof(weakSelf) strongSelf = self;
        if (strongSelf) {
            [AALAspectAutologHelper.shared after_viewDidReloadData:strongSelf];
        }
        if (completion) {
            completion(finish);
        }
    }];
}

@end
