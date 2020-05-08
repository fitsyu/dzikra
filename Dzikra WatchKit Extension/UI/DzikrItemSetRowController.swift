//
//  DzikrItemSetRowController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 08/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

// Like UITableViewCell
class DzikrItemSetRowController: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var subTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var countLabel: WKInterfaceLabel!
    
    var titleColor: UIColor? {
        didSet {
            titleLabel.setTextColor(titleColor)
        }
    }
}
