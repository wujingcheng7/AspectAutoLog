# AspectAutoLog

AspectAutoLog is a library for implementing automatic tracking in iOS projects, making tracking simpler and more efficient.(aka "ios auto log", "ios auto tracking".
) This library supports page display tracking and button click tracking.

### [中文介绍](README_CN.md)

## Features

- Supports Swift and Objective-C languages
- Automatic tracking of UIViewController's appearance/disappearance/returning to the foreground
- Automatic tracking of UIControl's clicks
- Automatic tracking of (UITableViewCell/UICollectionViewCell)'s display & hide [supports deduplication]
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

    public static func logStartDisplayViewCell(_ cell: AspectAutoLogCell,
                                               inTableOrCollectionView view: UIScrollView,
                                               in viewController: UIViewController?) {
        let pageName = viewController?.aal.pageNode.name // Page ID
        let pageExtraParams = viewController?.aal.extraParams // Page parameters
        let containerExtraParams = view.aal.extraParams // Extra parameters for the container [UITableView/UICollectionView]
        let cellClass = cell.cellClass // Class of cell
        let cellName = cell.name // Custom name of the cell
        let cellExtraParams = cell.extraPrams // Extra parameters of the cell
        // Then use this data to log events to your server, indicating the start of cell display
        ...
    }

    public static func logEndDisplayViewCell(_ cell: AspectAutoLogCell,
                                             inTableOrCollectionView view: UIScrollView,
                                             in viewController: UIViewController?) {
        let pageName = viewController?.aal.pageNode.name // Page ID
        let pageExtraParams = viewController?.aal.extraParams // Page parameters
        let containerExtraParams = view.aal.extraParams // Extra parameters for the container [UITableView/UICollectionView]
        let cellClass = cell.cellClass // Class of cell
        let cellName = cell.name // Custom name of the cell
        let cellExtraParams = cell.extraPrams // Extra parameters of the cell
        let cellDisplayDuration = cell.displayDuration // Duration for which the cell was displayed
        // Then use this data to log events to your server, indicating the end of cell display
        ....
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

+ (void)logStartDisplayViewCell:(AspectAutoLogCell *)cell
        inTableOrCollectionView:(UIScrollView *)view
               inViewController:(UIViewController *)viewController {
    NSString* pageName = viewController.aal_pageNode.name; // Page ID
    NSDictionary<NSString*, id>* pageExtraParams = viewController.aal_extraParams; // Page parameters
    NSDictionary<NSString*, id>* containerExtraParams = view.aal_extraParams; // Extra parameters for the container [UITableView/UICollectionView]
    Class cellClass = cell.cellClass; // Class of cell
    NSString *cellName = cell.name; // Custom name of the cell
    NSDictionary<NSString*, id>* cellExtraParams = cell.extraPrams; // Extra parameters of the cell
    // Then use this data to log events to your server, indicating the start of cell display
    ...
}

+ (void)logEndDisplayViewCell:(AspectAutoLogCell *)cell
      inTableOrCollectionView:(UIScrollView *)view
             inViewController:(UIViewController *)viewController {
    NSString* pageName = viewController.aal_pageNode.name; // Page ID
    NSDictionary<NSString*, id>* pageExtraParams = viewController.aal_extraParams; // Page parameters
    NSDictionary<NSString*, id>* containerExtraParams = view.aal_extraParams; // Extra parameters for the container [UITableView/UICollectionView]
    Class cellClass = cell.cellClass; // Class of cell
    NSString *cellName = cell.name; // Custom name of the cell
    NSDictionary<NSString*, id>* cellExtraParams = cell.extraPrams; // Extra parameters of the cell
    NSTimeInterval cellDisplayDuration = cell.displayDuration; // Duration for which the cell was displayed
    // Then use this data to log events to your server, indicating the end of cell display
    ...
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = ....
        // Set a unique ID for the cell, which can be used to deduplicate Display/EndDisplay events, achieving more advanced and accurate tracking effects
        // For example, if you are displaying a list of orders using a UITableView, where each UITableViewCell represents an order and they all have an orderId property that is unique
        // You can simply set the value of aal_cellId using `cell.aal.cellId = "\(orderId)"`, making it simple and effective!
        let orderId = 0
        cell.aal.cellId = "\(orderId)"
        return cell
    }

}
```

## Contributing

Contributions, issues, and feature requests are welcome.

## License

AspectAutoLog is released under the MIT license.
