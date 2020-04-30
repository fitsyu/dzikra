//
//  PostPrayerDzikrInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 27/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

class PostPrayerDzikrInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    let dzikrDict = [
        ("", "Allahumma Ajirna", 7, "#C4DEF6"),
        ("Tasbih", "Shubhanallah", 33, "#EB9694"),
        ("Tahmid", "Alhamdulillah", 33, "#FAD0C3"),
        ("Takbir", "Allahu Akbar", 33, "#FEF3BD"),
        ("", "La ilaha illallah", 100, "#C1E1C5"),
    ]
    
    override func willActivate() {
        
        let rc1s = dzikrDict.map { _ in "RC1" }
        
        tableView.setRowTypes( rc1s  )
        
        for i in 0..<dzikrDict.count {
            
            let rc = tableView.rowController(at: i) as! DzikrItemSetRowController
            
            let dzikr = dzikrDict[i]
            let dzikrName = dzikr.0.isEmpty ? DEFAULT_DZIKR_NAME : dzikr.0
            let dzikrSentence = dzikr.1
            let dzikrCount = dzikr.2
            let dzikrTagColor = dzikr.3
            
            rc.titleLabel.setText(dzikrName)
            rc.subTitleLabel.setText(dzikrSentence)
            rc.countLabel.setText("\(dzikrCount)")
            rc.titleColor = UIColor(hex: dzikrTagColor)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        guard rowIndex < dzikrDict.count else {
            return
        }
        
        let dzikr = dzikrDict[rowIndex]
        
        let newSession = DzikrSession(dzikrName: dzikr.0,
                                      kalimahThoyyibah: dzikr.1,
                                      currentValue: 0,
                                      limit: dzikr.2,
                                      color: dzikr.3)
        
        pushController(withName: "Dzikra", context: newSession)
    }
}



// UITableViewCell
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
