//
//  Color.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/8/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

struct Color: Codable, Equatable, Hashable {
    
    internal init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    var color: UIColor {
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init?(with color: UIColor) {
        let cgColor = color.cgColor
        
        if let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
            let convertedCGColor = cgColor.converted(to: sRGB, intent: .defaultIntent, options: nil) {
            let uiColor = UIColor(cgColor: convertedCGColor)
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            print("r: \(r), g: \(g), b: \(b), a: \(a)")
            red = r
            green = g
            blue = b
            alpha = a
        } else {
            return nil
        }
    }
    
}

extension Color {
    
    func set() {
        color.set()
    }
    
    func setFill() {
        color.setFill()
    }
    
    func setStroke() {
        color.setStroke()
    }
}

extension UIColor {
    
    var color: Color? {
        return Color(with: self)
    }
    
}
