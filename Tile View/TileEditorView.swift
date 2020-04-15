//
//  TileEditorView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/4/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

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
    
    var transparentColor: UIColor = UIColor.magenta
    
    var toolMode: ToolMode = .paint
    
    var tile: Tile? {
        didSet {
            setNeedsDisplay()
            updateThumbnails()
        }
    }
    
    var currentLayer: Layer?
    
//    var pixels: [[Pixel]] {
//        return currentLayer?.pixels ?? []
//    }
    
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
    
    
    fileprivate func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TileEditorView.tap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(TileEditorView.pan(_:)))
        addGestureRecognizer(pan)
        pan.delegate = self
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(TileEditorView.hover(_:)))
        addGestureRecognizer(hover)
        
        isUserInteractionEnabled = true
    }
    
    func commonInit() {
        setupGestureRecognizers()
        
        if let patternImage = UIImage(named: "Transparent") {
            transparentColor = UIColor(patternImage: patternImage)
            backgroundColor = transparentColor
        }
    }
    
    func updateThumbnails() {
//        thumbnailView1X.pixels = pixels
//        thumbnailView2X.pixels = pixels
//        thumbnailView3X.pixels = pixels
    }
    
    func handlePaint(_ gestureRecognizer: UIGestureRecognizer) {
        guard let color = paintColor,
            let layer = currentLayer,
            let bitmap = layer.bitmap else { return }
        
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
            floodFill(pixelLocation, with: color, matching: matchingColor, in: bitmap)
        case .paint:
            set(color: color, for: pixelLocation)
        case .line:
            return
        case .circle:
            return
        }
        
    }
    
    func pixelColor(at location: PixelLocation) -> Color? {
        guard let layer = currentLayer,
            let bitmap = layer.bitmap else { return nil }

        return bitmap.color(at: location)
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
        guard let tile = tile else { return }
        UIColor.separator.setStroke()
        let bezierPath = UIBezierPath()
        
        
        renderLayers(in: tile)
        
        let size = cellSize
        
        for n in 1..<tile.resolution.horizontal {
            bezierPath.move(to: CGPoint(x: bounds.minX + (size.width * CGFloat(n)), y: bounds.minY))
            bezierPath.addLine(to: CGPoint(x: bounds.minX + (size.width * CGFloat(n)), y: bounds.maxY))
        }
        
        for n in 1..<tile.resolution.vertical {
            bezierPath.move(to: CGPoint(x: bounds.minX, y: (size.height * CGFloat(n))))
            bezierPath.addLine(to: CGPoint(x: bounds.maxX, y: (size.height * CGFloat(n))))
        }
        
        bezierPath.stroke()
        
        UIColor.label.setStroke()
        UIBezierPath(rect: bounds).stroke()
        
        drawHover()
    }
    
    func renderLayers(in tile: Tile) {
        for layer in tile.layers {
            if !layer.isHidden {
                render(layer: layer)
            }
        }
    }
    
    func render(layer: Layer) {
        if let bitmap = layer.bitmap {
            render(bitmap)
        }
    }
    
    func render(_ bitmap: Bitmap) {
        
        for (rowIndex, bitmapRow) in bitmap.rows.enumerated() {
            for (columnIndex, pixel) in bitmapRow.pixels.enumerated() {
                if let pixelColor = pixel.color {
                    let location = PixelLocation(column: columnIndex, row: rowIndex)
                    let rect = rectFor(location)
                    pixelColor.setFill()
                    UIBezierPath(rect: rect).fill()
                }
            }
        }
        
    }
    
    
    func drawTransparentPattern(at location: PixelLocation) {
        let rect = rectFor(location)
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
        guard let tile = tile else { return .zero}
        
        return CGSize(width: bounds.width / CGFloat(tile.resolution.horizontal), height: bounds.height / CGFloat(tile.resolution.vertical))
    }
    
    func rectFor(_ location: PixelLocation) -> CGRect {
        let size = cellSize
        return CGRect(x: bounds.minX + size.width * CGFloat(location.column),
                      y: bounds.minY + size.height * CGFloat(location.row),
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
    
    func floodFill(_ location: PixelLocation, with color: Color, matching: Color?, in bitmap: Bitmap) {
        let x = location.column
        let y = location.row
        if x < 0 || x >= bitmap.resolution.horizontal ||
            y < 0 || y >= bitmap.resolution.vertical {
            return
        }
        
        guard let pixel = bitmap.pixel(at: location) else { return }
        guard pixel.color == matching else { return }
        guard pixel.color != color else { return }
        
        
        set(color: color, for: PixelLocation(column: x, row: y))
        
        
        floodFill(location.above, with: color, matching: matching, in: bitmap)
        floodFill(location.below, with: color, matching: matching, in: bitmap)
        floodFill(location.left, with: color, matching: matching, in: bitmap)
        floodFill(location.right, with: color, matching: matching, in: bitmap)
    }
    
    func set(color: Color?, for location: PixelLocation) {
        guard let layer = currentLayer,
            let bitmap = layer.bitmap,
            let pixel = bitmap.pixel(at: location) else { return }
        
        if let undoManager = undoManager {
            let oldColor = pixel.color
            
            undoManager.registerUndo(withTarget: self, handler: { (TileEditorView) in
                self.set(color: oldColor, for: location)
                
            })
            undoManager.setActionName("Change Color")
        }
        
        pixel.color = color
        let rect = rectFor(location)
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
    
