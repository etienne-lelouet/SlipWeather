//
//  CustomTableView.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 29/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
