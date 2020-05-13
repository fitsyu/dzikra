//
//  CurrentValueEditorInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 13/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

protocol CurrentValueEditorInterfaceControllerDelegate: class {
    func newCurrentValueSet(_ newValue: Int)
}

class CurrentValueEditorInterfaceController: WKInterfaceController {
    
    struct Context {
        let currentValue: Int
        let delegate: CurrentValueEditorInterfaceControllerDelegate?
    }
    
    weak var delegate: CurrentValueEditorInterfaceControllerDelegate?
    
    static let ID = "CurrentValueEditor"
    
    private var textInput: String?
    
    private var numberInput: Int?
    
    override func awake(withContext context: Any?) {
        
        guard let theContext = context as? Context else { fatalError("Unexpected Context") }
        
        currentValueLabel.setText("current: \(theContext.currentValue)")
        delegate = theContext.delegate
    }
    
    @IBOutlet weak var currentValueLabel: WKInterfaceLabel!
    
    @IBAction func setButtonTap() {
        guard let number = numberInput else { return }
        delegate?.newCurrentValueSet(number)
        dismiss()
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
    
}


