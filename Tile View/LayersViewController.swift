//
//  LayersViewController.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/13/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

import UIKit

final class LayersViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "LayerCell", for: indexPath)
    }
    
}
