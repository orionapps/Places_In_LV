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
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var selectedCategory : Categories?
    
    var allLocations: CategoryList?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let destinatinationVC = segue.destination as! DetailTableViewController
//
//
//
//    }
    
    
//    func loadSavedLocations(with request: NSFetchRequest<Categories> = Categories.fetchRequest()) {
//
//        do {
//            categoriesArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }

}
