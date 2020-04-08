//
//  ColorPickerView.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/6/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

final class ColorPickerView: UIView {
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSwatch(with: .black)
        addSwatch(with: .blue)
        addSwatch(with: .brown)
        addSwatch(with: .cyan)
        addSwatch(with: .lightGray)
        addSwatch(with: .gray)
        addSwatch(with: .darkGray)
        addSwatch(with: .green)
        addSwatch(with: .lightGray)
        addSwatch(with: .brown)
        addSwatch(with: .cyan)
        addSwatch(with: .magenta)
        addSwatch(with: .orange)
        addSwatch(with: .purple)
        addSwatch(with: .red)
        addSwatch(with: .white)
        addSwatch(with: .yellow)
    }
    
    func addSwatch(with color: UIColor) {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = color
        
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 1/1).isActive = true
        stackView.addArrangedSubview(button)
    }
    
}
