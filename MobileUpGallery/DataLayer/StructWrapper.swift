//
//  StructWrapper.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 24.08.2024.
//

import Foundation

final class StructWrapper<T>: NSObject {
    let value: T
    init(value: T) {
        self.value = value
    }
}
