//
//  PixelLocation.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/7/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

struct PixelLocation: Codable {
    
    let column: Int
    let row: Int
    
}

extension PixelLocation {
    
    var above: PixelLocation {
        return PixelLocation(column: column, row: row - 1)
    }
    
    var below: PixelLocation {
        return PixelLocation(column: column, row: row + 1)
    }
    
    var left: PixelLocation {
        return PixelLocation(column: column + 1, row: row)
    }
    
    var right: PixelLocation {
        return PixelLocation(column: column - 1, row: row)
    }
}
