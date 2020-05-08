//
//  DzikraInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 22/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

class DzikraInterfaceController: WKInterfaceController {
    
    // MARK: Outlets
    @IBOutlet weak var kalimahThoyyibahLabel: WKInterfaceLabel!
    @IBOutlet weak var loopLabel: WKInterfaceLabel!
    @IBOutlet weak var maxLabel: WKInterfaceLabel!
    @IBOutlet weak var displayLabel: WKInterfaceLabel!
    @IBOutlet weak var progressImage: WKInterfaceImage!
    @IBOutlet weak var contextImage: WKInterfaceImage!
    
    // MARK: Properties
    var currentValue: Int = 0 {
        didSet {
            
            if currentValue > maxValue {
                WKInterfaceDevice.current().play(.click)
                
                currentValue = 1
                currentLoop += 1
            }
            
            
            displayLabel.setText("\(currentValue)")
            
            let progress = Int(Float(currentValue) / Float(maxValue) * 100)
            
            progressImage.setImage(UIImage(named: "progress-\(progress)"))
            
            if currentValue == maxValue {
                WKInterfaceDevice.current().play(.success)
            }
            
            activeSession?.currentValue = currentValue
            
        }
    }
    
    var currentLoop: Int = 1 {
        didSet {
            loopLabel.setText("\(currentLoop)")
        }
    }
    
    var activeSession: DzikrSession?
    var tobeContinuedSession: DzikrSession?
    let sessionManager: SessionManager = UserDefaultsSessionManager()
    
    private var maxValue: Int = 10
    
    // MARK: Action
    @IBAction func pushButtonPress() {
        
        currentValue += 1
    }
    
    @IBAction func resetButtonTap() {
        
        currentValue = 0
        WKInterfaceDevice.current().play(.click)
    }
    
    @IBAction func continueLaterButtonTap() {
        
        guard let session = tobeContinuedSession else { return }
        sessionManager.save(session: session)
        pop()
    }
    
    // MARK: LifeCycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let session = context as? DzikrSession {
            
            self.activeSession = session
        }
        
        drawFancyFutureLines()
    }
    
    override func willActivate() {
        super.willActivate()
        
        if let lastSessionData = UserDefaults.standard.value(forKey: KEY_SESSION) as? Data {
            // resume an active session
            if let lastSession = try? JSONDecoder().decode(DzikrSession.self, from: lastSessionData) {
                
                activeSession = lastSession
                displayActiveSession()
            }
        }
        else if let _ = activeSession {
            // new session set by home
            displayActiveSession()
        }
        
        //        else {
        //            // plain new session
        //            activeSession = DzikrSession(kalimahThoyyibah: "", currentValue: 0, limit: maxValue)
        //            displayActiveSession()
        //        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        let text = activeSession?.kalimahThoyyibah ?? ""
        let font = UIFont.systemFont(ofSize: 15)
        if isTruncated(text: text, width: contentFrame.width, font: font, numOfLines: 1) {
            
            kalimahThoyyibahLabel.setAutoHorizontalScrollText(text)
            scrollAfter1s() // give time for user to glance throuh the lafadz
        }
    }
    
    // called when you tap back & LONG PRESSING TO SHOW MENU
    override func willDisappear() {
        super.willDisappear()
        
        // update potential session to pause
        tobeContinuedSession?.currentValue = currentValue
//        continueLaterSession?.roundValue
        
        // clear session
        activeSession = nil
        
        kalimahThoyyibahLabel.stopTimer()
    }
    
    // called when crown is tapped & also after willDisapper
    override func didDeactivate() {
        super.didDeactivate()
        
        if let sessionToSave = activeSession {
            print("saving session")
            if let sessionData = try? JSONEncoder().encode(sessionToSave) {
                UserDefaults.standard.setValue(sessionData, forKey: KEY_SESSION)
            }
        } else {
            print("clearing the session")
            UserDefaults.standard.removeObject(forKey: KEY_SESSION)
        }
        
        CLKComplicationServer.sharedInstance().activeComplications?.forEach { each in
            CLKComplicationServer.sharedInstance().reloadTimeline(for: each)
        }
    }
    
    // MARK: Private
    private func displayActiveSession() {
        guard let session = activeSession else { return }
        
        self.maxValue     = session.limit ?? -1
        self.currentValue = session.currentValue

        // labels
        self.kalimahThoyyibahLabel.setText(session.kalimahThoyyibah)
        
        self.maxLabel.setText("\(maxValue)")
        
        let dzikrName = session.dzikrName.isEmpty ? DEFAULT_DZIKR_NAME : session.dzikrName
        setTitle(dzikrName)
        //        self.dzikrNameLabel.setText(dzikrName)
        
        if let hex = session.color {
            let color = UIColor(hex: hex)
            kalimahThoyyibahLabel.setTextColor(color)
        }
        
        tobeContinuedSession = session
    }
    
    private func drawFancyFutureLines() {
        UIGraphicsBeginImageContextWithOptions(contentFrame.size,
                                               false,
                                               0)
        guard let cgContext = UIGraphicsGetCurrentContext() else  { return }
        cgContext.beginPath()
        
        var point: CGPoint
        
        cgContext.setStrokeColor(UIColor.lightGray.cgColor)
        cgContext.setFillColor(UIColor.lightGray.cgColor)
        cgContext.setLineWidth(1)
        
        // 1st line
        point = CGPoint(x: contentFrame.maxX-0, y: 40)
        cgContext.move(to: point)
        
        point = CGPoint(x: contentFrame.maxX-25, y: 40)
        cgContext.addLine(to: point)
        
        point = CGPoint(x: contentFrame.maxX-35, y: 50)
        cgContext.addLine(to: point)
        cgContext.strokePath()
        
        cgContext.fillEllipse(in: CGRect(x: contentFrame.maxX-38.5, y: 48.5, width: 5, height: 5))
    
        // 2nd line
        point = CGPoint(x: contentFrame.minX+3, y: contentFrame.minY)
        cgContext.move(to: point)
        
        point = CGPoint(x: contentFrame.minX+3, y: contentFrame.midY - 30)
        cgContext.addLine(to: point)
        cgContext.strokePath()
        
        cgContext.fillEllipse(in: CGRect(x: point.x-2.5, y: point.y-2.5, width: 5, height: 5))
        
        // 3rd line
        let y = contentFrame.maxY - 20
        point = CGPoint(x: contentFrame.midX-5, y: y-8)
        cgContext.move(to: point)
        cgContext.fillEllipse(in: CGRect(x: point.x-2.5, y: point.y-2.5, width: 5, height: 5))
        
        cgContext.move(to: point)
        cgContext.addLine(to: CGPoint(x: contentFrame.midX+3, y: y))
        cgContext.addLine(to: CGPoint(x: contentFrame.maxX-10, y: y))
        cgContext.strokePath()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        contextImage.setImage(img)
    }
    
    
    private func scrollAfter1s() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.kalimahThoyyibahLabel.startTimer()
        })
    }
    
    private func isTruncated(text: String, width: CGFloat, font: UIFont, numOfLines: Int) -> Bool {
        
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        
        let thisNumOfLines = Int(ceil(rect.size.height / font.lineHeight))

        let isTruncated = thisNumOfLines > numOfLines
        return isTruncated
    }
}
