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

    @IBInspectable
    @available(*, renamed: "aal.name")
    var aal_name: String {
        get { aal.name }
        set { aal.name = newValue }
    }

    @available(*, renamed: "aal.extraParams")
    var aal_extraParams: [String: Any] {
        get { aal.extraParams }
        set { aal.extraParams = newValue }
    }

}

public extension AspectAutoLogExtension where Base: UIView {

    var name: String {
        get {
            if let res = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.name) as? String {
                return res
            }
            name = ""
            return ""
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.name,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var extraParams: [String: Any] {
        get {
            if let res = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.extraParams) as? [String: Any] {
                return res
            }
            extraParams = [:]
            return [:]
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.extraParams,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

fileprivate extension UIView {

    fileprivate struct AssociatedKeys {

        static var name = UUID().uuidString
        static var extraParams = UUID().uuidString

    }

}
