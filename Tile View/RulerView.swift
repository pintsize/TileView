//
//  RulerView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/13/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

final class RulerView: UIView {
    
    var pixelCount: Int = defaultResolution.horizontal {
        didSet {
            setupPixels()
        }
    }
    
    private let stackView = UIStackView()
    
    override func awakeFromNib() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupPixels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.axis = bounds.width > bounds.height ? .horizontal : .vertical
    }
    
}

extension RulerView {
    
    func removeAllPixels() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            stackView.removeArrangedSubview($0)
        }
    }
    
    func setupPixels() {
        removeAllPixels()
        
        guard pixelCount > 0 else { return }
        var pixelNumber = 1
        while pixelNumber <= pixelCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            label.text = "\(pixelNumber)"
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            pixelNumber += 1
            stackView.addArrangedSubview(label)
        }
        
    }
    
}
