//
//  AALAspectAutoLogProtocol.h
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AALAspectAutoLogProtocol <NSObject>

@optional

/// UIViewController did call "-viewDidAppear"
+ (void)logUIViewControllerAppear:(UIViewController *)viewController;

/// UIControl did "touchUpInside"
+ (void)logUIControlTouchUpInside:(UIControl *)control;

@end

NS_ASSUME_NONNULL_END

/// 需要外界对这个类进行初始化，建议在 NSObject 的 "+load" 方法内执行初始化
/// External initialization of this class is required. It is recommended to do this within the NSObject's "+load" method.
///
/// Example:
///
/// ----- YourCustomLog.h file -----
/// #import <Foundation/Foundation.h>
///
/// @interface NSObject (YourCustomLog)
///
/// @end
///
///
/// ----- YourCustomLog.m file -----
/// #import "NSObject+YourCustomLog.h"
/// #import <AspectAutoLog/AALAspectAutoLogProtocol.h>
///
/// @implementation NSObject (YourCustomLog)
///
/// + (void)load {
///     // YourCustomLogClass must implement AALAspectAutoLogProtocol
///     AALAspectAutoFrogExecutor = [YourCustomLogClass class];
/// }
///
/// @end
///
extern _Nullable Class<AALAspectAutoLogProtocol> AALAspectAutoFrogExecutor;
