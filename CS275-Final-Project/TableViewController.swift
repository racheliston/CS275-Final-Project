//
//  TableViewController.swift
//  CS275-Final-Project
//
//  Created by Rachel Liston on 11/18/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class TableViewController: UITableViewController {
    
    var database: Firestore!
    
    // list of all bars to be included in list
    let barItems = ["Name", "Ruben James","Ales","Akes","Red Square"]
    
    var barNames = [String]()
    var barInfo = [Any]()
    
    //var stringBarInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("\(barInfo)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
                
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return barNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath)

        // left text label that holds the bar name
        cell.textLabel?.text = barNames[indexPath.row]
        
        // Get the bar line size
        let barData = barInfo[indexPath.row]
        
        // Split the data
        print("\(barData)")
        
        //var capacity = 0
        
//        guard let capacity = barData["capacity"] as? [Any] else {
//            return cell
//        }
        var tempCap = 0
        var curCap = 0
        if let cap = barData as? [String: Any] {
            tempCap = (cap["capacity"] as! NSString).integerValue
        }
        
        if let cap2 = barData as? [String: Any] {
            curCap = (cap2["currentCapacity"] as! NSString).integerValue
        }
        
        let capacity = String(tempCap)
        let curCapacity = String(curCap)
        
        let totalCapacity = curCapacity + " / " + capacity
        
        print("\(capacity)")
        
        //let stringBarInfo = barInfo.map{ $0 as? String }

        // right text label that holds the line size
        //cell.detailTextLabel?.text = stringBarInfo[indexPath.row]
        cell.detailTextLabel?.text = totalCapacity

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
