//
//  SearchViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 28/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather

class SearchViewController: UIViewController {
    
    @IBOutlet weak var SearchField: CustomSearchTextField!
    var selectedCity: City? = nil;

    override func viewDidLoad() {
        print("loaded SearchViewController")
        SearchField.performSegueOnSelect = {
            (c: City) in
            self.selectedCity = c
            self.performSegue(withIdentifier: "selectedCitySegue", sender: self)
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
}
