//
//  NSUserDefaultsSerializer.swift
//  SYNQueueDemo
//

import Foundation
import SYNQueue


class NSUserDefaultsSerializer : SYNQueueSerializationProvider {
    // MARK: - SYNQueueSerializationProvider Methods
    
    @objc func serializeTask(_ task: SYNQueueTask, queueName: String) {
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
        } else {
            log(.error, "Failed to serialize task \(task.taskID) in queue \(queueName)")
        }
    }
    
    @objc func deserializeTasksInQueue(_ queue: SYNQueue) -> [SYNQueueTask] {
        let defaults = UserDefaults.standard
        if  let queueName = queue.name,
            let stringArray = defaults.stringArray(forKey: queueName)
        {
            return stringArray
                .map { return SYNQueueTask(json: $0, queue: queue) }
                .filter { return $0 != nil }
                .map { return $0! }
        }
        
        return []
    }
    
    @objc func removeTask(_ taskID: String, queue: SYNQueue) {
        if let queueName = queue.name {
            var curArray: [SYNQueueTask] = deserializeTasksInQueue(queue)
            curArray = curArray.filter { return $0.taskID != taskID }
            
            let stringArray = curArray
                .map { return $0.toJSONString() }
                .filter { return $0 != nil }
                .map { return $0! }
            
            let defaults = UserDefaults.standard
            defaults.setValue(stringArray, forKey: queueName)
        }
    }
}
