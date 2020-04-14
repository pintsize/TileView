//
//  Layer.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/13/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

class Layer: Codable {
    
    var alternatives: [Layer] = []
    
    var isHidden: Bool = false
    
    var isLocked: Bool = false
    
}
