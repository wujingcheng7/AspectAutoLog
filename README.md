# AspectAutoLog

AspectAutoLog is a library for implementing automatic tracking in iOS projects, making tracking simpler and more efficient.(aka "ios auto log", "ios auto tracking".
) This library supports page display tracking and button click tracking.

### [中文介绍](README_CN.md)

## Features

- Supports Swift and Objective-C languages
- Automatic tracking of UIViewController's appearance/disappearance/returning to the foreground
- Automatic tracking of UIControl's clicks
- Provides commonly used tracking parameters that can be directly accessed and modified via .aal.xxx, ready to use out of the box
- Tracking parameters include an extraParams property for adding more custom parameters

## Principles

- Based on runtime method swizzling
- Implemented using the aspect-oriented programming paradigm

## Installation

1. Step 1: Add to Podfile

```Ruby
pod 'AspectAutoLog'
```

2. Step 2: Implement the AALAspectAutoLogProtocol protocol

##### YourCustom class

```Swift
import AspectAutoLog

@objcMembers
public class YourCustom: NSObject, AspectAutoLogProtocol {

    public static func logUIViewControllerAppear(_ viewController: UIViewController) {
        // Report tracking events to your server, page appear event
    }

    public static func logUIViewControllerAppearing(whenAppEnterForeground viewController: UIViewController) {
        // Report tracking events to your server, app returning to the foreground causing the page to be displayed to the user again
    }

    public static func logUIViewControllerDisAppear(_ viewController: UIViewController) {
        let pageName = viewController.aal.pageNode.name // Page ID
        let pageChain = viewController.aal.pageNode.nodeChain(containSelf: false) // Page access chain
        let appearDuration = viewController.aal.appearDurationWhenDisappear // Page display time
        let extraParams = viewController.aal.extraParams // Other parameters of the page
        // Then use this data to report tracking events to your server, page removal event
        ....
    }

    public static func logUIControlWillTouchUpInside(control: UIControl, inViewController viewController: UIViewController?) {
        let buttonName = control.aal.name // Button ID
        let params = control.aal.extraParams // Other parameters of the button
        let page = viewController // Page where the button is located
        // Then use this data to report tracking events to your server
    }

}
```

```Objective-C
// .h file
#import <Foundation/Foundation.h>
#import <AspectAutoLog/AALAspectAutoLogProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface YourCustom : NSObject <AALAspectAutoLogProtocol>

@end

NS_ASSUME_NONNULL_END

// .m file
#import "YourCustom.h"
#import <UIKit/UIKit.h>
@import AspectAutoLog;

@implementation YourCustom

+ (void)logUIViewControllerAppear:(UIViewController *)viewController {
    // Report tracking events to your server, page appear event
}

+ (void)logUIViewControllerAppearingWhenAppEnterForeground:(UIViewController *)viewController {
    // Report tracking events to your server, app returning to the foreground causing the page to be displayed to the user again
}

+ (void)logUIViewControllerDisAppear:(UIViewController *)viewController {
    NSString *pageName = viewController.aal_pageNode.name; // Page ID
    NSArray<AALPageNode *> *pageChain = [viewController.aal_pageNode nodeChainWithContainSelf:NO]; // Page access chain
    NSTimeInterval appearDuration = viewController.aal_appearDurationWhenDisappear; // Page display time
    NSDictionary<NSString *, id> *extraParams = viewController.aal_extraParams; // Other parameters of the page
    // Then use this data to report tracking events to your server, page removal event
    ....
}

+ (void)logUIControlWillTouchUpInside:(UIControl *)control 
                     inViewController:(UIViewController *)viewController {
    NSString *buttonName = control.aal_name; // Button ID
    NSDictionary<NSString *, id> *extraParams = control.aal_extraParams; // Other parameters of the button
    UIViewController *page = viewController // Page where the button is located
    // Then use this data to report tracking events to your server
}

@end
```

3. Step 3: Set up AALAspectAutoFrogExecutor

```Objective-C
// NSObject+YourCustom.h
@interface NSObject (YourCustom)

@end

// NSObject+YourCustom.m
#import "NSObject+YourCustom.h"
@import AspectAutoLog;
@implementation NSObject (YourCustom)

+ (void)load {
    [AALAspectAutoLogExecutor registerWithLogger: [YourCustom class]];
}

@end
```

## Example

```swift
class SomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.aal.pageNode.name = "DemoPage" // Set the page name
        self.aal.extraParams = [
            "status": "hasGoNextButton"
        ] // Set and modify additional parameters at any time
        let button = UIButton()
        button.aal.name = "DemoDetailButton" // Name the button
        button.aal.extraParams = [
            "gender": "male"
        ] // Set and modify additional parameters at any time
        button.setTitle("Detail", for: .normal)
        button.addTarget(self, action: #selector(handleGoNextPageButtonPressed), for: .touchUpInside)

        self.view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 300, height: 40)
    }

    @objc
    private func handleGoNextPageButtonPressed() {
        let page = UIViewController()
        page.aal.pageNode.name = "DemoDetailPage"
        page.aal.pageNode.prevNode = self.aal.pageNode // When navigating to a new page, set the page chain data
        // Show other page
        // self.navigationController?.pushViewController(page, animated: true)
        // self.present(page, animated: true)
    }

}
```

## Contributing

Contributions, issues, and feature requests are welcome.

## License

AspectAutoLog is released under the MIT license.
