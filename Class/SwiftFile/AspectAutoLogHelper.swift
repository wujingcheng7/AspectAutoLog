//
//  AspectAutoLogHelper.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

@objc(AALAspectAutologHelper)
@objcMembers
public class AspectAutoLogHelper: NSObject {

    public static let shared = AspectAutoLogHelper()

    private var logger: AALAspectAutoLogProtocol.Type? {
        AALAspectAutoFrogExecutor.self
    }
    private var appearingVCArray: [ViewControllerWeakContainer] = []

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

    public func after_viewControllerDidInit(_ viewController: Any?) {
        guard let viewController = viewController as? UIViewController else { return }
    }

    public func after_viewControllerViewDidAppear(_ viewController: UIViewController, animated: Bool) {
        logger?.logUIViewControllerAppear?(viewController)
        if !appearingVCArray.contains(where: { $0.weakVC == viewController }) {
            appearingVCArray.append(viewController.weakContainer())
        }
    }

    public func after_viewControllerViewDidDisappear(_ viewController: UIViewController, animated: Bool) {
        appearingVCArray.removeAll(where: { $0.weakVC == viewController })
    }

    // MARK: - UIControl

    public func after_viewDidInit(_ view: Any?) {
        guard let view = view as? UIView else { return }
        if let control = view as? UIControl {
            control.addTarget(self, action: #selector(handleUIControlTouchUpInside), for: .touchUpInside)
        }
    }

    @objc
    private func handleUIControlTouchUpInside(_ control: UIControl?) {
        guard let control = control else { return }
        logger?.logUIControlTouchUp?(inside: control)
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
