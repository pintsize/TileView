//
//  Tile.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/8/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

class Tile: Codable {
    
    init() {
        var columns: [[Pixel]] = []
        
        for _ in 0..<horizontalResolution {
            var column: [Pixel] = []
            for _ in 0..<verticalResolution {
                column.append(Pixel())
            }
            
            columns.append(column)
        }
        
        pixels = columns
        
        layers = [BitmapLayer()]
    }
    
    var pixels: [[Pixel]] = []
    
    var layers: [Layer] = []
    
    
    
}
