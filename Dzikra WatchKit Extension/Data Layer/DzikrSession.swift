//
//  DzikrSession.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 22/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import Foundation

struct DzikrSession: Codable {
    
    var dzikrName: String
    var kalimahThoyyibah: String
    var currentValue: Int
    var limit: Int? // nil means no limit
    var round: Int
    var color: String?
}
