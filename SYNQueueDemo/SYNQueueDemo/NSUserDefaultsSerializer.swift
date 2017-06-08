//
//  NSUserDefaultsSerializer.swift
//  SYNQueueDemo
//

import Foundation
import SYNQueue

public class NSUserDefaultsSerializer: SYNQueueSerializationProvider {
    
    public init() { }
    
    public func serializeTask(_ task: SYNQueueTask, queueName: String) {
        if let serialized = task.toJSONString() {
            let defaults = UserDefaults.standard
            var stringArray: [String]
            
            if let curStringArray = defaults.stringArray(forKey: queueName) {
                stringArray = curStringArray
                stringArray.append(serialized)
            } else {
                stringArray = [serialized]
            }
            defaults.setValue(stringArray, forKey: queueName)
            defaults.synchronize()
        } else {
            log(.Error, "Failed to serialize task \(task.taskID) in queue \(queueName)")
        }
    }
    
    public func deserialzeTasks(_ queue: SYNQueue) -> [SYNQueueTask] {
        let defaults = UserDefaults.standard
        if  let queneName = queue.name,
            let stringArray = defaults.stringArray(forKey: queneName) {
            
            return stringArray
                .map { return SYNQueueTask(json: $0, queue: queue)}
                .filter { return $0 != nil }
                .map { return $0! }
        }
        return []
    }
    
    public func removeTask(_ taskID: String, queue: SYNQueue) {
        if let queueName = queue.name {
            var curArray: [SYNQueueTask] = deserialzeTasks(queue)
            curArray = curArray.filter {return $0.taskID != taskID }
            let stringArray = curArray
                .map {return $0.toJSONString() }
                .filter { return $0 != nil}
                .map { return $0! }
            UserDefaults.standard.setValue(stringArray, forKey: queueName)
        }
    }
}
