//
//  UIScrollViewWeakContainer.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/4/1.
//

import UIKit

class UIScrollViewWeakContainer {

    private(set) weak var view: UIScrollView?

    private var cells: [AspectAutoLogCell] = []
    private var contentOffsetKVO: NSKeyValueObservation?

    init(scrollView: UIScrollView) {
        self.view = scrollView
        /*
         中文:
         UICollectionView 在滚动时会触发 layoutSubviews，所以无需通过 KVO 来响应滚动事件
         UITableView 在滚动时不会触发 layoutSubviews，所以需要通过 KVO 来响应滚动事件
         English:
         UICollectionView triggers layoutSubviews when scrolling, so there is no need to respond to scroll events through KVO
         UITableView does not trigger layoutSubviews when scrolling, so it is necessary to respond to scroll events through KVO
         */
        if scrollView is UITableView {
            contentOffsetKVO = scrollView.observe(\.contentOffset, changeHandler: { [weak self] _, _ in
                DispatchQueue.main.async { self?.checkCells() }
            })
        }
        checkCells()
    }

    deinit {
        contentOffsetKVO?.invalidate()
        contentOffsetKVO = nil
    }

    func checkCells() {
        guard let view = view, view is UITableView || view is UICollectionView else { return }

        let oldCellIds = cells.map { $0.idString }
        var newCellIds: [String] = []
        if let view = view as? UITableView {
            newCellIds = view.visibleCells.map({ $0.aal.cell.idString })
        } else if let view = view as? UICollectionView {
            newCellIds = view.visibleCells.map({ $0.aal.cell.idString })
        }

        // 若 cellId 列表未变化，无需做后面的复制 AspectAutoLogCell 对象的操作
        guard oldCellIds != newCellIds else { return }

        let oldCells = cells
        var newCells: [AspectAutoLogCell] = []
        var startDisplayArray: [AspectAutoLogCell] = []
        if let view = view as? UITableView {
            newCells = view.visibleCells.map({ $0.aal.cell.aalCopy() }).map({ newCopy in
                if let oldCopy = oldCells.first(where: { $0.idString == newCopy.idString }) {
                    newCopy.startDisplayTime = oldCopy.startDisplayTime
                } else {
                    newCopy.startDisplayTime = Date()
                    startDisplayArray.append(newCopy)
                }
                return newCopy
            })
        } else if let view = view as? UICollectionView {
            newCells = view.visibleCells.map({ $0.aal.cell.aalCopy() }).map({ newCopy in
                if let oldCopy = oldCells.first(where: { $0.idString == newCopy.idString }) {
                    newCopy.startDisplayTime = oldCopy.startDisplayTime
                } else {
                    newCopy.startDisplayTime = Date()
                    startDisplayArray.append(newCopy)
                }
                return newCopy
            })
        }
        cells = newCells

        let endDisplayArray = oldCells.filter { oldCell in
            !newCells.contains(where: { $0.idString == oldCell.idString })
        }.map { removedCell in
            removedCell.endDisplayTime = Date()
            return removedCell
        }
        let page = view.findFirstViewController()
        endDisplayArray.forEach { cell in
            AspectAutoLogExecutor.loggersDo { logger in
                logger.logEndDisplayViewCell?(cell, inTableOrCollectionView: view, in: page)
            }
        }
        startDisplayArray.forEach { cell in
            AspectAutoLogExecutor.loggersDo { logger in
                logger.logStartDisplayViewCell?(cell, inTableOrCollectionView: view, in: page)
            }
        }
    }

}
