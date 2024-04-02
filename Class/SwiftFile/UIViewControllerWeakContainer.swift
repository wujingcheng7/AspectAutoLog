//
//  ViewControllerWeakContainer.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

struct UIViewControllerWeakContainer {

    weak var weakVC: UIViewController?

    func isEmpty() -> Bool {
        weakVC == nil
    }

}

extension UIViewController {

    func weakContainer() -> UIViewControllerWeakContainer {
        .init(weakVC: self)
    }

}
