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
