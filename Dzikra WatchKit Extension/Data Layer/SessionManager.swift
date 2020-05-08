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

class UserDefaultsSessionManager: SessionManager {
    
    let storage = UserDefaults.standard
    let key = "pausedSession"
    
    func save(session: DzikrSession) {
        
        do {
            let data = try JSONEncoder().encode(session)
            storage.set(data, forKey: key)
            
        } catch {
            print(error)
        }
    }
    
    func load(completion: @escaping (DzikrSession?) -> Void) {
        
        do {
            
            if let data = storage.value(forKey: key) as? Data {
                
                let session = try JSONDecoder().decode(DzikrSession.self, from: data)
                completion(session)
                return
            }
            
            completion(nil)
            
        } catch {
            print(error)
        }
    }
    
    func clear() {
        storage.removeObject(forKey: key)
    }
}
