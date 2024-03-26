//
//  UIViewController+Compatible.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/26.
//

import UIKit

extension UIViewController: AspectAutoLogCompatible { }

@objc(AALPageNode)
@objcMembers
public class PageNode: NSObject {

    public var name: String = ""
    public var prevNode: PageNode?

    public init(name: String? = "", prevNode: PageNode? = nil) {
        self.name = name ?? ""
        self.prevNode = prevNode
    }

    public func nodeChain() -> [PageNode] {
        var chain = [self]
        var res = self.prevNode
        while res != nil {
            chain.insert(res!, at: 0)
            res = res?.prevNode
        }
        return chain
    }

    public func nodeChainString(joined separator: String? = "/") -> String {
        nodeChain().map({ $0.name }).joined(separator: separator ?? "")
    }

}

@objc
public extension UIViewController {

    @available(*, renamed: "aal.pageName")
    var aal_pageNode: PageNode {
        aal.pageNode
    }

    @available(*, renamed: "aal.extraParams")
    var aal_extraParams: [String: Any] {
        get { aal.extraParams }
        set { aal.extraParams = newValue }
    }

    @available(*, renamed: "aal.dateWhenViewDidAppear")
    var aal_dateWhenViewDidAppear: Date? {
        aal.dateWhenViewDidAppear
    }

    @available(*, renamed: "aal.dateWhenViewDidDisAppear")
    var aal_dateWhenViewDidDisAppear: Date? {
        aal.dateWhenViewDidDisAppear
    }

    @available(*, renamed: "aal.appearDurationWhenDisappear")
    var aal_appearDurationWhenDisappear: TimeInterval {
        aal.appearDurationWhenDisappear
    }

}

public extension AspectAutoLogExtension where Base: UIViewController {

    var pageNode: PageNode {
        if let res = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.pageNode) as? PageNode {
            return res
        }
        let node = PageNode()
        objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.pageNode,
                                 node, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return node
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

    public internal(set) var dateWhenViewDidAppear: Date? {
        get {
            objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.dateWhenViewDidAppear) as? Date
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.dateWhenViewDidAppear,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public internal(set) var dateWhenViewDidDisAppear: Date? {
        get {
            objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.dateWhenViewDidDisappear) as? Date
        }
        set {
            objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.dateWhenViewDidDisappear,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var appearDurationWhenDisappear: TimeInterval {
        guard let disappear = dateWhenViewDidDisAppear, let appear = dateWhenViewDidAppear else { return 0 }
        return max(disappear.timeIntervalSince(appear), 0)
    }

}

fileprivate extension UIViewController {

    fileprivate struct AssociatedKeys {

        static var pageNode = UUID().uuidString
        static var dateWhenViewDidAppear = UUID().uuidString
        static var dateWhenViewDidDisappear = UUID().uuidString
        static var extraParams = UUID().uuidString

    }

}
