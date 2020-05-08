//
//  SessionManager.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 01/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import Foundation

protocol SessionManager {
    func save(session: DzikrSession)
    func load(completion: @escaping (DzikrSession?) -> Void)
    func clear()
}
