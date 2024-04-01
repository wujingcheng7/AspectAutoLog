//
//  AALAspectAutoLogProtocol.h
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 需要您自己实现这个协议，并且进行注册
/// You need to implement this protocol on your own and then register it.
///
/// Example:
///
/// step1:
///
/// First, you need to write a class that inherits from NSObject and implements the AALAspectAutoLogProtocol protocol.
/// Let's name this class YourCustomLogClass for now.
///
/// 首先，你需要自己写一个类，这个类继承自 NSObject 并且实现了 AALAspectAutoLogProtocol 协议.
/// 我们暂且讲这个类命名为 YourCustomLogClass
///
/// step2:
/// 然后，你需要自己写一个 NSObject 分类，在 +load 方法中指定 AALAspectAutoFrogExecutor = [YourCustomLogClass class];
///
/// Then, you need to write an NSObject category yourself
/// and specify `AALAspectAutoFrogExecutor = [YourCustomLogClass class];` in the "+load" method.
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
///     [AALAspectAutoLogExecutor registerWithLogger: [YourCustomLogClass class]];
/// }
///
/// @end
///
/// 或者您也可以简单操作，直接在 AppDelegate `application:didFinishLaunchingWithOptions:` 方法中进行注册
/// Alternatively, you can also take a simpler approach and register it directly in the AppDelegate's `application:didFinishLaunchingWithOptions:` method.
///
/// step3:
/// ✅ done [大功告成]
///
NS_SWIFT_NAME(AspectAutoLogProtocol)
@protocol AALAspectAutoLogProtocol <NSObject>

@optional

/// UIViewController did call "-viewDidAppear"
+ (void)logUIViewControllerAppear:(UIViewController *)viewController;

/// UIViewController is still appearing when app enter foreground
+ (void)logUIViewControllerAppearingWhenAppEnterForeground:(UIViewController *)viewController;

/// UIViewController did call "-viewDidDisAppear"
+ (void)logUIViewControllerDisAppear:(UIViewController *)viewController;

/// UIControl will execute "touchUpInside" action
+ (void)logUIControlWillTouchUpInside:(UIControl *)control
                     inViewController:(nullable UIViewController *)viewController
NS_SWIFT_NAME(logUIControlWillTouchUpInside(control:inViewController:));

@end

NS_ASSUME_NONNULL_END
