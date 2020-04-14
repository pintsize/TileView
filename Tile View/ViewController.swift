//
//  ViewController.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/4/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

let fileName: String = "TileSet.json"

class ViewController: UIViewController {
    
    @IBOutlet weak var tileEditorView: TileEditorView!

    /*
    @IBOutlet weak var topLeftTileEditorView: TileEditorView!
    @IBOutlet weak var topTileEditorView: TileEditorView!
    @IBOutlet weak var topRightTileEditorView: TileEditorView!
    
    @IBOutlet weak var leftTileEditorView: TileEditorView!
    @IBOutlet weak var tileEditorView: TileEditorView!
    @IBOutlet weak var rightTileEditorView: TileEditorView!
    
    @IBOutlet weak var bottomLeftTileEditorView: TileEditorView!
    @IBOutlet weak var bottomTileEditorView: TileEditorView!
    @IBOutlet weak var bottomRightTileEditorView: TileEditorView!
    
 */
    @IBOutlet weak var upperLeftEdgeButton: TileChooserButton!
    @IBOutlet weak var upEdgeButton: TileChooserButton!
    @IBOutlet weak var upperRightEdgeButton: TileChooserButton!
    
    @IBOutlet weak var leftEdgeButton: TileChooserButton!
    @IBOutlet weak var centerButton: TileChooserButton!
    @IBOutlet weak var rightEdgeButton: TileChooserButton!
    
    @IBOutlet weak var lowerLeftEdgeButton: TileChooserButton!
    @IBOutlet weak var downEdgeButton: TileChooserButton!
    @IBOutlet weak var lowerRightEdgeButton: TileChooserButton!
    
    @IBOutlet weak var upperLeftCornerButton: TileChooserButton!
    @IBOutlet weak var upperRightCornerButton: TileChooserButton!
    @IBOutlet weak var lowerLeftCornerButton: TileChooserButton!
    @IBOutlet weak var lowerRightCornerButton: TileChooserButton!
    
    @IBOutlet weak var tileNameLabel: UILabel!
    
    var tileSet: TileSet8Sided = TileSet8Sided()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPixels()
        
        setupSwatches()
        
        upperLeftEdgeButton.tileIdentifier = .upperLeftEdge
        upEdgeButton.tileIdentifier = .upEdge
        upperRightEdgeButton.tileIdentifier = .upperRightEdge
        
        leftEdgeButton.tileIdentifier = .leftEdge
        centerButton.tileIdentifier = .center
        rightEdgeButton.tileIdentifier = .rightEdge
        
        lowerLeftEdgeButton.tileIdentifier = .lowerLeftEdge
        downEdgeButton.tileIdentifier = .downEdge
        lowerRightEdgeButton.tileIdentifier = .lowerRightEdge
        
        upperLeftCornerButton.tileIdentifier = .upperLeftCorner
        upperRightCornerButton.tileIdentifier = .upperRightCorner
        lowerLeftCornerButton.tileIdentifier = .lowerLeftCorner
        lowerRightCornerButton.tileIdentifier = .lowerRightCorner
        
        tileNameLabel.text = ""
        #if targetEnvironment(macCatalyst)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        #endif
    }

    fileprivate func setupSwatches() {
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
    }
    
    var documentsDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    var saveFileURL: URL? {
        
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectory = urls.first {
            return documentDirectory.appendingPathComponent(fileName)
        } else {
            print("Couldn't get documents directory!")
        }
        
        return nil
    }
    
    func savePixels() {
        guard let fileURL = saveFileURL else { return }
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [.prettyPrinted]
            let jsonData = try jsonEncoder.encode(tileSet)
            try jsonData.write(to: fileURL)

        } catch let error {
            print("error: \(error)")
        }

    }
    
    func loadPixels() {
        guard let fileURL = saveFileURL else { return }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            
            let decodedTileSet = try JSONDecoder().decode(TileSet8Sided.self, from: jsonData)
            
            tileSet = decodedTileSet
            
            presentTile(with: .center, in: tileEditorView, updateName: true)
            /*
            presentTile(with: .upperLeftEdge, in: topLeftTileEditorView)
            presentTile(with: .upEdge, in: topTileEditorView)
            presentTile(with: .upperRightEdge, in: topRightTileEditorView)
            
            presentTile(with: .leftEdge, in: leftTileEditorView)
            presentTile(with: .center, in: tileEditorView, updateName: true)
            presentTile(with: .rightEdge, in: rightTileEditorView)
            
            presentTile(with: .lowerLeftEdge, in: bottomLeftTileEditorView)
            presentTile(with: .downEdge, in: bottomTileEditorView)
            presentTile(with: .lowerRightEdge, in: bottomRightTileEditorView)
            */
        } catch let error {
            print("error: \(error)")
        }

    }
    @IBOutlet weak var stackView: UIStackView!
    
    
    func presentTile(with identifier: TileIdentifier, in tileView: TileEditorView, updateName: Bool = false) {
        guard let tile = tileSet.tile(with: identifier) else { return }
        tileNameLabel.text = identifier.localizedName
        
        tileView.tile = tile
    }
    
    @IBAction func setTile(_ tileChooserButton: TileChooserButton) {
        guard let identifier = tileChooserButton.tileIdentifier else { return }
        presentTile(with: identifier, in: tileEditorView, updateName: true)
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
        tileEditorView.paintColor = sender.backgroundColor?.color
    }
    
    
    // NOTE: This kinda stuff will all be replaced with a proper color/tool picker UI later on
    @IBAction func setToolMode(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            tileEditorView.toolMode = .paint
        } else if segmentedControl.selectedSegmentIndex == 1 {
            tileEditorView.toolMode = .floodFill
        }
        else if segmentedControl.selectedSegmentIndex == 2 {
            tileEditorView.toolMode = .eraser
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

