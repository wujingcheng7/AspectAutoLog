//
//  UITableViewCell+Compatible.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/4/2.
//

import UIKit

@objc
public extension UITableViewCell {

    /// 关于这个变量的意义和用法，请查看 AspectAutoLogCell.idString 的注释
    /// Please refer to the comments for AspectAutoLogCell.idString for the meaning and usage of this variable
    @available(*, renamed: "aal.cellId")
    var aal_cellId: String {
        get { aal.cellId }
        set { aal.cellId = newValue }
    }

}

public extension AspectAutoLogExtension where Base: UITableViewCell {

    /// 关于这个变量的意义和用法，请查看 AspectAutoLogCell.idString 的注释
    /// Please refer to the comments for AspectAutoLogCell.idString for the meaning and usage of this variable
    var cellId: String {
        get { cell.idString }
        set { cell.idString = newValue }
    }

    internal var cell: AspectAutoLogCell {
        if let res = objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.cell) as? AspectAutoLogCell {
            return res
        }
        let res = AspectAutoLogCell(idString: UUID().uuidString)
        objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.cell, res, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return res
    }

}

fileprivate extension UITableViewCell {

    fileprivate struct AssociatedKeys {

        static var cell = UUID().uuidString

    }

}
