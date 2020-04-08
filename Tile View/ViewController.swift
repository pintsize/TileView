//
//  ViewController.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/4/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tileEditorView: TileEditorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPixels()
        addSwatch(with: .black)
        addSwatch(with: .blue)
        addSwatch(with: .brown)
        addSwatch(with: .lightGray)
        addSwatch(with: .gray)
        addSwatch(with: .darkGray)
        addSwatch(with: .green)
        addSwatch(with: .brown)
        addSwatch(with: .cyan)
        addSwatch(with: .magenta)
        addSwatch(with: .orange)
        addSwatch(with: .purple)
        addSwatch(with: .red)
        addSwatch(with: .white)
        addSwatch(with: .yellow)
        
        #if targetEnvironment(macCatalyst)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        #endif
    }
    
    var documentsDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    var saveFileURL: URL? {
        
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectory = urls.first {
            return documentDirectory.appendingPathComponent("image.json")
        } else {
            print("Couldn't get documents directory!")
        }
        
        return nil
    }
    
    func savePixels() {
        guard let fileURL = saveFileURL else { return }
        do {
            let jsonData = try JSONEncoder().encode(tileEditorView.pixels)
            try jsonData.write(to: fileURL)

        } catch let error {
            print("error: \(error)")
        }

    }
    
    func loadPixels() {
        guard let fileURL = saveFileURL else { return }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            
            let pixels = try JSONDecoder().decode([[Pixel]].self, from: jsonData)

            tileEditorView.pixels = pixels
            
        } catch let error {
            print("error: \(error)")
        }

    }
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    @IBAction func undo(_ sender: UIBarButtonItem) {
        guard let undoManager = undoManager else { return }
        undoManager.undo()
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
        guard let undoManager = undoManager else { return }
        undoManager.redo()
    }
    
    @objc func setPaintColor(_ sender: UIButton) {
        tileEditorView.paintColor = sender.backgroundColor
    }
    
    
    // NOTE: This kinda stuff will all be replaced with a proper color/tool picker UI later on
    @IBAction func setToolMode(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            tileEditorView.toolMode = .paint
        } else if segmentedControl.selectedSegmentIndex == 1 {
            tileEditorView.toolMode = .floodFill
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            tileEditorView.toolMode = .erase
        }
        
        savePixels() 
    }
    
    func addSwatch(with color: UIColor) {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = color
        button.addTarget(self, action: #selector(ViewController.setPaintColor(_:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 1/1).isActive = true
        stackView.addArrangedSubview(button)
    }
    
}

