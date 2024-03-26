//
//  AspectAutoLogHelper.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

@objc(AALAspectAutologHelper)
@objcMembers
/// English: Please do not use this class directly. The reason this class is designed as public is solely to allow internal Objective-C files to access it.
/// 中文: 请不要直接使用这个类，这个类之所以设计为 public，仅仅是为了能让内部的 OC 文件可以访问到
public class AspectAutoLogHelper: NSObject {

    public static let shared = AspectAutoLogHelper()

    private var logger: AALAspectAutoLogProtocol.Type? {
        AALAspectAutoFrogExecutor.self
    }

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIViewController

    private var appearingVCArray: [ViewControllerWeakContainer] = []

    public func after_viewControllerDidInit(_ viewController: Any?) {
        guard let viewController = viewController as? UIViewController else { return }
    }

    public func after_viewControllerViewDidAppear(_ viewController: UIViewController, animated: Bool) {
        viewController.aal.pageNode.dateWhenViewDidAppear = Date()
        logger?.logUIViewControllerAppear?(viewController)
        if !appearingVCArray.contains(where: { $0.weakVC == viewController }) {
            appearingVCArray.append(viewController.weakContainer())
        }
    }

    public func after_viewControllerViewDidDisappear(_ viewController: UIViewController, animated: Bool) {
        viewController.aal.pageNode.dateWhenViewDidDisAppear = Date()
        logger?.logUIViewControllerDisAppear?(viewController)
        appearingVCArray.removeAll(where: { $0.weakVC == viewController })
    }

    // MARK: - UIControl

    private var aliveControlArray: [UIControlWeakContainer] = []

    public func after_viewDidInit(_ view: Any?) {
        aliveControlArray.removeAll(where: { $0.control == nil })
        guard let view = view as? UIView else { return }
        if let control = view as? UIControl {
            aliveControlArray.append(.init(control: control))
        }
    }

    public func after_control(_ control: UIControl,
                              didAddTarget target: Any?,
                              action: Selector?,
                              forEvent event: UIControl.Event) {
        if event == .touchUpInside {
            aliveControlArray
                .first(where: { $0.control == control })?
                .touchUpInside = .init(target: target as? NSObject, action: action)
        }
    }

    public func after_control(_ control: UIControl,
                              didRemoveTarget target: Any?,
                              action: Selector?,
                              forEvent event: UIControl.Event) {
        if event == .touchUpInside {
            aliveControlArray.first(where: { $0.control == control })?.touchUpInside = nil
        }
    }

    public func before_control(_ control: UIControl,
                               willSendAction action: Selector?,
                               toTarget target: Any?,
                               forEvent event: UIEvent?) {
        if aliveControlArray.contains(where: {
            $0.control == control && $0.isTouchUpInside(target: target, action: action)
        }) {
            logger?.logUIControlWillTouchUpInside?(
                control: control,
                inViewController: control.findFirstViewController()
            )
        }
    }

    // MARK: - app enter foreground

    @objc
    private func handleAppWillEnterForeground() {
        appearingVCArray.removeAll(where: { $0.isEmpty() })
        appearingVCArray.compactMap({ $0.weakVC }).forEach { viewController in
            logger?.logUIViewControllerAppearing?(whenAppEnterForeground: viewController)
        }
    }

}
