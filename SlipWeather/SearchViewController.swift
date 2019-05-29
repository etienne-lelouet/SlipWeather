//
//  SearchViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 28/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedCity: City? = nil;
    @IBOutlet weak var SearchField: CustomSearchTextField!

    @IBOutlet weak var favoritesTableView: UITableView!
    let textCellIdentifier = "FavoriteCityCell"
    var favoritesList = [City]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        SearchField.performSegueOnSelect = {
            (c: City) in
            self.selectedCity = c
            self.performSegue(withIdentifier: "selectedCitySegue", sender: self)
        }
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.tableFooterView = UIView()
    }
    
    func fetchDataForFavoritesTable() {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let fetchedResults = try self.context.fetch(request)
            
            for data in fetchedResults as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let country = data.value(forKey: "country") as! String
                let identifier = data.value(forKey: "identifier") as! Int64
                self.favoritesList.append(City(identifier: identifier, name: name, country: country))
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "selectedCitySegue":
            return self.selectedCity != nil
        default:
            return true
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is WeatherViewController
        {
            let weatherVC = segue.destination as? WeatherViewController
            weatherVC?.city = self.selectedCity
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as UITableViewCell
        let city = favoriteCityArray[indexPath.row];
        cell.textLabel?.text = city
        return cell
    }
}
