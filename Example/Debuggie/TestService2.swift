//
//  TestService2.swift
//  Debuggie
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Debuggie

class TestService2 {
    
    class func testRequest() -> String {
        
        if debugEnabled(.TestRequest) {
            return "[POST] /test (200 OK)"
        } else {
            return "OK"
        }
    }
    
    class func testRequest2() -> String {
        
        if debugEnabled(.TestRequest) {
            return "[GET] /test2 (200 OK)"
        } else {
            return "OK"
        }
    }
}

extension TestService2: Debuggable {
    enum DebugIdentifier: String, DebuggableIdentifier {
        case TestRequest = "Another request"
        case TestRequest2 = "Another request 2"
        
        static func allValues() -> [DebugIdentifier] {
            return [.TestRequest, .TestRequest2]
        }
    }
    
    static var namespace: String {
        return "Another service"
    }
}

