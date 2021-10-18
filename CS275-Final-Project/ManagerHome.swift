//
//  ManagerHome.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit

class ManagerHomeViewController: UIViewController {
    
    // Labels for home
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var lineLabel: UILabel!

    
    // For start view for capacity and label
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capacityLabel.text = "0"
        lineLabel.text = "0"
        
    }
}
