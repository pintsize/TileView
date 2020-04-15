//
//  Bitmap.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/15/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

class Bitmap: Codable {
    
    
    init(with resolution: Resolution) {
        var rowArray: [BitmapRow] = []
        for _ in 0..<resolution.vertical {
            rowArray.append(BitmapRow(width: resolution.horizontal))
        }
        
        self.resolution = resolution
        self.rows = rowArray
    }
    
    let resolution: Resolution
    let rows: [BitmapRow]
}


extension Bitmap {
    
    func pixel(at location: PixelLocation) -> Pixel? {
        guard let row = rows[safe: location.row],
            let pixel = row.pixels[safe: location.column] else { return nil }
        
        return pixel
    }
    
    func color(at location: PixelLocation) -> Color? {
        guard let pixel = pixel(at: location) else { return nil }
        
        return pixel.color
    }
    
}
