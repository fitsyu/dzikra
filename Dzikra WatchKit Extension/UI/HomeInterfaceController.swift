//
//  HomeInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 26/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit


/*
 
 - a place where:
 
 - shows:
 - saved session
 - last session
 
 - sets
 
 - custom set
 
 - settings
 
 */
class HomeInterfaceControler: WKInterfaceController {
    
    static let ID = "Home"

    @IBAction func quick7buttonTap() {
        let session = DzikrSession(dzikrName: DEFAULT_DZIKR_NAME,
            kalimahThoyyibah: DEFAULT_DZIKR_NAME,
                                   currentValue: 0,
                                   limit: 7)
        pushController(withName: DzikraInterfaceController.ID, context: session)
    }
    
    @IBAction func quick33buttonTap() {
        let session = DzikrSession(dzikrName: DEFAULT_DZIKR_NAME,
                                   kalimahThoyyibah: DEFAULT_DZIKR_NAME,
                                   currentValue: 0,
                                   limit: 33)
        pushController(withName: DzikraInterfaceController.ID, context: session)
    }
    
    @IBAction func quick100buttonTap() {
        let session = DzikrSession(dzikrName: DEFAULT_DZIKR_NAME,
                                   kalimahThoyyibah: DEFAULT_DZIKR_NAME,
                                   currentValue: 0,
                                   limit: 100)
        pushController(withName: DzikraInterfaceController.ID, context: session)
    }
    
    @IBAction func postPrayerDzikrButtonTap() {
        pushController(withName: DzikrSetTableInterfaceController.ID, context: BuiltinDzikrSet.PostPrayer)
    }
    
    @IBAction func dailyDzikrButtonTap() {
        pushController(withName: DzikrSetTableInterfaceController.ID, context: BuiltinDzikrSet.Daily)
    }
    
    @IBAction func customDzikrButtonTap() {
        presentController(withName: CustomLimitInterfaceController.ID, context: self)
    }
    
    // MARK: LifeCycle
    
    @IBOutlet weak var continueButton: WKInterfaceButton!
    
    @IBAction func continueButtonTap() {
        
        guard let pausedSession = sessionToContinue else { return }
        
        pushController(withName: DzikraInterfaceController.ID, context: pausedSession)
        
        sessionManager.clear()
    }
    
    let sessionManager: SessionManager = ContinueLaterSessionManager()
    var sessionToContinue: DzikrSession?
    override func willActivate() {
        super.willActivate()
        
        sessionManager.load(completion: { (pausedSession: DzikrSession?) in
            
            if pausedSession != nil {
                // show paused session
                self.continueButton.setHidden(false)
                self.sessionToContinue = pausedSession
            } else {
                self.continueButton.setHidden(true)
            }
        })
    }
}

extension HomeInterfaceControler: CustomLimitDelegate {
    
    func didSetSession(session: DzikrSession, completion: @escaping () -> Void) {
        
        completion()
        
        self.pushController(withName: DzikraInterfaceController.ID, context: session)
    }
}

