//
//  ViewController.swift
//  Currencies
//
//  Created by Ruslan Mavlyutov on 01/11/2018.
//  Copyright © 2018 Ruslan Mavlyutov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        priceLabel.text = "..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

