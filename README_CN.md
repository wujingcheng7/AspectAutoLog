# AspectAutoLog

AspectAutoLog 是一个用于 iOS 项目实现自动埋点的库，让埋点变得更加简单和高效。该库支持页面展示埋点和按钮点击埋点。

## 功能

- 支持 Swift 和 Objective-C 语言
- UIViewController 展示/消失/回到前台的自动埋点
- UIControl 点击的自动埋点
- UITableViewCell/UICollectionViewCell 展示&隐藏 [支持去重]
- 创建了常用的埋点参数，可以通过 .aal.xxx 直接获取和修改，开箱即用
- 埋点参数包含 extraParams 属性，可以加入更多自定义参数

## 原理

- 基于 runtime 的方法交换机制
- 使用面向切面编程思想实现

## 安装

1. 第一步 Podfile 引入

```Ruby
pod 'AspectAutoLog'
```

2. 第二步 实现 AALAspectAutoLogProtocol 协议

##### YourCustom 类

```Swift
import AspectAutoLog
// 如果你使用 Swift 语言
@objcMembers
public class YourCustom: NSObject, AspectAutoLogProtocol {

    public static func logUIViewControllerAppear(_ viewController: UIViewController) {
        // 向您自己的服务器上报埋点，页面展示事件
    }

    public static func logUIViewControllerAppearing(whenAppEnterForeground viewController: UIViewController) {
        // 向您自己的服务器上报埋点，app 回到前台导致页面再次展示在用户面前
    }


    public static func logUIViewControllerDisAppear(_ viewController: UIViewController) {
        let pageName = viewController.aal.pageNode.name // 页面 id
        let pageChain = viewController.aal.pageNode.nodeChain(containSelf: false) // 页面到达链路
        let appearDuration = viewController.aal.appearDurationWhenDisappear // 页面展示时间
        let extraParams = viewController.aal.extraParams // 页面其他参数
        // 然后使用这些数据向您自己的服务器上报埋点，页面移除事件
        ....
    }

    public static func logUIControlWillTouchUpInside(control: UIControl, inViewController viewController: UIViewController?) {
        let buttonName = control.aal.name // 按钮 id
        let params = control.aal.extraParams // 按钮其他参数
        let page = viewController // 按钮所在页面
        // 然后使用这些数据向您自己的服务器上报埋点
    }

    public static func logStartDisplayViewCell(_ cell: AspectAutoLogCell,
                                               inTableOrCollectionView view: UIScrollView,
                                               in viewController: UIViewController?) {
        let pageName = viewController?.aal.pageNode.name // 页面 id
        let pageExtraParams = viewController?.aal.extraParams // 页面的参数
        let containerExtraParams = view.aal.extraParams // 容器[UITableView/UICollectionView] 的额外参数
        let cellClass = cell.cellClass // cell 是什么类
        let cellName = cell.name // cell 的自定义名字
        let cellExtraParams = cell.extraPrams // cell 的额外参数
        // 然后使用这些数据向您自己的服务器上报埋点，Cell 开始展示事件
        ...
    }

    public static func logEndDisplayViewCell(_ cell: AspectAutoLogCell,
                                             inTableOrCollectionView view: UIScrollView,
                                             in viewController: UIViewController?) {
        let pageName = viewController?.aal.pageNode.name // 页面 id
        let pageExtraParams = viewController?.aal.extraParams // 页面的参数
        let containerExtraParams = view.aal.extraParams // 容器[UITableView/UICollectionView] 的额外参数
        let cellClass = cell.cellClass // cell 是什么类
        let cellName = cell.name // cell 的自定义名字
        let cellExtraParams = cell.extraPrams // cell 的额外参数
        let cellDisplayDuration = cell.displayDuration // cell 展示持续了多长时间
        // 然后使用这些数据向您自己的服务器上报埋点，Cell 结束展示事件
        ....
    }

}
```

