//
//  BitmapRow.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/15/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

class BitmapRow: Codable {
    
    init(width: Int) {
        var pixelArray: [Pixel] = []
        for _ in 0..<width {
            pixelArray.append(Pixel())
        }
        pixels = pixelArray
    }
    
    let pixels: [Pixel]
    
}
