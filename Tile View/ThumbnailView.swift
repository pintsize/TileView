//
//  ThumbnailView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/7/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit



class ThumbnailView: UIView {
    
    var pixels: [[Pixel]] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let size = pixelSize
        for (columnIndex, column) in pixels.enumerated() {
            for (rowIndex, pixel) in column.enumerated() {
                //                print(pixel)
                if let pixelColor = pixel.color {
                    let rect = CGRect(x: CGFloat(columnIndex) * size.width, y: CGFloat(rowIndex) * size.height, width: size.width, height: size.height)
                    pixelColor.setFill()
                    UIBezierPath(rect: rect).fill()
                }
            }
        }
    }
    
    var pixelSize: CGSize {
        return CGSize(width: bounds.width / CGFloat(horizontalResolution), height: bounds.height / CGFloat(verticalResolution))
    }
    
}
