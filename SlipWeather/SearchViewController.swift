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

class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var TemperatureValue: UILabel!
    @IBOutlet weak var WeatherTitle: UILabel!
    @IBOutlet weak var WeatherLogo: UIImageView!
}

extension City {
    init(name: String, country: String, identifier: Int64) {
        self.name = name
        self.country = country
        self.identifier = identifier
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedCity: City? = nil;
    @IBOutlet weak var SearchField: CustomSearchTextField!

    @IBOutlet weak var favoritesTableView: UITableView!
    let textCellIdentifier = "FavoriteCityCell"
    var favoritesList = [Favorite]()
    var currentFavoriteForecasts = [Forecast]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        SearchField.performSegueOnSelect = {
            (c: City) in
            self.selectedCity = c
            self.performSegue(withIdentifier: "selectedCitySegue", sender: self)
        }
        
        SearchField.fetchDataWhenReady = {
            for favoriteCity in self.favoritesList {
                let city = City(name: favoriteCity.name!, country: favoriteCity.country!, identifier: favoriteCity.identifier)
                self.SearchField.weatherClient?.weather(for: city, completion: { (forecast: Forecast?) in
                    if let unwrappedForecast = forecast {
                        self.currentFavoriteForecasts.append(unwrappedForecast)
                        if (self.currentFavoriteForecasts.count == self.favoritesList.count) {
                            DispatchQueue.main.async{
                                self.favoritesTableView.reloadData()
                            }
                        }
                    } else {
                        print("fetch error")
                    }
                })
            }
        }
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.tableFooterView = UIView()
        fetchDataForFavoritesTable()
    }
    
    func fetchDataForFavoritesTable() {
        do {
            let request = NSFetchRequest<Favorite>(entityName: "Favorite")
            let fetchedResults = try self.context.fetch(request)
            for favorite in fetchedResults {
                self.favoritesList.append(favorite)
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
    
    //TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! FavoritesTableViewCell
        let city: Favorite = favoritesList[indexPath.row]
        let name = city.name ?? String.init()
        let country = city.country ?? String.init()
        cell.CityName?.text = name + ", " + country
        if (currentFavoriteForecasts.count > 0) {
            let forecast: Forecast = currentFavoriteForecasts[indexPath.row];
            cell.TemperatureValue?.text = String(forecast.temperature) + "°C"
            cell.WeatherTitle?.text = forecast.weather[0].title
            cell.WeatherLogo?.image = forecast.weather[0].icon
            return cell
        } else {
            cell.TemperatureValue?.text = "placeholder"
            cell.WeatherTitle?.text = "placeholder"
            cell.WeatherLogo?.image = UIImage(named: "placeholder")
            return cell
        }
    }
    
    // MARK: TableViewDelegate methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = favoritesList[indexPath.row]
        self.selectedCity = City(name: city.name!, country: city.country!, identifier: city.identifier)
        self.performSegue(withIdentifier: "selectedCitySegue", sender: self)
    }
}
