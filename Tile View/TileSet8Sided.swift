//
//  TileSet8Sided.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/8/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import Foundation

enum TileIdentifier: String, Codable {
    case upperLeftEdge
    case upEdge
    case upperRightEdge
    
    case leftEdge
    case center
    case rightEdge
    
    case lowerLeftEdge
    case downEdge
    case lowerRightEdge
    
    case upperLeftCorner
    case upperRightCorner
    case lowerLeftCorner
    case lowerRightCorner
}


extension TileIdentifier {
    
    var localizedName: String {
        switch self {
        case .upperLeftEdge:
            return NSLocalizedString("Upper Left Edge", comment: "Upper Left Edge Tile")
        case .upEdge:
            return NSLocalizedString("Up Edge", comment: "Up Edge Tile")
        case .upperRightEdge:
            return NSLocalizedString("Upper Right Edge", comment: "Upper Right Edge Tile")
        case .leftEdge:
            return NSLocalizedString("Left Edge", comment: "Left Edge Tile")
        case .center:
            return NSLocalizedString("Center", comment: "Center Tile")
        case .rightEdge:
            return NSLocalizedString("Right Edge", comment: "Right Edge Tile")
        case .lowerLeftEdge:
            return NSLocalizedString("Upper Left Edge", comment: "Upper Left Edge Tile")
        case .downEdge:
            return NSLocalizedString("Down Edge", comment: "Down Edge Tile")
        case .lowerRightEdge:
            return NSLocalizedString("Lower Right Edge", comment: "Lower Right Edge Tile")
        case .upperLeftCorner:
            return NSLocalizedString("Upper Left Corner", comment: "Upper Left Corner Tile")
        case .upperRightCorner:
            return NSLocalizedString("Upper Right Corner", comment: "Upper Right Corner Tile")
        case .lowerLeftCorner:
            return NSLocalizedString("Lower Left Corner", comment: "Lower Left Corner Tile")
        case .lowerRightCorner:
            return NSLocalizedString("Lower Right Corner", comment: "Lower Right Corner Tile")
        }
    }
}

class TileSet8Sided: Codable {
    
    init(with resolution: Resolution) {
        self.resolution = resolution
        
        self.tiles = [:]
    }
    
    let resolution: Resolution
    
    var tiles: [TileIdentifier: Tile]
    
    func tile(with identifier: TileIdentifier) -> Tile? {
        if let tile = tiles[identifier] {
            return tile
        }
        tiles[identifier] = Tile(with: resolution)
        return tiles[identifier]
    }
    
}

extension TileSet8Sided: TileSet {
    
    var baseTile: Tile {
        return tiles[.center] ?? Tile(with: resolution)
    }
    
}
