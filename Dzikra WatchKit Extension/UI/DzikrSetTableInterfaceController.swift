//
//  DzikrSetTableInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 08/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

class DzikrSetTableInterfaceController: WKInterfaceController {
    
    static let ID = "DzikrSetTable"
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        
        guard let setOfDzikr = context as? [DzikrSession] else { return }
        
        self.setOfDzikr = setOfDzikr
    }
    
    var setOfDzikr: [DzikrSession] = []
    
    override func willActivate() {
        
        let rc1s = setOfDzikr.map { _ in DzikrItemSetRowController.ID }
        
        tableView.setRowTypes( rc1s  )
        
        for i in 0..<setOfDzikr.count {
            
            let rc = tableView.rowController(at: i) as! DzikrItemSetRowController
            
            let dzikr = setOfDzikr[i]
            let dzikrName = dzikr.dzikrName.isEmpty ? DEFAULT_DZIKR_NAME : dzikr.dzikrName
            let dzikrSentence = dzikr.kalimahThoyyibah
            let dzikrCount = dzikr.limit ?? 0
            let dzikrTagColor = dzikr.color ?? ""
            
            rc.titleLabel.setText(dzikrName)
            rc.subTitleLabel.setText(dzikrSentence)
            rc.countLabel.setText("\(dzikrCount)")
            rc.titleColor = UIColor(hex: dzikrTagColor) ?? DEFAULT_FOREGROUND_COLOR
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        guard rowIndex < setOfDzikr.count else {
            return
        }
        
        let newDzikrSession = setOfDzikr[rowIndex]
        
        pushController(withName: DzikraInterfaceController.ID, context: newDzikrSession)
    }
}
