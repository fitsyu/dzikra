//
//  SessionManager.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 01/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import Foundation

protocol SessionManager {
    func pause(session: DzikrSession)
    func resume(completion: @escaping (DzikrSession?) -> Void)
    func clear()
}

class UserDefaultsSessionManager: SessionManager {
    
    let storage = UserDefaults.standard
    let key = "pausedSession"
    
    func pause(session: DzikrSession) {
        
        do {
            let data = try JSONEncoder().encode(session)
            storage.set(data, forKey: key)
            
        } catch {
            print(error)
        }
    }
    
    func resume(completion: @escaping (DzikrSession) -> Void) {
        
        do {
            
            if let data = storage.value(forKey: key) as? Data {
                
                let session = try JSONDecoder().decode(DzikrSession.self, from: data)
                completion(session)
            }
            
        } catch {
            print(error)
        }
    }
    
    func clear() {
        storage.removeObject(forKey: key)
    }
}
