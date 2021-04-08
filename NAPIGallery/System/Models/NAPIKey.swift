//
//  NAPIKey.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/27/21.
//  MyKey: uRzLWNLN9bEasIUbGkorbGaeJMCLiWAIAVPvV5Bz

import SwiftUI

class NAPIKey: ObservableObject {
    static let demoKey = "DEMO_KEY"
    static let shared = NAPIKey()

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
        // The string to be saved cannot be longer than 255 characters.
        // I like values that are a power of 2.
        //
        if key.lengthOfBytes(using: .utf8) < 256 {
            do {
                try key.write(toFile: file.path, atomically: true, encoding: .utf8)
                return true
            } catch {
                return false
            }
        }

        return false
    }

    private init() {
        documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
        
        value = key
    }
}

@propertyWrapper
struct Atomic<Value> {
    private let queue = DispatchQueue(label: "com.vadimbulavin.atomic")
    private var value: Value

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }
}

