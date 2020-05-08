//
//  ActiveSessionManager.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 08/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import Foundation

class ActiveSessionManager: SessionManager {
    
    func save(session: DzikrSession) {
        if let sessionData = try? JSONEncoder().encode(session) {
            UserDefaults.standard.setValue(sessionData, forKey: KEY_ACTIVE_SESSION)
        }
    }
    
    func load(completion: @escaping (DzikrSession?) -> Void) {
        
        if let lastSessionData = UserDefaults.standard.value(forKey: KEY_ACTIVE_SESSION) as? Data {
            // resume an active session
            if let lastSession = try? JSONDecoder().decode(DzikrSession.self, from: lastSessionData) {
                completion(lastSession)
                return
            }
        }
        completion(nil)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: KEY_ACTIVE_SESSION)
    }
}
