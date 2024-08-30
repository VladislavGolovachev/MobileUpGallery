//
//  URLSessionExtension.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 29.08.2024.
//

import Foundation

extension URLSession {
    func cancelAllTasks() {
        self.getAllTasks { tasks in
            for task in tasks {
                task.cancel()
            }
        }
    }
    
    func suspendAllTasks() {
        self.getAllTasks { tasks in
            for task in tasks {
                task.suspend()
            }
        }
    }
    
    func resumeAllTasks() {
        self.getAllTasks { tasks in
            for task in tasks {
                task.resume()
            }
        }
    }
}
