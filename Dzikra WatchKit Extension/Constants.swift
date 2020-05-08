//
//  Constants.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 29/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

let DEFAULT_DZIKR_NAME = "Dzikr"

let KEY_ACTIVE_SESSION = "session"
let KEY_PAUSED_SESSION = "pausedSession"


enum BuiltinDzikrSet {
    
    static let PostPrayer: [DzikrSession] = [
        DzikrSession(dzikrName: "Allahumma ajirna",
                     kalimahThoyyibah: "Allahumma ajirna min annaar",
                     currentValue: 0,
                     limit: 7,
                     color: "#C4DEF6"),
        
        DzikrSession(dzikrName: "Tasbih",
                          kalimahThoyyibah: "Subhanallah",
                          currentValue: 0,
                          limit: 33,
                          color: "#EB9694"),
        
        DzikrSession(dzikrName: "Tahmid",
                          kalimahThoyyibah: "Alhamdulillah",
                          currentValue: 0,
                          limit: 33,
                          color: "#FAD0C3"),
        
        DzikrSession(dzikrName: "Takbir",
                          kalimahThoyyibah: "Allahu akbar",
                          currentValue: 0,
                          limit: 33,
                          color: "#FEF3BD"),
        
        DzikrSession(dzikrName: "Laa ilaha illallah",
                     kalimahThoyyibah: "Laa ilaha illallah",
                     currentValue: 0,
                     limit: 100,
                     color: "#C1E1C5")
    ]
    
    
    static let Daily: [DzikrSession] = [
        DzikrSession(dzikrName: "Hasbiyallah",
                     kalimahThoyyibah: "Hasbiyallah laa ilaha illa huwa 'alaihi tawakkaltu wa huwa robbul 'arsyil 'azhiim",
                     currentValue: 0,
                     limit: 7,
                     color: "#C4DEF6"),
        
        DzikrSession(dzikrName: "Istighfar",
                     kalimahThoyyibah: "Astaghfirullah al-azhim",
                     currentValue: 0,
                     limit: 100,
                     color: "#EB9694"),
        
        DzikrSession(dzikrName: "Sholawat",
                     kalimahThoyyibah: "Allahumma sholli 'ala sayyidina Muhammad",
                     currentValue: 0,
                     limit: 1000,
                     color: "#C1E1C5")
    ]
}
