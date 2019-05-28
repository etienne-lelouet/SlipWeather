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

    @IBOutlet weak var isFavoriteSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        navigationBar.topItem?.title = city.name + ", " + city.country
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityFromCore")
            request.predicate = NSPredicate(format: "identifier == %lld", city.identifier)
            request.fetchLimit = 1
            let fetchedResults = try context.fetch(request)
            if (fetchedResults.count == 1) {
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
