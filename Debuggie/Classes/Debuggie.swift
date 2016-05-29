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
    var registations: [NamespacedKey: Bool] = [:]
    private var isDebug: Bool
    
    init(isDebug: Bool) {
        self.isDebug = isDebug
        super.init()
        
        if isDebug {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            listenVolumeButton()
            
            window?.backgroundColor = UIColor.clearColor()
            window?.rootViewController = UINavigationController(rootViewController: DebuggieViewController())
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
}

// MARK: - Models

struct NamespacedKey {
    let namespace: String
    let name: String
    
    var key: String {
        return [namespace, name].joinWithSeparator(".")
    }
}

func ==(lhs: NamespacedKey, rhs: NamespacedKey) -> Bool {
    return lhs.key == rhs.key
}

extension NamespacedKey: Equatable { }

extension NamespacedKey: Hashable {
    var hashValue: Int {
        return key.hashValue
    }
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
            Debuggie.sharedDebugger.registations[key] = true
        }
    }
    
    static func debugEnabled(identifier: DebugIdentifier) -> Bool {
        if Debuggie.sharedDebugger.isDebug {
            let key = NamespacedKey(namespace: namespace, name: identifier.rawValue)
            return Debuggie.sharedDebugger.registations[key] ?? false
        } else {
            return false
        }
    }
}
