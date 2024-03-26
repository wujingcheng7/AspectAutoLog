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
    public var extraDict: [String: Any] = [:]

    public internal(set) var dateWhenViewDidAppear: Date?
    public internal(set) var dateWhenViewDidDisAppear: Date?
    public var appearDurationWhenDisappear: TimeInterval {
        guard let disappear = dateWhenViewDidDisAppear, let appear = dateWhenViewDidAppear else { return 0 }
        return max(disappear.timeIntervalSince(appear), 0)
    }

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

    @objc
    @available(*, renamed: "aal.pageName")
    var aal_pageNode: PageNode {
        aal.pageNode
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

}

fileprivate extension UIViewController {

    fileprivate struct AssociatedKeys {

        static var pageNode = UUID().uuidString

    }

}
