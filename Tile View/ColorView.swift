//
//  ColorView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/12/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

@IBDesignable
final class ColorView: UIView {
    
    @IBInspectable var color: UIColor? {
        didSet {
            layer.backgroundColor = color?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.0
    }
    
    override func prepareForInterfaceBuilder() {
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.0
    }
    
}
