//
//  UIView+FindFirstViewController.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/25.
//

import UIKit

extension UIView {

    func findFirstViewController() -> UIViewController? {
        var res: UIResponder? = self
        while res != nil {
            res = res?.next
            if let res = res as? UIViewController {
                return res
            }
        }
        return nil
    }

}
