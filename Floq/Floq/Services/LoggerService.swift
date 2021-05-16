//
//  LoggerService.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 16/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation


class Logger: NSObject {
    
    class func log(_ error:NSError, _ customMessage:String = logMessage){
       print("\(logMessage) \(error.debugDescription)")
    }
    
    class func log(_ error:Error, _ customMessage:String = logMessage){
        print("\(logMessage) \(error.localizedDescription)")
    }
    
    class func log(_ error:String, _ customMessage:String = logMessage){
       print("\(logMessage) \(error)")
    }
    
    class func log(_ error:Any?, _ customMessage:String = logMessage, _ defaultValue:String = "No loggable Error"){
        print("\(logMessage) \(error ?? defaultValue)")
    }
    
    static let logMessage = "Error occurred with signature:"
    
    static func debug(_ message: CustomStringConvertible, domain: String? = nil){
        guard let domain = domain else {
            print("⚠️⚠️⚠️ \(message.description)")
            return
        }
        print("⚠️⚠️⚠️ \(domain.uppercased()) :: \(message.description)")
    }
    
    static func error(_ message: CustomStringConvertible, domain: String? = nil){
        guard let domain = domain else {
            print("❌❌❌ \(message.description)")
            return
        }
        print("❌❌❌ \(domain.uppercased()) :: \(message.description)")
    }
}
