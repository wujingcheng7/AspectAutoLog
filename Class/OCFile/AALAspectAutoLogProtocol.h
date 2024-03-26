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

/// UIControl did "touchUpInside"
+ (void)logUIControlTouchUpInside:(UIControl *)control
              firstViewController:(nullable UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
