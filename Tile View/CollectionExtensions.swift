//
//  CollectionExtensions.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/15/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

public extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
