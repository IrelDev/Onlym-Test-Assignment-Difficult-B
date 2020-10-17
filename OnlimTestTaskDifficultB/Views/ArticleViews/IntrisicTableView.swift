//
//  IntrisicTableView.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit

final class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
