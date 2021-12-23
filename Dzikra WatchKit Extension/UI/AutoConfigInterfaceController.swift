//
//  AutoConfigInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 23/12/21.
//  Copyright © 2021 Fitsyu . All rights reserved.
//

import WatchKit

protocol AutoConfigInterfaceControllerDelegate: AnyObject {
    func didUpdateConfig(config: AutoConfig)
}

struct AutoConfig {
    let steps: Int
    let interfval: Int
}

class AutoConfigInterfaceController: WKInterfaceController {
    weak var delegate: AutoConfigInterfaceControllerDelegate?
    
    private var steps = 1
    private var interval = 0
    
    @IBOutlet weak var stepsLabel: WKInterfaceLabel!
    @IBOutlet weak var stepsPicker: WKInterfacePicker!
    
    @IBOutlet weak var intervalLabel: WKInterfaceLabel!
    @IBOutlet weak var intervalPicker: WKInterfacePicker!
    
    private func setStepsPickerItems() {
        let items: [WKPickerItem] = (1...10).map {
            let item = WKPickerItem()
            item.title = "\($0)"
            return item
        }
        
        stepsPicker.setItems(items)
    }
    
    private func setIntervalPickerItems() {
        let items: [WKPickerItem] = (0...5).map {
            let item = WKPickerItem()
            item.title = "\($0)"
            return item
        }
        
        intervalPicker.setItems(items)
    }
    
    override func willActivate() {
        setStepsPickerItems()
        setIntervalPickerItems()
    }
    
    override func awake(withContext context: Any?) {
        self.delegate = context as? AutoConfigInterfaceControllerDelegate
    }
    
    @IBAction func stepsPickerAction(index: Int) {
        let steps = index + 1
        stepsLabel.setText("Steps: \(steps)")
        self.steps = steps
    }
    
    @IBAction func intervalPickerAction(index: Int) {
        intervalLabel.setText("Interval: \(index)")
        self.interval = index
    }
    
    @IBAction func applyButtonTapped() {
        let config = AutoConfig(steps: self.steps,
                                interfval: self.interval)
        self.dismiss()
        self.delegate?.didUpdateConfig(config: config)
    }
}
