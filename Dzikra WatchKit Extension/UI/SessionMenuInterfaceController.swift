//
//  SessionMenuInterfaceController.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu on 23/12/21.
//  Copyright © 2021 Fitsyu . All rights reserved.
//

import WatchKit

protocol SessionMenuInterfaceControllerDelegate: AnyObject {
    func pleaseSave()
    func pleaseEdit()
    func pleaseDoAutoCount(using config: AutoConfig)
    func pleaseDoNotAutoCount()
}

class SessionMenuInterfaceController: WKInterfaceController {
    weak var delegate: SessionMenuInterfaceControllerDelegate?
    
    private var autoConfig: AutoConfig? = AutoConfig(steps: 1, interfval: 0)
    
    @IBAction func saveButtonTapped() {
        self.dismiss()
        delegate?.pleaseSave()
    }
    
    @IBAction func editButtonTapped() {
        self.dismiss()
        delegate?.pleaseEdit()
    }
    
    @IBAction func autoSwitchTapped(_ isOn: Bool) {
        self.dismiss()
        guard let config = self.autoConfig else { return }
        isOn ? delegate?.pleaseDoAutoCount(using: config) : delegate?.pleaseDoNotAutoCount()
    }
    
    @IBAction func autoConfigTapped() {
        self.presentController(withName: "AutoConfigInterfaceController", context: self)
    }
    
    override func awake(withContext context: Any?) {
        self.delegate = context as? SessionMenuInterfaceControllerDelegate
    }
}

extension SessionMenuInterfaceController: AutoConfigInterfaceControllerDelegate {
    func didUpdateConfig(config: AutoConfig) {
        self.autoConfig = config
    }
}