```Objective-C
// .h 文件
#import <Foundation/Foundation.h>
#import <AspectAutoLog/AALAspectAutoLogProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface YourCustom : NSObject <AALAspectAutoLogProtocol>

@end

NS_ASSUME_NONNULL_END

// .m 文件
#import "YourCustom.h"
#import <UIKit/UIKit.h>
@import AspectAutoLog;

@implementation YourCustom

+ (void)logUIViewControllerAppear:(UIViewController *)viewController {
    // 向您自己的服务器上报埋点，页面展示事件
}

+ (void)logUIViewControllerAppearingWhenAppEnterForeground:(UIViewController *)viewController {
    // 向您自己的服务器上报埋点，app 回到前台导致页面再次展示在用户面前
}

+ (void)logUIViewControllerDisAppear:(UIViewController *)viewController {
    NSString *pageName = viewController.aal_pageNode.name; // 页面 id
    NSArray<AALPageNode *> *pageChain = [viewController.aal_pageNode nodeChainWithContainSelf:NO]; // 页面到达链路
    NSTimeInterval appearDuration = viewController.aal_appearDurationWhenDisappear; // 页面展示时间
    NSDictionary<NSString *, id> *extraParams = viewController.aal_extraParams; // 页面其他参数
    // 然后使用这些数据向您自己的服务器上报埋点，页面移除事件
    ....
}

+ (void)logUIControlWillTouchUpInside:(UIControl *)control 
                     inViewController:(UIViewController *)viewController {
    NSString *buttonName = control.aal_name; // 按钮 id
    NSDictionary<NSString *, id> *extraParams = control.aal_extraParams; // 按钮其他参数
    UIViewController *page = viewController // 按钮所在页面
    // 然后使用这些数据向您自己的服务器上报埋点
}

+ (void)logStartDisplayViewCell:(AspectAutoLogCell *)cell
        inTableOrCollectionView:(UIScrollView *)view
               inViewController:(UIViewController *)viewController {
    NSString* pageName = viewController.aal_pageNode.name; // 页面 id
    NSDictionary<NSString*, id>* pageExtraParams = viewController.aal_extraParams; // 页面的参数
    NSDictionary<NSString*, id>* containerExtraParams = view.aal_extraParams; // 容器[UITableView/UICollectionView] 的额外参数
    Class cellClass = cell.cellClass; // cell 是什么类
    NSString *cellName = cell.name; // cell 的自定义名字
    NSDictionary<NSString*, id>* cellExtraParams = cell.extraPrams; // cell 的额外参数
    // 然后使用这些数据向您自己的服务器上报埋点，Cell 开始展示事件
    ...
}

+ (void)logEndDisplayViewCell:(AspectAutoLogCell *)cell
      inTableOrCollectionView:(UIScrollView *)view
             inViewController:(UIViewController *)viewController {
    NSString* pageName = viewController.aal_pageNode.name; // 页面 id
    NSDictionary<NSString*, id>* pageExtraParams = viewController.aal_extraParams; // 页面的参数
    NSDictionary<NSString*, id>* containerExtraParams = view.aal_extraParams; // 容器[UITableView/UICollectionView] 的额外参数
    Class cellClass = cell.cellClass; // cell 是什么类
    NSString *cellName = cell.name; // cell 的自定义名字
    NSDictionary<NSString*, id>* cellExtraParams = cell.extraPrams; // cell 的额外参数
    NSTimeInterval cellDisplayDuration = cell.displayDuration; // cell 展示持续了多长时间
    // 然后使用这些数据向您自己的服务器上报埋点，Cell 结束展示事件
    ...
}

@end
```

3. 第三步 设置 AALAspectAutoFrogExecutor

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

## 示例

```swift
class SomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.aal.pageNode.name = "DemoPage" // 设置页面名称
        self.aal.extraParams = [
            "status": "hasGoNextButton"
        ] // 在任何时间设置和修改额外参数
        let button = UIButton()
        button.aal.name = "DemoDetailButton" // 为按钮进行命名
        button.aal.extraParams = [
            "gender": "male"
        ] // 在任何时间设置和修改额外参数
        button.setTitle("Detail", for: .normal)
        button.addTarget(self, action: #selector(handleGoNextPageButtonPressed), for: .touchUpInside)

        self.view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 300, height: 40)
    }

    @objc
    private func handleGoNextPageButtonPressed() {
        let page = UIViewController()
        page.aal.pageNode.name = "DemoDetailPage"
        page.aal.pageNode.prevNode = self.aal.pageNode // 跳转页面时，设置页面链条数据
        // show other page
        // self.navigationController?.pushViewController(page, animated: true)
        // self.present(page, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = ....
        // 给 cell 设置唯一 id，即可在 Display/EndDisplay 事件完成去重，实现更加高级更加准确的埋点事件效果
        // 例如您使用 UITableView 展示一个订单列表，每个 UITableViewCell 代表一个订单，他们都具有 orderId 属性且保证不重复
        // 那么您可以直接使用 `cell.aal.cellId = "\(orderId)"` 的方式来设定 aal_cellId 的值，简单且有效！
        let orderId = 0
        cell.aal.cellId = "\(orderId)"
        return cell
    }

}
```

## 贡献

欢迎贡献代码，提出问题和建议。

## 开源协议

AspectAutoLog 使用 MIT 协议。

