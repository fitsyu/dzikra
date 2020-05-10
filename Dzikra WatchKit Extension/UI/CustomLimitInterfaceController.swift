//
//  CustomLimitInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 22/04/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

protocol CustomLimitDelegate: class {
    
    func didSetSession(session: DzikrSession, completion: @escaping ()->Void)
}

class CustomLimitInterfaceController: WKInterfaceController {
    
    static let ID = "CustomLimit"
    
    private var textInput: String?
    
    private var numberInput: Int?
    
    weak var delegate: CustomLimitDelegate?
    
    // MARK: LifeCycle
    
    override func awake(withContext context: Any?) {
        
        if let delegate = context as? CustomLimitDelegate {
            self.delegate = delegate
        }
    }
    
    // MARK: TextField
    
    @IBOutlet weak var textField: WKInterfaceTextField!
    
    @IBAction func textFieldAction(_ value: NSString?) {
        
        textInput = String(value ?? "")
    }
    
    // MARK: Pickers
    
    private func setPickerItems(picker: WKInterfacePicker) {
        let items: [WKPickerItem] = (0...9).map {
            let item = WKPickerItem()
            item.title = "\($0)"
            return item
        }
        
        picker.setItems(items)
    }
    
    @IBOutlet weak var picker1: WKInterfacePicker!
    
    @IBOutlet weak var picker2: WKInterfacePicker!
    
    @IBOutlet weak var picker3: WKInterfacePicker!

    
    override func willActivate() {
        [picker1, picker2, picker3].forEach { picker in self.setPickerItems(picker: picker) }
    }
        
    private var numChar: [String] = ["0", "0", "0"] {
        didSet {
            guard let realNumber = Int(numChar.joined()) else { return }
            numberInput = realNumber
            // [picker1].forEach { $0?.resignFocus()}
        }
    }
    
    @IBAction func picker1Action(index: Int) {
        numChar[0] = "\(index)"
    }
    
    @IBAction func picker2Action(index: Int) {
        numChar[1] = "\(index)"
    }
    
    @IBAction func picker3Action(index: Int) {
        numChar[2] = "\(index)"
    }
    
    // MARK: OK BUTTON
    @IBAction func buttonOK_tap() {
        
        let dzikr = textInput ?? DEFAULT_DZIKR_NAME
        guard let count = numberInput else { return }
        
        let session = DzikrSession(dzikrName: dzikr,
                                   kalimahThoyyibah: dzikr,
                                   currentValue: 0,
                                   limit: count,
                                   round: 1,
                                   color: nil)
        delegate?.didSetSession(session: session, completion: {
            self.dismiss()
        })
    }
}

