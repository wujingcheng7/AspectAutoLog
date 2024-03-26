//
//  UIView+Compatible.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/26.
//

import UIKit

extension UIView: AspectAutoLogCompatible { }

@objc
public extension UIView {

    @objc
    @available(*, renamed: "aal.name")
    var aal_name: String? {
        get { aal.name }
        set { aal.name = newValue }
    }

    @objc
    @available(*, renamed: "aal.extraDict")
    var aal_extraDict: [String: Any] {
        get { aal.extraDict }
        set { aal.name }
    }

}

public extension AspectAutoLogExtension where Base: UIView {

    var name: String? {
        get {
            objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.name) as? String
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.name,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var extraDict: [String: Any] {
        get {
            if let res = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.extraDict) as? [String: Any] {
                return res
            }
            extraDict = [:]
            return [:]
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.extraDict,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

fileprivate extension UIView {

    fileprivate struct AssociatedKeys {

        static var name = UUID().uuidString
        static var extraDict = UUID().uuidString

    }

}
