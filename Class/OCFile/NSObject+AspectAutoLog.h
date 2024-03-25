//
//  NSObject+AspectAutoLog.h
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AspectAutoLog)

+ (void)aal_methodSwizzleWithOriginal:(SEL)originalSelector swizzled:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
