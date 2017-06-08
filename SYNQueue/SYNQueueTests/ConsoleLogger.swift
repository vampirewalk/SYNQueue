//
//  ConsoleLogger.swift
//  SYNQueueDemo
//

import Foundation
import SYNQueue

func log(_ level: LogLevel, _ msg: String) {
    return ConsoleLogger.log(level, msg)
}


class ConsoleLogger : SYNQueueLogProvider {
    // MARK: - SYNQueueLogProvider Delegates
    
    @objc func log(_ level: LogLevel, _ msg: String) {
        return ConsoleLogger.log(level, msg)
    }
    
    class func log(_ level: LogLevel, _ msg: String) {
        runOnMainThread { print("[\(level.toString().uppercased())] \(msg)") }
    }
}
