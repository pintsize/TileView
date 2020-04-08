//
//  Pixel.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/5/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

class Pixel: Codable {
        
    var color: UIColor {
        get {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        set {
//            guard let color = newValue else {
//                red = 1.0
//                green = 1.0
//                blue = 1.0
//                alpha = 1.0
//                return
//            }
            isEmpty = false
            newValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
    }
    
    var isEmpty: Bool = true
    var red: CGFloat = 1.00
    var green: CGFloat = 1.00
    var blue: CGFloat = 1.00
    var alpha: CGFloat = 1.00
    
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
        case isEmpty
    }
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
