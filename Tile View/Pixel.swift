//
//  Pixel.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/5/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

class Pixel: Codable {
    
    var color: Color?
    
}


extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
