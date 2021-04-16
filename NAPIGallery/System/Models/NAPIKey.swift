//
//  NAPIKey.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/27/21.
//  MyKey: uRzLWNLN9bEasIUbGkorbGaeJMCLiWAIAVPvV5Bz

import SwiftUI

///
/// Manages a NASA API Key. This object is implemented as a singleton via the ```shared```
/// attribute.
///
class NAPIKey: ObservableObject {
    static let demoKey = "DEMO_KEY"
    static let shared = NAPIKey()

    ///
    /// Returns the currently stored key.
    /// Setting this value will store it on-device. Only the first 80
    /// characters of ```newValue``` will be stored. This is normally
    /// fine since the current standard API Key is only 40 characters long.
    ///
    public var value: String {
        get { return key }
        set { key = newValue }
    }

    private let documentsURL: URL
    
    public func isDemoKey() -> Bool {
        return value == "DEMO_KEY"
    }
    
    private var key: String {
        get {
            return loadKey()
        }
        set {
            let val = (newValue.isEmpty) ? NAPIKey.demoKey : newValue
            _ = saveKey(val)
        }
    }

    private func loadKey() -> String {
        guard let file = URL(string: "\(documentsURL)napi_key.txt") else {
            return "DEMO_KEY"
        }
        
        if let key = try? String(contentsOfFile: file.path, encoding: .utf8) {
            return key
        }
        
        return "DEMO_KEY"
    }
    
    private func saveKey(_ key: String) -> Bool {
        guard let file = URL(string: "\(documentsURL)napi_key.txt") else { return false }
        
        //
        // It is possible to write anything including DEMO_KEY.
        // The string to be saved cannot be longer than 80 characters.
        // This assumption here is that even if the NASA API KEY was to
        // double in size, this code will still continue to work and at
        // the same time prevent a large string from being written to
        // the device.
        //
        let len = key.lengthOfBytes(using: .utf8)
        let cleanKey = (len > 80) ? String(key.prefix(upTo: key.index(key.startIndex, offsetBy: 80))) : key
        do {
            try cleanKey.write(toFile: file.path, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    private init() {
        documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
        
        value = key
    }
}
