//
//  WeatherViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 27/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather
import CoreData

class WeatherViewController: UIViewController {
    
    var city: City!
    var isFavorite: Bool? = nil
    var weatherClient: WeatherClient?
    var selectedView: Int = 0
    var isAllFetched: Bool = false
    var isLoaded: Bool = false
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var isFavoriteSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var DisplaySegmentedBar: UISegmentedControl!
    @IBOutlet weak var WeatherContainer: UIView!
    var dayVC: DayWeatherViewController!
    var weekVC: WeekWeatherViewController!
    var loadingVC: UIViewController!
    
    override func viewDidLoad() {
        navigationBar.topItem?.title = city.name + ", " + city.country
        setupChildViews()
        setupSegmentedControl()
        loadFavorite()
        DispatchQueue.global(qos: .userInitiated).async{
            self.weatherClient = WeatherClient(key: "2dd8f457671f8f42cf85af02cf47ca48")
            DispatchQueue.main.async{
                self.isLoaded = true
                self.getData(forView: self.selectedView)
            }
        }
    }
    
    //Fonction de gestion des vues multiples
    
    func setupChildViews() {
        self.dayVC = self.storyboard?.instantiateViewController(withIdentifier: "dayVC") as? DayWeatherViewController
        self.weekVC = self.storyboard?.instantiateViewController(withIdentifier: "weekVC") as? WeekWeatherViewController
        self.loadingVC = self.storyboard?.instantiateViewController(withIdentifier: "loadingVC")
        
        self.addChild(self.dayVC)
        self.addChild(self.weekVC)
        self.addChild(self.loadingVC)
        loadingVC.view.frame = self.WeatherContainer.bounds
        self.WeatherContainer.addSubview(loadingVC.view)
    }
    
    func setupSegmentedControl() {
        DisplaySegmentedBar.removeAllSegments()
        DisplaySegmentedBar.insertSegment(withTitle: "Today", at: 0, animated: true)
        DisplaySegmentedBar.insertSegment(withTitle: "Week", at: 1, animated: true)
        DisplaySegmentedBar.selectedSegmentIndex = 0
        DisplaySegmentedBar.setEnabled(true, forSegmentAt: 0)
        DisplaySegmentedBar.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        self.selectedView = sender.selectedSegmentIndex
        if (self.isLoaded) {
            for sView in self.WeatherContainer.subviews {
                sView.removeFromSuperview()
            }
            switch sender.selectedSegmentIndex {
            case 0:
                self.dayVC.view.frame = self.WeatherContainer.bounds
                self.WeatherContainer.addSubview(self.dayVC.view)
            case 1:
                self.weekVC.view.frame = self.WeatherContainer.bounds
                self.WeatherContainer.addSubview(self.weekVC.view)
            default:
                self.dayVC.view.frame = self.WeatherContainer.bounds
                self.WeatherContainer.addSubview(self.dayVC.view)
            }
        }
    }
    
    func getData(forView: Int) -> Void {
        weatherClient?.weather(for: self.city, completion: { (forecast: Forecast?) in
            if let unwrappedForecast = forecast {
                self.dayVC.dayWeather = []
                self.dayVC.displayedWeather =  unwrappedForecast
                DispatchQueue.main.async {
                    self.selectionDidChange(self.DisplaySegmentedBar) //Oui bon...
                }
            } else {
                print("error when fetching")
            }
        })
        weatherClient?.forecast(for: self.city, completion: { (forecast: [Forecast]?) in
            if let unwrappedForecast = forecast {
                self.isAllFetched = true
                let forecastPerDay: [[Forecast]] = self.splitForecastByDay(unwrappedForecast)
                self.weekVC.weekWeather = forecastPerDay
                DispatchQueue.main.async {
                    self.selectionDidChange(self.DisplaySegmentedBar) //Oui bon...
                }
            } else {
                print("error when fetching")
            }
        })
    }
    
    func splitForecastByDay(_ forecastArray: [Forecast]) -> [[Forecast]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var lastDay: String = ""
        var currentDay: String = ""
        var forecastByDay: [[Forecast]] = [[Forecast]]()
        var maxDay = 7;
        var i = -1; // bout de scotch
        for forecast in forecastArray {
            print(forecast.date)
            if (maxDay != 0) {
                currentDay = dateFormatter.string(from: forecast.date)
                if (lastDay != currentDay) { // Si on est sur un jour différent
                    maxDay = maxDay - 1
                    lastDay = currentDay
                    forecastByDay.append([forecast])
                    i = i + 1
                } else {
                    forecastByDay[i].append(forecast)
                }
            } else {
                break;
            }
        }
        return forecastByDay
    }
    
    // Fonctions de gestion des favoris
    func loadFavorite() {
        do {
            let request = NSFetchRequest<Favorite>(entityName: "Favorite")
            request.predicate = NSPredicate(format: "identifier == %lld", city.identifier)
            request.fetchLimit = 1
            let fetchedResult = try self.context.fetch(request)
            if (fetchedResult.count == 1) {
                isFavorite = true
                isFavoriteSwitch.isOn = true
            } else {
                isFavorite = false
                isFavoriteSwitch.isOn = false
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    @IBAction func OnExit(_ sender: Any) {
        performSegue(withIdentifier: "BackOnSearchSegue", sender: self)
    }
    
    @IBAction func cityWasFaved(_ sender: Any) {
        let unwrappedIsFavorite = isFavorite!
        if (unwrappedIsFavorite) {
            do {
                let request = NSFetchRequest<Favorite>(entityName: "Favorite")
                request.predicate = NSPredicate(format: "identifier == %lld", city.identifier)
                request.fetchLimit = 1
                let fetchedResult = try self.context.fetch(request)
                self.context.delete(fetchedResult[0])
                isFavorite = false
                isFavoriteSwitch.isOn = false
            } catch {
                print("Failed deleting from favorites")
                isFavorite = true
                isFavoriteSwitch.isOn = true
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
            let favorite = Favorite(entity: entity!, insertInto: context)
            favorite.setValue(self.city.name, forKey: "name")
            favorite.setValue(self.city.country, forKey: "country")
            favorite.setValue(self.city.identifier, forKey: "identifier")
            do {
                try context.save()
                isFavorite = true
                isFavoriteSwitch.isOn = true
            } catch {
                print("Failed saving to favorites")
                isFavorite = false
                isFavoriteSwitch.isOn = false
            }
        }
    }
}
