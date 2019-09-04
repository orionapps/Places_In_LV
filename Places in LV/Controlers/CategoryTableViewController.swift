//
//  CategoryTableViewController.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 04/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var segueIdentifiers = ["goToSightseengs", "goToNatureAndParks", "goToMuseums"]
    var categoriesArray = ["Sightseengs", "Nature And Parks", "Museums"]
    var allLocations: CategoryList?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    //MARK: - Fetch Data
    
    func fetchData() {
        
        guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "json") else {
            return
        }
        do {
            
            let data = try Data(contentsOf: urlPath)
            self.allLocations = try JSONDecoder().decode(CategoryList.self, from: data)
        }catch {
            
            print(error)
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoriesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        
        if indexPath.row == 0 && allLocations?.locationID == 0 {
            
            if let locationName = allLocations?.locationName {
                
                destVC.locationNamesArray.append(locationName)
            }
            
            if let locationInfo = allLocations?.locationInfo {
                
                destVC.locationInfoArray.append(locationInfo)
            }
        }  else if indexPath.row == 1 && allLocations?.locationID == 1{
            
            if let locationName = allLocations?.locationName {
                
                destVC.locationNamesArray.append(locationName)
            }
            
            if let locationInfo = allLocations?.locationInfo {
                
                destVC.locationInfoArray.append(locationInfo)
            }
        } else if indexPath.row == 2 && allLocations?.locationID == 2{
            
            if let locationName = allLocations?.locationName {
                
                destVC.locationNamesArray.append(locationName)
            }
            
            if let locationInfo = allLocations?.locationInfo {
                
                destVC.locationInfoArray.append(locationInfo)
            }
        }
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
