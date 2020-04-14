//
//  ColorPickerViewController.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/9/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

final class ColorPickerViewController: UIViewController {
    
    var red: CGFloat = 1.00
    {
        didSet {
            updateLabels()
        }
    }
    
    var green: CGFloat = 1.00
    {
        didSet {
            updateLabels()
        }
    }
    
    var blue: CGFloat = 1.00 {
        didSet {
            updateLabels()
        }
    }
    
    var alpha: CGFloat = 1.00 {
        didSet {
            updateLabels()
        }
    }
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    
    
    @IBAction func redValueChanged(_ sender: Any) {
        red = CGFloat(redSlider.value)
    }
    
    @IBAction func greenValueChanged(_ sender: Any) {
        green = CGFloat(greenSlider.value)
    }
    
    @IBAction func blueValueChanged(_ sender: Any) {
        blue = CGFloat(blueSlider.value)
    }
    
    @IBAction func alphaValueChanged(_ sender: Any) {
        alpha = CGFloat(alphaSlider.value)
    }
    
    func updateLabels() {
        redLabel.text = "\(Int(255 * red))"
        greenLabel.text = "\(Int(255 * green))"
        blueLabel.text = "\(Int(255 * blue))"
        alphaLabel.text = "\(Int(255 * alpha))"
        
        let color = Color.init(red: red, green: green, blue: blue, alpha: alpha)
        
        previewView.backgroundColor = color.color
    }
}
