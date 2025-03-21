//
//  ContinueLaterSessionManager.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 08/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import Foundation

class ContinueLaterSessionManager: SessionManager {
    
    let storage = UserDefaults.standard
    
    func save(session: DzikrSession) {
        
        do {
            let data = try JSONEncoder().encode(session)
            storage.set(data, forKey: KEY_PAUSED_SESSION)
            
        } catch {
            print(error)
        }
    }
    
    func load(completion: @escaping (DzikrSession?) -> Void) {
        
        do {
            
            if let data = storage.value(forKey: KEY_PAUSED_SESSION) as? Data {
                
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
        storage.removeObject(forKey: KEY_PAUSED_SESSION)
    }
}
