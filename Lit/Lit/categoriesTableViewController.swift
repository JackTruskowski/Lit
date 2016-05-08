//
//  categoriesTableViewController.swift
//  Lit
//
//  Created by Simon Moushabeck on 5/7/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class categoriesTableViewController: UITableViewController {

    @IBOutlet var categoryPicker: UITableView!
    var categories: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categories = ["Blues", "Jazz", "Rock", "Pop", "Classical", "Slam", "Shoe Gazing"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}
