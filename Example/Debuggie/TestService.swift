//
//  TestService.swift
//  Debuggie
//
//  Created by Aleš Kocur on 29/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Debuggie

class TestService {
    
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

extension TestService: Debuggable {
    enum DebugIdentifier: String, DebuggableIdentifier {
        case TestRequest = "Print request body"
        case TestRequest2 = "Print request params"
        
        static func allValues() -> [DebugIdentifier] {
            return [.TestRequest, .TestRequest2]
        }
    }
    
    static var namespace: String {
        return "APIClient"
    }
}
