//
//  TileEditorView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/4/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

let horizontalResolution: Int = 32
let verticalResolution: Int = 32

class TileEditorView: UIView {
    enum ToolMode {
        case eraser
        case line
        case circle
        case floodFill
        case paint
    }
    
    @IBOutlet weak var thumbnailView1X: ThumbnailView!
    @IBOutlet weak var thumbnailView2X: ThumbnailView!
    @IBOutlet weak var thumbnailView3X: ThumbnailView!
    
    var toolMode: ToolMode = .paint
    
    var tile: Tile? {
        didSet {
            print("tile: \(tile?.layers)")
            setNeedsDisplay()
        }
    }
    
    var pixels: [[Pixel]] {
        return tile?.pixels ?? []
    }
    
    var paintColor: Color? = UIColor.black.color
    
    // TODO: Name?
    var isHovering: Bool = false
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    var lastPaintedPixelLocation: PixelLocation? = nil
    var hoverPixelLocation: PixelLocation? = nil
    
    
    func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TileEditorView.tap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(TileEditorView.pan(_:)))
        addGestureRecognizer(pan)
        pan.delegate = self
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(TileEditorView.hover(_:)))
        addGestureRecognizer(hover)
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TileEditorView.longPress(_:)))
//        addGestureRecognizer(longPress)
        
        isUserInteractionEnabled = true
    }
    
    func updateThumbnails() {
        thumbnailView1X.pixels = pixels
        thumbnailView2X.pixels = pixels
        thumbnailView3X.pixels = pixels
    }
    
    func handlePaint(_ gestureRecognizer: UIGestureRecognizer) {
        guard let color = paintColor else { return }
        let location: CGPoint = gestureRecognizer.location(in: self)
        print("handlePaint color: \(color)")
        guard bounds.contains(location) else { return }
        
        let column = Int(floor(location.x / cellSize.width))
        let row = Int(floor(location.y / cellSize.height))
        
        if let lastPaintedPixelLocation = lastPaintedPixelLocation,
        column == lastPaintedPixelLocation.column && row == lastPaintedPixelLocation.row { return }
        let pixelLocation = PixelLocation(column: column, row: row)
        lastPaintedPixelLocation = pixelLocation
        hoverPixelLocation = pixelLocation
        
        switch toolMode {
        case .eraser:
            erase(location: pixelLocation)
        case .floodFill:
            let matchingColor = pixelColor(at: pixelLocation)
            floodFill(pixelLocation, with: color, matching: matchingColor)
        case .paint:
            set(color: color, for: pixelLocation)
        case .line:
            return
        case .circle:
            return
        }
        
    }
    
    func pixelColor(at location: PixelLocation) -> Color? {
        let pixel = pixels[location.column][location.row]
        return pixel.color
    }
    
    func erase(location: PixelLocation) {
        set(color: nil, for: location)
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            handlePaint(gestureRecognizer)
        }
    }
    
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            handlePaint(gestureRecognizer)
        }
    }
    
    func handleHover(_ gestureRecognizer: UIGestureRecognizer) {
        let location: CGPoint = gestureRecognizer.location(in: self)
        guard bounds.contains(location) else { return }
        
        let column = Int(floor(location.x / cellSize.width))
        let row = Int(floor(location.y / cellSize.height))
        hoverPixelLocation = PixelLocation(column: column, row: row)
        setNeedsDisplay()
    }
    
    @objc func hover(_ gestureRecognizer: UIHoverGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            //Catalyst.appKit?.hideCursor()
            handleHover(gestureRecognizer)
        case .changed:
            handleHover(gestureRecognizer)
        case .ended:
            //Catalyst.appKit?.showCursor()
            hoverPixelLocation = nil
            setNeedsDisplay()
        default:
            break
        }
    }
        
    override func draw(_ rect: CGRect) {
                
        UIColor.separator.setStroke()
        let bezierPath = UIBezierPath()
        
        
        for (columnIndex, column) in pixels.enumerated() {
            for (rowIndex, pixel) in column.enumerated() {
//                print(pixel)
                
                if let pixelColor = pixel.color {
                    let rect = rectFor(column: columnIndex, row: rowIndex)
                    pixelColor.setFill()
                    UIBezierPath(rect: rect).fill()
                } else {
                    drawTransparentPattern(at: PixelLocation(column: columnIndex, row: rowIndex))
                }
            }
        }
        
        let size = cellSize
        
        for n in 1..<horizontalResolution {
//            print(n)
            bezierPath.move(to: CGPoint(x: bounds.minX + (size.width * CGFloat(n)), y: bounds.minY))
            bezierPath.addLine(to: CGPoint(x: bounds.minX + (size.width * CGFloat(n)), y: bounds.maxY))
        }
        
        for n in 1..<verticalResolution {
//            print(n)
            bezierPath.move(to: CGPoint(x: bounds.minX, y: (size.height * CGFloat(n))))
            bezierPath.addLine(to: CGPoint(x: bounds.maxX, y: (size.height * CGFloat(n))))
        }
        
        bezierPath.stroke()
        
        UIColor.label.setStroke()
        UIBezierPath(rect: bounds).stroke()
        
        drawHover()
    }
    
    func drawTransparentPattern(at location: PixelLocation) {
        let rect = rectFor(column: location.column, row: location.row)
        UIColor.white.setFill()
        UIBezierPath(rect: rect).fill()
        
        UIColor.systemGray2.setFill()
        UIBezierPath(rect: CGRect(x: rect.minX, y: rect.minY, width: rect.width / 2, height: rect.width / 2)).fill()
        UIBezierPath(rect: CGRect(x: rect.midX, y: rect.midY, width: rect.width / 2, height: rect.width / 2)).fill()
        
    }
    
    // TODO: Name?
    func drawHover() {
        guard let location = hoverPixelLocation else { return }
        
        let columnRect = rectFor(column: location.column)
        let rowRect = rectFor(row: location.row)
        
//        UIColor.black.withAlphaComponent(0.10).setFill()
//        UIBezierPath(rect: columnRect).fill()
//        UIBezierPath(rect: rowRect).fill()
        
        UIColor.black.setStroke()
        UIBezierPath(rect: columnRect).stroke()
        UIBezierPath(rect: rowRect).stroke()
    }

    
    var cellSize: CGSize {
        return CGSize(width: bounds.width / CGFloat(horizontalResolution), height: bounds.height / CGFloat(verticalResolution))
    }
    
    
    func rectFor(column: Int, row: Int) -> CGRect {
        let size = cellSize
        return CGRect(x: bounds.minX + size.width * CGFloat(column),
                      y: bounds.minY + size.height * CGFloat(row),
                      width: size.width,
                      height: size.height)
        
    }
    
    func rectFor(column: Int) -> CGRect {
        let size = cellSize
        return CGRect(x: bounds.minX + size.width * CGFloat(column),
                      y: bounds.minY,
                      width: size.width,
                      height: bounds.height)
    }
    
    func rectFor(row: Int) -> CGRect {
        let size = cellSize
        return CGRect(x: bounds.minX,
                      y: bounds.minY + size.height * CGFloat(row),
                      width: bounds.width,
                      height: size.height)
    }
    
    func floodFill(_ location: PixelLocation, with color: Color, matching: Color?) {
        let x = location.column
        let y = location.row
        if x < 0 || x >= horizontalResolution ||
            y < 0 || y >= verticalResolution {
            return
        }
        
        print("flooding: (\(x), \(y))")
        let pixel = pixels[x][y]
        
        if pixel.color != matching || pixel.color == color { return }
        
        
        set(color: color, for: PixelLocation(column: x, row: y))
        
        
        floodFill(location.above, with: color, matching: matching)
        floodFill(location.below, with: color, matching: matching)
        floodFill(location.left, with: color, matching: matching)
        floodFill(location.right, with: color, matching: matching)
    }
    
    func set(color: Color?, for pixelLocation: PixelLocation) {
        let pixel = pixels[pixelLocation.column][pixelLocation.row]
        if let undoManager = undoManager {
            let oldColor = pixel.color
            
            undoManager.registerUndo(withTarget: self, handler: { (TileEditorView) in
                self.set(color: oldColor, for: pixelLocation)
                
            })
            undoManager.setActionName("Change Color")
        }
        
        pixel.color = color
        let rect = rectFor(column: pixelLocation.column, row: pixelLocation.row)
        setNeedsDisplay(rect)
        updateThumbnails()
    }
    
}


extension TileEditorView: UIGestureRecognizerDelegate {
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        // Do not begin the pan until the swipe fails.
//        if gestureRecognizer is UITapGestureRecognizer &&
//            otherGestureRecognizer is UIPanGestureRecognizer {
//            return true
//        }
//        return false
//    }
}
    
