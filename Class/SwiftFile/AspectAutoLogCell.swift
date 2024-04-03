//
//  AspectAutoLogCell.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/4/2.
//

import UIKit

@objcMembers
public class AspectAutoLogCell: NSObject {

    public internal(set) var name: String = ""
    public internal(set) var extraPrams: [String: Any] = [:]

    public internal(set) var startDisplayTime: Date = .distantFuture
    public internal(set) var endDisplayTime: Date?

    public var displayDuration: TimeInterval {
        let time = endDisplayTime ?? Date()
        return max(0, time.timeIntervalSince(startDisplayTime))
    }

    /// 以下注释将 UITableViewCell/UICollectionViewCell 统称为 UICell，把 AspectAutoLogCell 称为 LogicCell
    /// AspectAutoLog框架在判断一个 UICell 是否被移除或者添加时，并不取决于 UICell 的内存地址，而是取决于 LogicCell.idString
    /// 如果您不自定义 LogicCell.idString，我们会为每一个 UICell 赋予一个独一无二的 id，效果类似于其内存地址
    ///
    /// 如果使用内存地址，或者使用默认 LogicCell.idString，那么会导致以下两个问题
    /// - 1. 在使用 reloadData 方法时，某些目标仍然在展示但是可能换了一个 UICell 来渲染，从而导致它先触发“EndDisplay”再触发“StartDisplay”
    /// - 2. 在使用 reloadData 方法时，某些目标其实已经移除了但是由于它的 UICell 被复用于另一个目标，从而导致两个子问题
    /// -------- 2.1. 被移除的目标未触发 "EndDisplay" 事件
    /// -------- 2.2. 新展示的目标未触发 "StartDisplay" 事件
    ///
    /// 事实上，由于 UITableViewDelegate/UICollectionViewDelegate 的 willDisplay willEndDisplay 判断是基于内存地址的，
    /// 所以 UITableViewDelegate/UICollectionViewDelegate 就是具有上述缺陷的
    /// 如果您不自定义 LogicCell.idString，那么 AspectAutoLog 的判断准确性将和 UITableViewDelegate/UICollectionViewDelegate 保持一致
    ///
    /// 如果您根据您的业务逻辑自定义独一无二的 id，那么上述问题都可以被 AspectAutoLog 的机制完美地解决
    /// 例如您使用 UITableView 展示一个订单列表，每个 UITableViewCell 代表一个订单，他们都具有 orderId 属性且保证不重复
    /// 那么您可以直接使用 `tableViewCell.aal.cellId = "\(orderId)"` 的方式来设定 LogicCell.idString 的值，简单且有效！
    ///
    ///
    /// ---------- English -----------
    /// The following comments collectively refer to UITableViewCell/UICollectionViewCell as UICell, and AspectAutoLogCell as LogicCell
    /// The AspectAutoLog framework determines whether a UICell is removed or added based on LogicCell.idString rather than the memory address of the UICell
    /// If you do not customize LogicCell.idString, a unique id will be assigned to each UICell, similar to its memory address
    ///
    /// Using memory addresses or the default LogicCell.idString can lead to the following two issues:
    /// - 1. When using the reloadData method, some targets may still be displayed but with a different UICell for rendering, causing them to trigger "EndDisplay" before "StartDisplay"
    /// - 2. When using the reloadData method, some targets may have actually been removed, but because their UICell is reused for another target, it results in two sub-issues:
    /// -------- 2.1. The removed target does not trigger the "EndDisplay" event
    /// -------- 2.2. The newly displayed target does not trigger the "StartDisplay" event
    ///
    /// In fact, since UITableViewDelegate/UICollectionViewDelegate's willDisplay and willEndDisplay judgments are based on memory addresses,
    /// UITableViewDelegate/UICollectionViewDelegate inherently possess the aforementioned flaws
    /// If you do not customize LogicCell.idString, then the accuracy of AspectAutoLog's judgment will be consistent with UITableViewDelegate/UICollectionViewDelegate.
    ///
    /// By customizing a unique id based on your business logic, all the above issues can be perfectly resolved by AspectAutoLog's mechanism
    /// For example, if you are using a UITableView to display a list of orders, where each UITableViewCell represents an order with a unique orderId property,
    /// you can directly set LogicCell.idString using `tableViewCell.aal.cellId = "\(orderId)"`, which is simple and effective!
    @objc(idString)
    public internal(set) var idString: String

    init(idString: String) {
        self.idString = idString
        super.init()
    }

    func aalCopy() -> AspectAutoLogCell {
        let res = AspectAutoLogCell(idString: idString)
        res.name = name
        res.extraPrams = extraPrams
        res.startDisplayTime = startDisplayTime
        res.endDisplayTime = endDisplayTime
        return res
    }

}
