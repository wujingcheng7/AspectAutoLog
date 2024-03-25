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

    var logger: AALAspectAutoLogProtocol.Type? {
        AALAspectAutoFrogExecutor.self
    }

    private override init() {
        super.init()
    }

    // MARK: - UIViewController

    public func after_viewControllerDidInit(_ viewController: Any?) {
        guard let viewController = viewController as? UIViewController else { return }
    }

    public func after_viewControllerViewDidAppear(_ viewController: UIViewController, animated: Bool) {
        logger?.logUIViewControllerAppear?(viewController)
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

}
