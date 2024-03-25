//
//  ViewControllerWeakContainer.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

struct ViewControllerWeakContainer {

    weak var weakVC: UIViewController?

    func isEmpty() -> Bool {
        weakVC == nil
    }

}

extension UIViewController {

    func weakContainer() -> ViewControllerWeakContainer {
        .init(weakVC: self)
    }

}
