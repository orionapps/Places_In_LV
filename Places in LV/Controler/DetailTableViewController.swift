//
//  DetailTableViewController.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 10/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    
//    var places = [Places]()
//
//    var selectedCategory : Categories? {
//        didSet{
//            //loadPlaces()
//        }
//    }
    
    var locationNamesArray = [String]()
    var locationInfoArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationInfoArray.count
    }
    
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationNameCell", for: indexPath)
        

        
        
        cell.textLabel?.text = locationNamesArray[indexPath.row]

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        //print(locationNamesArray[indexPath.row])
        
        destVC.locationName = locationNamesArray[indexPath.row]
        destVC.locationInfo = locationInfoArray[indexPath.row]
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
