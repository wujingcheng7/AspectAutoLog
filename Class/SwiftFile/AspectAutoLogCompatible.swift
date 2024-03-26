//
//  AspectAutoLogCompatible.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/26.
//

import UIKit

public protocol AspectAutoLogCompatible {

    associatedtype CompatibleType

    var aal: AspectAutoLogExtension<CompatibleType> { get }

}

public extension AspectAutoLogCompatible {

    var aal: AspectAutoLogExtension<Self> {
        AspectAutoLogExtension(self)
    }

}

public class AspectAutoLogExtension<Base> {

    let base: Base

    init(_ base: Base) {
        self.base = base
    }

}
