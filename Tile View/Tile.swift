//
//  Tile.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/8/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

class Tile: Codable {
    
    init(with resolution: Resolution) {
        self.resolution = resolution
        
        let baseLayer = Layer()
        baseLayer.name = "Base"
        baseLayer.bitmap = Bitmap(with: resolution)
        layers = [baseLayer, Layer()]
    }
    
    let resolution: Resolution
    
    var layers: [Layer] = []
    
}
