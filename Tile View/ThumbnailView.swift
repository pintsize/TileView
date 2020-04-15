//
//  ThumbnailView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/7/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit



class ThumbnailView: UIView {
    
    var bitmap: Bitmap? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let bitmap = bitmap else { return }
        let size = pixelSize
        for (rowIndex, bitmapRow) in bitmap.rows.enumerated() {
            for (columnIndex, pixel) in bitmapRow.pixels.enumerated() {
                if let pixelColor = pixel.color {
                    let rect = CGRect(x: CGFloat(columnIndex) * size.width, y: CGFloat(rowIndex) * size.height, width: size.width, height: size.height)
                    pixelColor.setFill()
                    UIBezierPath(rect: rect).fill()
                }
            }
        }
        
    }
    
    var pixelSize: CGSize {
        guard let bitmap = bitmap else { return .zero}
        return CGSize(width: bounds.width / CGFloat(bitmap.resolution.horizontal), height: bounds.height / CGFloat(bitmap.resolution.vertical))
    }
    
}
