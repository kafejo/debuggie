//
//  Debugger.swift
//  maarked
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 FUNTASTY Digital s.r.o. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

public class Debuggie: NSObject {
    
    public private(set) static var sharedDebugger: Debuggie = Debuggie(isDebug: false)
    
    public class func createShared() -> Debuggie {
        
        if !sharedDebugger.isDebug {
            sharedDebugger = Debuggie(isDebug: true)
        }
        
        return sharedDebugger
    }
    
    private var window: UIWindow?
    private var _records: [NamespacedKey: Bool] = [:]
    private var isDebug: Bool
    
    init(isDebug: Bool) {
        self.isDebug = isDebug
        super.init()
        
        if isDebug {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            listenVolumeButton()
            
            window?.backgroundColor = UIColor.clearColor()
            window?.rootViewController = UINavigationController(rootViewController: DebuggieViewController())
            loadSavedRecords()
        }
    }
    
    // MARK: - Controls
    
    func listenVolumeButton(){
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            print("Unable to start listening for volume button")
        }
        
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    // MARK: - KVO
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "outputVolume"{
            window?.hidden = !(window?.hidden ?? false)
        }
    }
    
    // MARK: - Persistency
    
    func settingsFileURL(fileName: String = "debuggie.settings") -> NSURL {
        let manager = NSFileManager.defaultManager()
        let dirUrl = try! manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        
        return dirUrl.URLByAppendingPathComponent(fileName)
    }
    
    func saveRecords() {
        let filePath = settingsFileURL().path!
        let objects: [NamespacedKeyBox] = _records.map { (key, value) in
            return NamespacedKeyBox(key: key, value: value)
        }
            
        NSKeyedArchiver.archiveRootObject(objects, toFile: filePath)
    }
    
    func loadSavedRecords() {
        
        if let settingsPath = settingsFileURL().path, settings = NSKeyedUnarchiver.unarchiveObjectWithFile(settingsPath) as? [NamespacedKeyBox] {
            
            settings.forEach { box in
                _records.updateValue(box.value, forKey: box.key)
            }
        }
    }
    
    // MARK: - Interface
    
    func setRecord(record: Bool, forKey key: NamespacedKey) {
        _records[key] = record
        saveRecords()
    }
    
    func records() -> [NamespacedKey: Bool] {
        return _records
    }
}

// MARK: - Models

class NamespacedKey: NSObject, NSCoding {
    let namespace: String
    let name: String
    
    var key: String {
        return [namespace, name].joinWithSeparator(".")
    }
    
    @objc required init(namespace: String, name: String) {
        self.namespace = namespace
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        namespace = aDecoder.decodeObjectForKey("namespace") as! String
        name = aDecoder.decodeObjectForKey("name") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(namespace, forKey: "namespace")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    // Override hashable value
    override var hashValue: Int {
        return key.hashValue
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? NamespacedKey {
            return object == self
        } else {
            return false
        }
    }
}

class NamespacedKeyBox: NSObject, NSCoding {
    let key: NamespacedKey
    let value: Bool
    
    init(key: NamespacedKey, value: Bool) {
        self.key = key
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObjectForKey("key") as! NamespacedKey
        value = aDecoder.decodeObjectForKey("value") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(key, forKey: "key")
        aCoder.encodeObject(value, forKey: "value")
    }
}

func ==(lhs: NamespacedKey, rhs: NamespacedKey) -> Bool {
    return lhs.key == rhs.key
}

extension NamespacedKey: Comparable { }

func <(lhs: NamespacedKey, rhs: NamespacedKey) -> Bool {
    return lhs.key < lhs.key
}

// MARK: - Debuggie protocol

public protocol Debuggable {
    associatedtype DebugIdentifier: DebuggableIdentifier, RawRepresentable
    static var namespace: String { get }
}

public protocol DebuggableIdentifier {
    associatedtype DebugIdentifier: RawRepresentable
    static func allValues() -> [DebugIdentifier]
}

public extension Debuggable where DebugIdentifier.RawValue == String {
    
    static func attachToSharedDebugger() {
        if !Debuggie.sharedDebugger.isDebug {
            return
        }
        
        for value in DebugIdentifier.allValues() {
            let name = value.rawValue as! String
            let key = NamespacedKey(namespace: namespace, name: name)
            
            if Debuggie.sharedDebugger.records()[key] == nil {
                Debuggie.sharedDebugger.setRecord(false, forKey: key)
            }
        }
    }
    
    static func debugEnabled(identifier: DebugIdentifier) -> Bool {
        if Debuggie.sharedDebugger.isDebug {
            let key = NamespacedKey(namespace: namespace, name: identifier.rawValue)
            return Debuggie.sharedDebugger.records()[key] ?? false
        } else {
            return false
        }
    }
}
