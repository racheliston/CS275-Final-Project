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
    
    // Buttons for home
    @IBOutlet var capacityMinusButton: UIButton!
    @IBOutlet var capacityPlusButton: UIButton!
    @IBOutlet var lineMinusButton: UIButton!
    @IBOutlet var linePlusButton: UIButton!
    
    var totalCapacityValue: Int = 0
    var capacityValue: Int = 0
    var lineValue: Int = 0
    
    
    // For start view for capacity and label
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HARDCODED CAP VALUE
        totalCapacityValue = 50
        
        capacityLabel.text = "0 / \(totalCapacityValue)"
        lineLabel.text = "0"
        
    }
    
    // Increment capacity value if addition symbol is pressed
    @IBAction func incrementCap(_ sender: UIButton) {
        // Increment the value
        capacityValue += 1
        
        capacityLabel.text = String(capacityValue) + " / \(totalCapacityValue)"
    }
    
    @IBAction func decrementCap(_ sender: UIButton) {
        // Make sure capacity is not less than 0
        if capacityValue > 0 {
            // Decrement the value
            capacityValue -= 1
        }
                
        
        capacityLabel.text = String(capacityValue) + " / \(totalCapacityValue)"
    }
}
