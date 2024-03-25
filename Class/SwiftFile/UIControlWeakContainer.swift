//
//  UIControlWeakContainer.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

class UIControlWeakContainer {

    private(set) weak var control: UIControl?

    var touchUpInside: TargetAndAction?

    init(control: UIControl) {
        self.control = control
    }

    func isTouchUpInside(target: Any?, action: Selector?) -> Bool {
        touchUpInside?.same(target: target as? NSObject, action: action) ?? false
    }

}

extension UIControlWeakContainer {

    struct TargetAndAction {

        weak var target: NSObject?
        var action: Selector?

        func same(target: NSObject?, action: Selector?) -> Bool {
            self.target == target && self.action == action
        }

    }

}
